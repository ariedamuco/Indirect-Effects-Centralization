
set scheme plotplain

local samples all high low

use "data/consip.dta", clear
drop if consip==1 

include "code/intermediate/good-char.do"

gen date_m=ym(year, month)
gen date_h=hofd(dofm(date_m))
gen date_q=qofd(dofm(date_m))
format date_h %th

gen edeal1 =qofd(deal_start1)



****** Deal Start
gen complex= inlist(good, 1, 5, 10, 13)
gen simple= !inlist(good, 1, 5, 10, 13)
gen all = complex==1 | simple==1
/* ----------------------    Event-Study Analyses Appendix Tables   ----------------------*/


preserve
drop if date>=deal_start2

gen recenter = .
replace recenter = date_q - edeal1 
replace recenter = -1 if date<deal_start1 & recenter==0 

keep if recenter>=-7 & recenter<=11
gen recenter_adj=recenter+7

label values recenter_adj recenter_adj  

foreach var in all complex simple{
	qui areg lprice ib6.recenter_a i.good $quantity $lasso_char if `var'==1, a(id) vce(cluster id)
	eststo event1_`var' 

	estadd local obs=e(N) 
	estadd local id "Yes", replace
	estadd local good "Yes", replace
	estadd local controls "Yes", replace
}

restore



****** Deal End
preserve
gen ldeal1 =qofd(deal_end1)
gen ldeal2 =qofd(deal_end2)
gen ldeal3 =qofd(deal_end3)

gen recenter = .
replace recenter = date_q - ldeal1 if date<deal_start2                      
replace recenter = -1 if date<=deal_end1 & recenter==0
replace recenter= . if recenter<0 & activeD==0


keep if recenter>=-7 & recenter<=4
gen recenter_adj=recenter+7

label values recenter_adj recenter_adj  

qui areg lprice ib6.recenter_a i.good $quantity $lasso_char , a(id) vce(cluster id)

eststo event3
	
estadd local obs=e(N) 
estadd local id "Yes", replace
estadd local good "Yes", replace
estadd local controls "Yes", replace
	
restore	

esttab event1_all event3 event1_complex event1_simple   ///
	using  "output/tables/event_all.tex", ///
	se(3) b(3) s(obs id good controls, ///
	label(  "Observations" "PB fixed effects" "Good fixed effects"  "Controls"  ))  ///
	coeflabels(_cons "Constant" 0.recenter_adj "Quarter -7" 1.recenter_adj "Quarter -6" 2.recenter_adj "Quarter -5" 3.recenter_adj "Quarter -4" 4.recenter_adj "Quarter -3" 5.recenter_adj "Quarter -2" 6.recenter_adj "Quarter -1" 7.recenter_adj "Quarter 0" 8.recenter_adj "Quarter +1" 9.recenter_adj "Quarter +2" 10.recenter_adj "Quarter +3" 11.recenter_adj "Quarter +4" 12.recenter_adj "Quarter +5" 13.recenter_adj "Quarter +6" 14.recenter_adj "Quarter +7" 15.recenter_adj "Quarter +8" 16.recenter_adj "Quarter +9" 17.recenter_adj "Quarter +10" 18.recenter_adj "Quarter +11") ///
	nostar nonotes ///
    mgroups("Main Results" "Heterogeneity by good-type" , ///
	pattern(1 0 1 0)  prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}) )   ///
	mtitles ("Deal Start" "Deal End" "Complex" "Simple") ///
	drop(*.good $quantity $lasso_char) replace
