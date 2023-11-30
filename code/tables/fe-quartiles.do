
clear all
do "code/config-file.do"
set scheme plotplain


use "data/consip.dta", clear
include "code/intermediate/good-char.do"

quietly areg lprice i.good i.month_year $quantity `lasso_char' if post_consip==0, a(id)
predict waste, d


 
local xtiles 4
xtile qtile = waste, nq(`xtiles')


label values qtile qtile

collapse (max) qtile , by(id)


tempfile qtile
save `qtile'

use "data/consip.dta", clear
include "code/intermediate/good-char.do"


merge  m:1  id  using `qtile'

tab qtile, gen (qtile)


 
 forvalues i=1(1)`xtiles'{
	gen int`i' = qtile`i'*post_consip

	
 }
 
label var int1 "Post Consip x 1st Quartile" 
label var int2 "Post Consip x 2nd Quartile" 
label var int3 "Post Consip x 3rd Quartile" 
label var int4 "Post Consip x 4th Quartile" 

 
local interactions int*


local version1 " , absorb(id goodid month_year)  cluster(id)"
local version2 "`lasso_char' `version1'"


 forvalues i=1(1)2{
 		reghdfe lprice int1 int2 int3 int4 $quantity `version`i''

		eststo ver`i'

		estadd local obs=e(N) 
		estadd local id "Yes", replace
		estadd local good "Yes", replace
		estadd local month_year  "Yes", replace
		estadd local controls "No", replace

		
		if `i' ==2 {
			estadd local controls  "Yes", replace

		}
			

		
}

esttab ver1 ver2    ///
	using  "output/tables/heterogenous_qtile.tex", ///
	se(3) b(3) s(obs id good month_year controls, ///
	label(  "Observations" "PB fixed effects" "Good fixed effects" "Month-Year fixed effects" "Controls"  ))  label  ///
	nostar nonotes ///
	nomtitles mgroups(" ", ///
	pattern(1 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span )   ///
	  keep( int1 int2 int3 int4 )   replace	
*int1 int2 int3 int4
	  
 forvalues i = 1(1)4{  
	gen coeff_did`i' = _b[int`i']
	gen se_did`i' = _se[int`i']
	gen ub`i' = coeff_did`i' + 1.96*se_did`i'
	gen lb`i' = coeff_did`i' - 1.96*se_did`i'
 }
