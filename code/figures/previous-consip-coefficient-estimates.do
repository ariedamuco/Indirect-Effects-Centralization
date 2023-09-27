set scheme plotplain
do "code/intermediate/previous-consip-purchase-random.do"

include "code/intermediate/good-char.do"


reghdfe lprice post_consip  `lasso_char' $quantity if consip==0, absorb(id goodid month_year)  cluster(id)
capture macro drop r(se) r(estimate)

gen coeff_did1 = _b[post_consip]
gen ub1 = _b[post_consip] + 1.654*_se[post_consip]
gen lb1 = _b[post_consip] - 1.654*_se[post_consip]

reghdfe lprice post_consip  tprevious_consip_mandatory tprevious_consip_non_mandatory  int_post_mandatory int_post_non_mandatory  `lasso_char' $quantity if consip==0, absorb(id goodid month_year)  cluster(id)

lincom  post_consip + int_post_mandatory
gen coeff_did2 = r(estimate)
gen ub2 = r(estimate)+ 1.654*r(se)
gen lb2 = r(estimate) - 1.654*r(se)


lincom  post_consip +  int_post_non_mandatory
gen coeff_did3 = r(estimate)
gen ub3 = r(estimate) + 1.654*r(se)
gen lb3 = r(estimate) - 1.654*r(se)

	
keep coeff_did*  ub* lb*

gen id=_n                     
reshape long coeff_did ub lb, i(id) j(u)


drop id u  
duplicates drop
gen versions = _n

twoway (rcap ub lb versions,  sort lcolor(gs10) lpattern(dash solid)) ||  (scatter coeff_did versions, sort mcolor(sea) mstyle(oh)),  xscale(range(0.8(1)3))  yscale(range(0.2(0.1)-0.6))  xlabel(1 "Baseline" 2 "Consip Experience"  3 "Consip Experience",  angle(45)) xlabel( 2.1 "Mandatory Regime"  3.1 "Optional Regime", add nogrid noticks)  ylabel(0.2 "0.2" 0 "0"  -0.2 "-0.2" -0.4 "-0.4"  -0.6 "-0.6",  angle(45)) xtitle(" ") legend (off)

graph export output/figures/coefficients-previous-purchase.pdf, replace 
