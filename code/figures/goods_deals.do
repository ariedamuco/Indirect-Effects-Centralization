*set scheme plotplain
use "data/consip.dta", clear
keep if consip==0

gen date_m=ym(year, month)

forvalues i = 1(1)4 {
	replace deal_start`i' = mofd(deal_start`i')
	replace deal_end`i' = mofd(deal_end`i')

    format deal_start`i' deal_end`i' %tm
}

keep good date_m deal_start? deal_end? activeD

preserve
keep good date_m activeD 
tempfile purchases
save `purchases'
restore

collapse deal_start? deal_end?, by(good date_m)

xtset good date_m 
sort good date_m 

tsfill, full

forvalues i = 1(1)4 {
	bysort good (deal_start`i'): replace deal_start`i' = deal_start`i'[_n-1] if missing(deal_start`i')
	bysort good (deal_end`i'): replace deal_end`i' = deal_end`i'[_n-1] if missing(deal_end`i')
}

label var date_m "Date"

merge 1:m good date_m using `purchases'


format date_m %tm

twoway  (rbar deal_start1 deal_end1 good , horizontal barwidth(.45) color(gs13)) (rbar deal_start2 deal_end2 good , horizontal barwidth(.45) color(gs13)) (rbar deal_start3 deal_end3 good , horizontal barwidth(.45) color(gs13))(scatter good date_m if _m==3 & date<deal_start1, mcolor(plr1) mlwidth(tiny) msize(tiny) mstyle(diamond)) (scatter good date_m if _m==3 & date>=deal_start1 & [activeD==0|activeD==1], mcolor(plb1) mstyle(diamond) mlwidth(tiny) msize(tiny)), xline(528 540) yla(1/13, valuelabel tlength(0) ang(h) labsize(small)) xlabel(468 "January 1999" 480 "January 2000" 492 "January 2001"  504 "January 2002" 516 "January 2002" 528 "January 2003" 540 "January 2004" 552 "January 2005", labsize(small)   angle(45)) ytitle("") xtitle("") plotr(m(large)) graphregion(fcolor(white)) legend(position(6) size(small) order( 4 "Pre-Consip purchases" 5 "Post-Consip purchases" 1 "Consip deals") cols(1))
graph export "output/figures/goods_deals.pdf", replace 

