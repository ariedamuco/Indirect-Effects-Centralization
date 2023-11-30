do "code/config-file.do"

use "data/consip.dta", clear

include "code/intermediate/good-char.do"

label define post_consip 0 "Pre-Consip" 1 "Post-Consip"
label values post_consip post_consip


* PB Heterogeneity by pre-Consip quantities

* raw pre-Consip quantity quartiles
egen quartile = xtile(quantity) if post_consip==0, by(good) n(4)
bysort id: egen median_quart= median(quartile)
replace median_quart=2 if median_quart==1.5
replace median_quart=3 if median_quart==2.5
replace median_quart=4 if median_quart==3.5
*replace median_quart=0 if median_quart==.
label define median_quart 1 "1st Quantity Quartile" 2 "2nd Quantity Quartile" 3 "3rd Quantity Quartile" 4 "4th Quantity Quartile"
label values median_quart median_quart

local version1 "if consip==0, absorb(id month_year goodid) cluster(id)"
local version2 "$lasso_char if consip==0, absorb(id month_year good) cluster(id)" 


 forvalues i=1(1)2{
	reghdfe lprice 1.post_consip#i.median_quart $quantity `version`i''
		eststo ver`i'

		estadd local obs=e(N) 
		estadd local id "Yes", replace
		estadd local good "Yes", replace
		estadd local month_year "Yes", replace
		estadd local controls "No", replace

		
		if `i' ==2 {	
			estadd local controls "Yes", replace

		}		
		
}

esttab ver1 ver2 ///
	using  "output/tables/indirect_het_pb_quart_quantity.tex", ///
	se(3) b(3) s(obs id good month_year controls, ///
	label(  "Observations" "PB fixed effects" "Good fixed effects" "Month-year fixed effects" "Controls"  ))  label  ///
	nostar nonotes ///
	nomtitles mgroups(" ", ///
	pattern(1 0 0 0 0 0)  prefix(\multicolumn{@span}{c}{) suffix(}) span )   ///
	keep(*.post_consip#*.median_quart) replace	
	
