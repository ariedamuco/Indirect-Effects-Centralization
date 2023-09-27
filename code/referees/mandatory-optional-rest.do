do code/intermediate/previous-consip-purchase.do
include "code/intermediate/good-char.do"

gen post_mandatory = (post_consip==1&mandatory==1&activeD==1)
gen post_optional = (post_consip==1&mandatory==0&activeD==1)
gen post_rest = (post_consip==1&activeD==0)

recode post_consip 1=0 0=1, gen (pre_consip)

label variable post_optional "Post Consip x Optional (beta{1})"
label variable post_mandatory "Post Consip x Mandatory (beta{2})"
label variable pre_consip "Pre Consip"
label variable post_rest "Post Consip x No Active Deal (beta{3})"


local version1 " $quantity if consip == 0, absorb(id goodid month_year) cluster(id)" 
local version2 "`lasso_char' $quantity if consip == 0, absorb(id goodid month_year) cluster(id)"


 forvalues i=1(1)2{
	reghdfe lprice  post_optional post_mandatory post_rest `version`i''
		test post_optional = post_mandatory
		estadd scalar F1 = r(F), replace
		estadd scalar p1 = r(p), replace

		
		
		test post_mandatory = post_rest
		estadd scalar F2 = r(F), replace
		estadd scalar p2 = r(p), replace

		eststo ver`i'

		estadd local obs=e(N) 
		estadd local id "Yes", replace
		estadd local goodid "Yes", replace
		estadd local month_year  "Yes", replace
		estadd local controls "No", replace		
		
		else if `i' ==2  {	
			estadd local controls "Yes", replace

		}
	
}


esttab ver1 ver2 ///
	using  "output/tables/mandatory-optional-rest.tex", ///
	se(3) b(3) s(F1 p1 F2 p2 line obs id goodid month_year controls, ///
	label( "F-stat $ beta{1} = beta{2}$" "p-val $ beta{1} = beta{2}$" "F-stat $ beta{2} = beta{3}$"  "p-val $ beta{2} = beta{3}$" "\hline" "Observations" "PB fixed effects" "Good fixed effects" "Year-Month fixed effects"  "Controls"  ))  label  ///
	nostar nonotes ///
	nomtitles mgroups( " ", ///
	pattern(1 0 )  prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))  ///
	keep(post_optional post_mandatory post_rest) replace	




