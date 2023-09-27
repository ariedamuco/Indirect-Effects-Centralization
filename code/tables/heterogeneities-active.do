
use "data/consip.dta", clear
include "code/intermediate/good-char.do"

local active0 "if [consip==0 & activeD==0&post_consip==1|consip==0&post_consip==0]"
local active1 "if [consip==0 & activeD==1&post_consip==1|consip==0&post_consip==0]"


local after_comma ",absorb(id goodid month_year) cluster(id)"


forvalues i = 0/1 {
 	
	reghdfe lprice post_consip $quantity  `active`i'' `after_comma'
	eststo ver`i'
	estadd local obs = e(N) 

	estadd local id "Yes", replace
	estadd local goodid "Yes", replace
	estadd local year_month  "Yes", replace
	estadd local controls "No", replace
	
	reghdfe lprice post_consip $quantity  `lasso_char' `active`i'' `after_comma'	
	eststo controls`i'
	estadd local obs = e(N) 

	estadd local id "Yes", replace
	estadd local goodid "Yes", replace
	estadd local year_month  "Yes", replace
	estadd local controls "Yes", replace
 }

 
 esttab ver1 controls1 ver0  controls0 ///
	using  "output/tables/heterogeneities-active.tex", ///
	se(3) b(3) s(obs id goodid year_month controls, ///
	label( "Observations" "PB fixed effects" "Good fixed effects" "Year-Month fixed effects"  "Controls"  ))  label  ///
	nostar nonotes ///
	nomtitles mgroups("Active Deal" "No Deal Active", ///
	pattern(1 0 1 0 )  prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))  ///
	keep(post_consip) replace	
