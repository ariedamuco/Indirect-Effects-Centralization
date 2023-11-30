do "code/config-file.do"

use "data/consip.dta", clear

include "code/intermediate/good-char.do"

label define post_consip 0 "Pre-Consip" 1 "Post-Consip"
label values post_consip post_consip


*** PB Heterogeneity by institutional class

label define pa 1 "Napoleonic bodies" 2 "Local governments" 3 "Semi-autonomous bodies"
label values pa pa 

local version1 "if consip==0, absorb(pa month_year good) cluster(id)"
local version2 "$lasso_char if consip==0, absorb(pa month_year good) cluster(id)" 

 forvalues i=1(1)2{
	reghdfe lprice 1.post_consip#pa  $quantity `version`i''
		eststo ver`i'

		estadd local obs=e(N) 
		estadd local PA "Yes", replace
		estadd local good "Yes", replace
		estadd local month_year "Yes", replace
		estadd local controls "No", replace
		
		if `i' ==2 {	
			estadd local controls "Yes", replace

		}
		
}

esttab ver1 ver2    ///
	using  "output/tables/indirect_het_pb.tex", ///
	se(3) b(3) s(obs PA good month_year controls, ///
	label(  "Observations" "PB type fixed effects" "Good fixed effects" "Month-year fixed effects" "Controls"  ))  label  ///
	nostar nonotes ///
	nomtitles mgroups(" ", ///
	pattern(1 0 0 0 0 0)  prefix(\multicolumn{@span}{c}{) suffix(}) span )   ///
	keep(*.post_consip#*.pa) replace	
	
	
