do "code/config-file.do"

do code/tables/previous-consip-experience.do
local version1 " if consip==0                           , absorb(id goodid month_year)  cluster(id)"
local version2 " if consip==0 & !inlist(PA_govtype,1,2) , absorb(id goodid month_year)  cluster(id)"
local version3 " if consip==0 & !inlist(PA_govtype,7,10), absorb(id goodid month_year)  cluster(id)"

 forvalues i=1(1)3{
		reghdfe lprice post_consip  tprevious_consip_mandatory tprevious_consip_non_mandatory  int_post_mandatory int_post_non_mandatory  $quantity `version`i''
		eststo ver`i'
		lincom  tprevious_consip_mandatory + tprevious_consip_non_mandatory
		lincom  post_consip + int_post_mandatory
		estadd scalar est_lincom1 = r(estimate), replace
		estadd scalar se_lincom1 = r(se), replace
		
		
		lincom  post_consip +  int_post_non_mandatory
		estadd scalar est_lincom2 = r(estimate), replace
		estadd scalar se_lincom2 = r(se), replace

			
		lincom post_consip + int_post_mandatory + int_post_non_mandatory
		estadd local obs=e(N) 
		estadd local id "Yes", replace
		estadd local goodid "Yes", replace
		estadd local month_year  "Yes", replace
		estadd local controls "No", replace
		
 }

esttab ver1 ver2 ver3  ///
	using  "output/tables/previous_consip_purchase_robustness.tex", ///
	se(3) b(3) s(est_lincom1  se_lincom1  est_lincom2  se_lincom2  line obs id goodid month_year controls, ///
	label( "Estimate $ beta{1} + beta{M} $ " "SE $ beta{1} + beta{M} $"  "Estimate $ beta{1} + beta{O} $ " "SE $ beta{1} + beta{O} $" "\hline" "Observations" "PB fixed effects" "Good fixed effects" "Year-Month fixed effects"  "Controls"  ))  label  ///
	nostar nonotes ///
	nomtitles mgroups("Full sample" "No Central PBs" "No Autonomous", ///
	pattern(1 1 1)  prefix(\multicolumn{@span}{c}{) suffix(}) ///
	span erepeat(\cmidrule(rrrr){@span})) keep(post_consip tprevious_consip_mandatory tprevious_consip_non_mandatory  int_post_mandatory int_post_non_mandatory) replace	

