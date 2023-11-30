use "data/consip.dta", clear
set sortseed 123

* Generate a random number for each observation
gen random_number = runiform()

*Sort the data by id, date, and the generated random number 
*to break the ties in case multiple purchases occur on the same date 

sort id date random_number

bysort id: gen total_consip = sum(consip) if consip != .
gen previous_consip_purchase = (total_consip > 0)

 
generate mandatory = (compulsory > 0)
replace mandatory = 0 if activeD==0&mandatory==1
gen non_mandatory=(mandatory==0&activeD==1)


gen previous_consip_mandatory = previous_consip_purchase*mandatory
gen previous_consip_non_mandatory = previous_consip_purchase*non_mandatory

bysort id : gen tprevious_consip_mandatory=sum(previous_consip_mandatory)
bysort id : gen tprevious_consip_non_mandatory=sum(previous_consip_non_mandatory)

replace tprevious_consip_mandatory=1 if tprevious_consip_mandatory>1
replace tprevious_consip_non_mandatory=1 if tprevious_consip_non_mandatory>1

generate post_consip_previous = post_consip*previous_consip_purchase

gen int_post_mandatory = post_consip*tprevious_consip_mandatory
gen int_post_non_mandatory = post_consip*tprevious_consip_non_mandatory


label var  post_consip "Post Consip (beta{1})"

label var  tprevious_consip_mandatory "Consip Experience from Mandatory Regime"
label var  tprevious_consip_non_mandatory  "Consip Experience from Optional Regime"


label var  int_post_mandatory "Post Consip x Consip Experience from Mandatory Regime (beta{M})"
label var  int_post_non_mandatory  "Post Consip x Consip Experience from Optional Regime (beta{O})"
save "data/previous_consip.dta", replace


