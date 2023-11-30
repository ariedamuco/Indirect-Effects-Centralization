do "code/config-file.do"

import delimited "code/intermediate/mapping-brands.txt", delimiter("|") clear varnames(1)
rename old brand_s // Ensure the 'old' variable is named 'brand_s' for the merge
tempfile mapping_brands
save `mapping_brands'


use "data/consip.dta", clear
merge m:1 brand_s using `mapping_brands'
replace brand_s = new if _merge == 3
drop new _merge

include "code/intermediate/good-char.do"

drop brand
encode brand_s, generate(brands)

recode consip 1=0 0=1, generate (out_consip)

generate post_consip_consip = post_consip*consip
generate post_consip_out_consip = post_consip*out_consip


label var post_consip_consip "Post Consip x Consip"
label var post_consip_out_consip "Post Consip x Out-of-Consip"

local version1 " , absorb(id goodid month_year)  cluster(id)"
local version2 " , absorb(id#goodid month_year) cluster(id)"
local version3 " , absorb(id month goodid##month_year) cluster(id)" 
local version4 "`lasso_char' `version1'"
local version5 " , absorb(id month year goodid brands) cluster(id)" 



 forvalues i=1(1)5{
	reghdfe lprice post_consip_consip post_consip_out_consip $quantity `version`i''
		eststo ver`i'

		estadd local obs=e(N) 
		estadd local id "Yes", replace
		estadd local goodid "Yes", replace
		estadd local month_year  "Yes", replace
		estadd local goodid_year  "No", replace
		estadd local goodid_id "No", replace
		estadd local controls "No", replace
		estadd local brands "No", replace

					
		else if `i' ==2  {	
			estadd local goodid_id "Yes", replace


		}
	
			
		else if `i' ==3  {
			estadd local goodid_year "Yes", replace

		}
		
		else if `i' ==4  {	
			estadd local controls "Yes", replace
		}
		
		else if `i' ==5  {	
			estadd local brands "Yes", replace
		}
}


	
esttab ver1 ver2  ver3 ver4 ver5  ///
	using  "output/tables/direct-indirect.tex", ///
	se(3) b(3) s(obs id goodid month_year goodid_id  goodid_year  controls brands, ///
	label(  "Observations" "PB fixed effects" "Good fixed effects" "Year-Month fixed effects" "Good x PB fixed effects"  "Good x Year-Month fixed effects"  "Controls" "Brand Fixed Effects" ))  label  ///
	nostar nonotes ///
	nomtitles mgroups(" ", ///
	pattern(1 0 0 0 )  prefix(\multicolumn{@span}{c}{) suffix(}) span )   ///
	keep( post_consip_consip post_consip_out_consip) replace	
	
	
*Footnote test

reghdfe lprice post_consip_consip post_consip_out_consip $quantity `version5'
test post_consip_consip = post_consip_out_consip

keep if e(sample)==1
reghdfe lprice post_consip_consip post_consip_out_consip $quantity `lasso_char' `version1'
test post_consip_consip = post_consip_out_consip



