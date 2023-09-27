

use "data/consip.dta", clear
keep if consip==1

keep id date goodid consip 
bysort id date: gen overall_consip = _N
bysort id: gen total_consip = _N
collapse (min) overall_consip total_consip, by(id date)

tempfile consip
save `consip'


use "data/consip.dta", clear

merge m:1 id date using `consip', nogen


bysort id: carryforward total_consip , gen (total_consip_cf)
 
replace total_consip_cf =0 if missing(total_consip_cf)

gen previous_consip_purchase = (total_consip_cf > 0)

 
generate mandatory = (compulsory > 0)
replace mandatory = 0 if activeD==0&mandatory==1
 
gen non_mandatory=(mandatory==0&activeD==1)


gen previous_consip_mandatory = previous_consip_purchase*mandatory
gen previous_consip_non_mandatory = previous_consip_purchase*non_mandatory

sort id date 
*edit id date goodid previous_consip*

bysort id : gen tprevious_consip_mandatory=sum(previous_consip_mandatory)
bysort id : gen tprevious_consip_non_mandatory=sum(previous_consip_non_mandatory)
replace tprevious_consip_mandatory=1 if tprevious_consip_mandatory>1
replace tprevious_consip_non_mandatory=1 if tprevious_consip_non_mandatory>1

collapse (max) previous_consip* consip lprice post_consip  tprevious_consip_mandatory tprevious_consip_non_mandatory , by(id date goodid )

generate post_consip_previous = post_consip*previous_consip_purchase

gen int_post_mandatory = post_consip*tprevious_consip_mandatory
gen int_post_non_mandatory = post_consip*tprevious_consip_non_mandatory

label var  post_consip "Post Consip (beta{1})"

label var  tprevious_consip_mandatory "Consip Experience from Mandatory Regime"
label var  tprevious_consip_non_mandatory  "Consip Experience from Optional Regime"


label var  int_post_mandatory "Post Consip x Consip Experience from Mandatory Regime (beta{M})"
label var  int_post_non_mandatory  "Post Consip x Consip Experience from Optional Regime (beta{O})"
save "data/previous_consip.dta", replace

