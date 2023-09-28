use "data/consip.dta", clear

include "code/intermediate/good-char.do"
set scheme plotplain

local version1 ", absorb(id goodid month_year)  cluster(id)  residuals(residuals) "

local version2 "`lasso_char', absorb(id goodid month_year)  cluster(id)  residuals(residuals) "

forvalues i=1(1)2{
    preserve
    reghdfe lprice $quantity `version`i''
    gen predicted_prices =  lprice -residuals

    twoway (kdensity residuals if post_consip==0, lcolor(plr1) lwidth(medthick) lpattern(dash_dot)) ///
           (kdensity residuals if post_consip==1 & consip==1, lcolor(gs13) ) ///
           (kdensity residuals if post_consip==1 & consip==0, lcolor(plb1) lwidth(medthick)) ///
        , graphregion(color(white)) legend(order(1 "Pre-Consip" 2 "Post-Consip: Consip" 3 "Post-Consip: out-of-Consip") rows(2) size(med) pos(6))  ///
        ytitle("Density", size(med)) ///
        xtitle("Residualized prices", size(med))  ///
        ylabel(, labsize(med)) ///
        xlabel(, labsize(med))  
        graph export "output/figures/PriceDensityPrePost`i'.pdf", replace 
    restore
}
