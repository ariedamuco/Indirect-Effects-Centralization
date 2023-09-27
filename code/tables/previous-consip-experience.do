
clear all
*use  "data/previous_consip.dta", clear
do "code/intermediate/previous-consip-purchase-random.do"

include "code/intermediate/good-char.do"

local version1 "if consip==0, absorb(id goodid month_year)  cluster(id)"
local version2 "`lasso_char' `version1'"

	
reghdfe lprice post_consip `version2'



 
 forvalues i=1(1)2{
	reghdfe lprice post_consip  tprevious_consip_mandatory tprevious_consip_non_mandatory  int_post_mandatory int_post_non_mandatory  $quantity `version`i''
		capture macro drop r(se) r(estimate)


	lincom  post_consip + int_post_mandatory
    estadd scalar est_lincom1 = r(estimate), replace
	estadd scalar se_lincom1 = r(se), replace
	
		capture macro drop r(se) r(estimate)

	lincom  post_consip +  int_post_non_mandatory
	estadd scalar est_lincom2 = r(estimate), replace
	estadd scalar se_lincom2 = r(se), replace

	capture macro drop r(se) r(estimate)


		eststo ver`i'

		estadd local obs = e(N) 
		estadd local id "Yes", replace
		estadd local goodid "Yes", replace
		estadd local month_year  "Yes", replace
		estadd local controls "No", replace

		 if `i' ==2{	
			estadd local controls "Yes", replace

			gen coeff_did1 = _b[post_consip]
			gen ub1 = _b[post_consip] + 1.96*_se[post_consip]
			gen lb1 = _b[post_consip] - 1.96*_se[post_consip]
			
			lincom  post_consip + int_post_mandatory
			gen coeff_did2 =r(estimate)
			gen ub2 = r(estimate)+ 1.96*r(se)
			gen lb2 = r(estimate) - 1.96*r(se)
			
			
			lincom  post_consip +  int_post_non_mandatory
			gen coeff_did3 =r(estimate)
			gen ub3 = r(estimate) + 1.96*r(se)
			gen lb3 = r(estimate) - 1.96*r(se)

	

		
				
}
 }

esttab ver1 ver2 ///
	using  "output/tables/previous_consip_purchase.tex", ///
	se(3) b(3) s(est_lincom1  se_lincom1  est_lincom2  se_lincom2  line obs id goodid month_year controls, ///
	label( "Estimate $ beta{1} + beta{M} $ " "SE $ beta{1} + beta{M} $"  "Estimate $ beta{1} + beta{O} $ " "SE $ beta{1} + beta{O} $" "\hline" "Observations" "PB fixed effects" "Good fixed effects" "Year-Month fixed effects"  "Controls"  ))  label  ///
	nostar nonotes ///
	nomtitles mgroups(" ", ///
	pattern(1 0)  prefix(\multicolumn{@span}{c}{) suffix(}) span)  ///
	keep(post_consip tprevious_consip_mandatory tprevious_consip_non_mandatory  int_post_mandatory int_post_non_mandatory) replace	
