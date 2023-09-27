*ssc install moremata, replace
*set scheme burd
*ssc install did_multiplegt
*ssc install reghdfe

set scheme plotplain


use "data/consip.dta", clear
include "code/intermediate/good-char.do"

local version1 $quantity, a(goodid##month_year goodid##PA_govtype) 
local version2 `goods_char' $quantity, a(goodid##month_year goodid##PA_govtype) 


reghdfe lprice post_consip `goods_char' $quantity if consip==0, absorb(id goodid month_year) cluster(id)
gen coeff_did1 = _b[post_consip]
gen se_did1 = _se[post_consip]
gen ub1 = coeff_did1 + 1.96*se_did1
gen lb1 = coeff_did1 - 1.96*se_did1



forvalues i=1/2{
	
	reghdfe lprice `version`i'' residuals(price_res`i')
	did_multiplegt price_res`i' id year post_consip if consip==0, cluster(id) breps(10) recat_treatment(goodid) seed(2112) weight(id) 
	local x = `i'+1
	gen coeff_did`x' = e(effect_0)
	gen se_did`x' = e(se_effect_0)
	gen ub`x' = coeff_did`x' + 1.96*se_did`x'
	gen lb`x' = coeff_did`x' - 1.96*se_did`x'
	
	
}




keep coeff_did*  ub* lb* se_*
gen id=_n                     
reshape long coeff_did ub lb se_did, i(id) j(u)

 drop id u  
 duplicates drop
 gen versions = _n
 drop if versions==2
 
 
twoway (rcap ub lb versions,  sort lcolor(gs10) lpattern(dash solid)) ||  (scatter coeff_did versions, sort mcolor(sea) mstyle(oh)),  xscale(range(0.8(1)4))  yscale(range(0.2(0.1)-1.5))  xlabel(0 " "  1 "Baseline" 3 "Heterogenous DiD" 4 " ",  angle(45)) xlabel( 3.1 "Controls", add nogrid noticks)  ylabel(0.2 "0.2" 0 "0"  -0.2 "-0.2" -0.4 "-0.4"  -0.6 "-0.6" -0.8 "-0.8" -1 "-1.0" -1.2 "-1.2" -1.4 "-1.4",  angle(45)) xtitle(" ") legend (off)

 
graph export output/figures/comparison-coefficient-estimates.pdf, replace 
