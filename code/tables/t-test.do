

use "data/consip.dta", clear
include "code/intermediate/good-char.do"

generate mandatory = (compulsory > 0)

label define goodid 3 "Laptop" 5 "Desk" 6 "Chair" 7 "Landline" 8 "Projector" ///
9 "Switch" 10 "Cabble Copper" 14 "Lunch Vouchers" ///
16 "Paper" 17 "Fax"  19 "Mobile" 20 "Software" 21 "Printer"



drop goodid2

foreach var of varlist PA_govtype goodid{
		
	tab `var', gen (`var')

    levelsof `var', local(`var'_levels)

	local i = 0

    foreach val of local `var'_levels {
		local value`val' : label `var' `val'
		disp "`value`val''"
		local i = `i'+1
		label var `var'`i' "`value`val''"
		}	
		
	} 

label var PA_govtype1 "\\ \textit{Type of Public Body}\\ Ministries and government"
label var goodid1 "\\ \textit{Type of Good}\\ Laptop"


local vars  PA_govtype1 PA_govtype2 PA_govtype3 PA_govtype4 PA_govtype5 PA_govtype6 PA_govtype7 PA_govtype8 ///
	goodid1 goodid2 goodid3 goodid4 goodid5 goodid6 goodid7 goodid8 goodid9 ///
	goodid10 goodid11 goodid12 goodid13 


/* means */
tempname postMeans
tempfile means
postfile `postMeans' ///
    str100 varname beforeMeans afterMeans pMeans using "`means'", replace
foreach v of local vars {
    local name: variable label `v'
    ttest `v' if consip==1, by(mandatory) unequal
    post `postMeans' ("`name'") (r(mu_2)) (r(mu_1))  (-r(t))
}
postclose `postMeans'


clear
use `means'

format *Means* %9.2f
list

listtab * using "output/tables/mean-comparison-good-and-pa.tex", ///
    rstyle(tabular) replace ///
    head("\begin{tabular}{lccr}" ///
    "\toprule" ///
    "& \multicolumn{3}{c}{Consip}  \\" ///
    "\cmidrule(lr){2-4}" ///
    "& Mandatory & Optional & \emph{t-stat} \\" ///
	    "& (1) & (2) & (3) \\" ///
    "\midrule") ///
    foot( "\bottomrule" "Observations&  454    &  239&   \\" "\bottomrule" "\end{tabular}")









