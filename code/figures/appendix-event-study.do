set scheme plotplain

use "data/consip.dta", clear
drop if consip==1 

include "code/intermediate/good-char.do"
gen date_q=qofd(dofm(ym(year, month)))
gen edeal1 =qofd(deal_start1)

****** End of a deal: version revision
preserve
gen ldeal1 =qofd(deal_end1)
gen ldeal2 =qofd(deal_end2)
gen ldeal3 =qofd(deal_end3)

gen recenter_end1 = .
replace recenter_end1 = date_q - ldeal1 if date<deal_start2                      
replace recenter_end1 = -1 if date<=deal_end1 & recenter_end1==0
replace recenter_end1= . if recenter_end1<0 & activeD==0

gen recenter_end2 = .
replace recenter_end2 = date_q - ldeal2 if date>deal_end1 & date<deal_start3                      
replace recenter_end2 = -1 if date<=deal_end2 & recenter_end2==0
replace recenter_end2= . if recenter_end2<0 & activeD==0

gen recenter_end3 = .
replace recenter_end3 = date_q - ldeal3 if date>deal_end2              
replace recenter_end3 = -1 if date<=deal_end3 & recenter_end3==0
replace recenter_end3= . if recenter_end3<0 & activeD==0
replace recenter_end3= . if recenter_end3>=0 & activeD==1

gen centering_var = recenter_end1 if recenter_end2==.&recenter_end3==.
replace centering_var = recenter_end2 if recenter_end2!=.&recenter_end3==.
replace centering_var=recenter_end3 if recenter_end3!=.

local first_lead -4
local last_lag 4
local normalize_lead = 0
include "code/intermediate/leads-lags.do"


twoway (scatter coef leads_lags , mcolor(navy) lcolor(navy)) (line ci_low leads_lags , lpattern(dash)) /*
*/(line ci_high leads_lags , lpattern(dash)), graphregion(color(white)) xline(5) yline(0, lcolor(black))  ylabel(-1(.2)1) xtitle("Quarters to/from event") xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3" 9 "4") legend(off)
graph export "output/figures/es_end_all.pdf", replace
	
