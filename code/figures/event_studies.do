set scheme plotplain

use "data/consip.dta", clear
drop if consip==1 

local plots "(scatter coef leads_lags , mcolor(navy) lcolor(navy)) (line ci_low leads_lags , lpattern(dash)) (line ci_high leads_lags , lpattern(dash)), graphregion(color(white)) xline(8) yline(0, lcolor(black))  ylabel(-1(.2)1) xtitle("Quarters to/from event") xlabel(1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8" 17 "9" 18 "10" 19 "11") legend(off)"

local plots_end_deal "(scatter coef leads_lags , mcolor(navy) lcolor(navy)) (line ci_low leads_lags , lpattern(dash)) (line ci_high leads_lags , lpattern(dash)), graphregion(color(white)) xline(8) yline(0, lcolor(black))  ylabel(-1(.2)1) xtitle("Quarters to/from event") xlabel(1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4") legend(off)"

include "code/intermediate/good-char.do"

gen date_q=qofd(dofm(ym(year, month)))
gen edeal1 =qofd(deal_start1)


/* ----------------------    Event-Study Analyses----------------------*/

******First entry 
preserve
drop if date>=deal_start2

gen centering_var = .
replace centering_var = date_q - edeal1 
replace centering_var = -1 if date<deal_start1 & centering_var==0 

local first_lead -7
local last_lag 11
local normalize_lead 0

local sample_reg `if consip==0'
include "code/intermediate/leads-lags.do"

twoway `plots'
graph export "output/figures/es_entry_all.pdf", replace

restore

****** End of a deal
preserve

forvalues i = 1/3 {
	gen ldeal`i' =qofd(deal_end`i')	
}


gen recenter_end1 = .
replace recenter_end1 = date_q - ldeal1 if date<deal_start2                      
replace recenter_end1 = -1 if date<=deal_end1 & recenter_end1==0
replace recenter_end1= . if recenter_end1<0 & activeD==0
rename recenter_end1 centering_var
local first_lead -7
local last_lag 4
local normalize_lead = 0

include "code/intermediate/leads-lags.do"
twoway `plots_end_deal'
graph export "output/figures/es_end_first.pdf", replace
restore	

	
/* ----------    Event-Study Analysis for Types of Goods---------- */

gen complex= inlist(good, 1, 5, 10, 13)
gen simple= !inlist(good, 1, 5, 10, 13)
drop if date>=deal_start2
gen centering_var = .
replace centering_var = date_q - edeal1 
replace centering_var = -1 if date<deal_start1 & centering_var==0 


* Simple
preserve
local first_lead -7
local last_lag 11
local normalize_lead = 0
local sample_reg "if simple==1"
include "code/intermediate/leads-lags.do"
twoway `plots'
graph export output/figures/es_entry_simple.pdf, replace
restore

	
* Complex
preserve
local first_lead -7
local last_lag 8
local normalize_lead = 0
local sample_reg "if complex==1"
include "code/intermediate/leads-lags.do"
twoway `plots'
graph export "output/figures/es_entry_complex.pdf", replace
restore
