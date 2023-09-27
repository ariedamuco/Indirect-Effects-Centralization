
set scheme plotplain

use "data/consip.dta", clear
include "code/intermediate/good-char.do"
egen month_year =group(month year)

xtset id 


capture program drop drop_one
program drop_one
	levelsof `1', local(levels)
	foreach l of local levels {
		reghdfe lprice post_consip   `lasso_char' if consip==0 & `1' != `l', absorb(id goodid month_year) cluster(id) 
		cap: drop b
		qui: gen coeff_`l'=_b[post_consip]
		qui: gen t_stat_`l' = _b[post_consip]/_se[post_consip]

	
	}

end

foreach var of varlist id goodid PA_govtype{
	preserve

	drop_one `var'
	
	keep coeff_* t_stat_*

	gen id=_n
	reshape long coeff_ t_stat_, i(id) j(i)
	drop id
	duplicates drop
	label var coeff_ "Coefficient Estimate"
	hist coeff_, bin(50) color(plb1)
	graph export "output/figures/drop-one-`var'.pdf", replace 
	restore
	
	
}




