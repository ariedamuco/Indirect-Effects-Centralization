
set scheme plotplain


clear all
do "code/tables/fe-quartiles.do"



keep coeff_did*  ub* lb* se_*
gen id=_n                     
reshape long coeff_did ub lb se_did, i(id) j(u)

 drop id u  
 duplicates drop
 gen versions = _n
 
 
 
twoway (rarea ub lb versions, color(gs10%20)  sort lcolor(gs10) lpattern(dash solid) ) ||  (scatter coeff_did versions, connect(l) lpattern(dash) lcolor(gs10) sort mcolor(sea) mstyle(oh)),  xscale(range(0.8(1)3.5))   xlabel(1 "1st Quartile"  2 "2nd Quartile"  3 "3d Quartile"  4 "4th Quartile"  ,  angle(45)) xtitle(" ") legend (off)


 
graph export output/figures/competence.pdf, replace 
