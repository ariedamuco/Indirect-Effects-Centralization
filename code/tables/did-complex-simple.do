do "code/config-file.do"

use "data/consip.dta", clear
include "code/intermediate/good-char.do"
gen complex =(inlist(goodid, 3, 8, 17, 21))

label var complex "Complex Good"

generate post_complex =post_consip*complex

label var post_complex "Post Consip x Complex Good"
local version1 "if consip==0, absorb(id goodid month_year)  cluster(id)"
local version2 " if consip==0, absorb(id##goodid month_year) cluster(id)"
local version3 "if consip==0, absorb(id month goodid##month_year) cluster(id)" 
local version4 "`lasso_char' `version1'"



 forvalues i=1(1)4{
	reghdfe lprice post_consip post_complex $quantity `version`i''
		eststo ver`i'
eststo ver`i'

		estadd local obs=e(N) 
		estadd local id "Yes", replace
		estadd local goodid "Yes", replace
		estadd local month_year  "Yes", replace
		estadd local goodid_year  "No", replace
		estadd local goodid_id "No", replace
		estadd local controls "No", replace
			
		
					
		else if `i' ==2  {
			estadd local goodid_id "Yes", replace

		}
	
			
		else if `i' ==3  {
			estadd local goodid_year "Yes", replace

		}
		
		else if `i' >=4 {	
			estadd local controls "Yes", replace
		}
}



esttab ver1 ver2  ver3 ver4   ///
	using  "output/tables/did-complex-simple.tex", ///
	se(3) b(3) s(obs id goodid month_year goodid_id  goodid_year  controls, ///
	label(  "Observations" "PB fixed effects" "Good fixed effects" "Year-Month fixed effects" "Good x PB fixed effects"  "Good x  Year-Month fixed effects"  "Controls"  ))  label  ///
	nostar nonotes ///
	nomtitles mgroups(" ", ///
	pattern(1 0 0 0)  prefix(\multicolumn{@span}{c}{) suffix(}) span )   ///
	keep( post_consip post_complex) replace	
