
use "data/consip_data_AER.dta", clear

/* ----------------------------------------------------- */
 * Data cleaning

* drop empty variables
drop v28 v29 v30 flag flagG PAround coreplacement_days speedcat schar3_processor tax_exemption ///
     char18_* _Ichar18_* C18_* char24_* _Ichar24_* schar24_* C24_*
	 
label var year "year of purchase"
label var month "month of purchase"
label var trend "day trend from the first purchase"
label var quart "quarter of year of the purchase"

rename neverconsip_flag neverconsip
rename sta_good simple_good 
rename cxx_good complex_good
rename regione region   
 

format deal_start_date? %td
format deal_end_date? %td

* assign earliest start date by goodid (this solves some missings in Edeal_start_date)
forvalues i = 1(1)4 {
	by goodid (deal_start_date`i'), sort: egen deal_start`i' = min(deal_start_date`i')
	bysort goodid: replace deal_start`i'=deal_start`i'[1] 
}
format deal_start? %td

* assign latest end date by goodid (this solves some missings in Ldeal_end_date)
forvalues i = 1(1)4 {
	by goodid (deal_end_date`i'), sort: egen deal_end`i' = max(deal_end_date`i')
	bysort goodid: replace deal_end`i'=deal_end`i'[1]
}
format deal_end? %td

/* For goodid2 and goodid17 the deals overlap over time: BPV consider overlapping deals as a single one. 
   For goodid13, goodid14 and goodid23 there is no end date for the deal: they are still active at the last date in the dataset. */

replace deal_end1=deal_end2 if goodid==2
replace deal_start2=. if goodid==2
replace deal_end2=. if goodid==2

replace deal_end1=deal_end2 if goodid==17
replace deal_start2=. if goodid==17
replace deal_end2=. if goodid==17

/* ----------------------------------------------------- */
 * Sample selection

label var consip "Consip"
label define consip 0 "No" 1 "Yes", modify
la values consip consip
drop if consip==.

* Post Consip
gen post_consip=.
bysort goodid: replace post_consip=1 if date>=deal_start1
bysort goodid: replace post_consip=0 if date<deal_start1 
label var post_consip "Post Consip"

* drop goods that have only been purchased post consip and their charactersistics
drop if inlist(goodid, 1, 2, 4, 12, 13)
drop char1_* Lchar1_* _Ichar1_* char2_* Lchar2_* _Ichar2_* char4_* Lchar4_* _Ichar4_* ///
     char12_* _Ichar12_* char13_* _Ichar13_* schar1_* schar2_* schar4_* schar12_* C1_* C2_* C4_* C12_* C13_*
* drop goods that have only been purchased pre consip and their charactersistics
drop if inlist(goodid, 15, 22, 23)
drop char15_* Lchar15_* _Ichar15_* char22_* Lchar22_* _Ichar22_* char23_* Lchar23_* _Ichar23_* ///
     schar15_* schar18_* schar23_* C15_* C22_* C23_*

clonevar good = goodid
la var good "Type of Good"

recode good (3=1)(5=2)(6=3)(7=4)(8=5)(9=6)(10=7)(14=8)(16=9)(17=10)(19=11)(20=12)(21=13)
label define good 1 "Laptop" 2 "Desk" 3 "Chair" 4 "Landline" 5 "Projector" 6 "Switch" 7 "Cable Copper" ///
8 "Lunch Vouchers" 9 "Paper" 10 "Fax" 11 "Mobile" 12 "Software" 13 "Printer", modify
label values good good 

/* ----------------------------------------------------- */
* indicators for deal periods
forvalues i = 1(1)4 {
	gen deal_`i'=0
	bysort goodid: replace deal_`i'=1 if date>=deal_start`i' & date<=deal_end`i'
}


/* Recall: In the case of goodid14 (lunch_vouchers) there is no end date for the deal: 
this deal is still active at the last date in the dataset. */
egen late_date = max(date)
format late_date %td
replace deal_end2=late_date if goodid==14

// count the number of days each deal has been active by goodid 
forvalues i = 1(1)4 {
	bysort goodid: gen nrdays`i'=(deal_end`i'-deal_start`i')
	replace nrdays`i'=0 if nrdays`i'==.
}

gen total_nrdays=nrdays1+nrdays2+nrdays3+nrdays4


/* ----------------------------------------------------- */
 * Goods characteristics

drop _Ichar* // will use factor variables notation instead
replace char10_inspection=char11_inspection                     if  inlist(char10_inspection,0,.) & char11_inspection!=0 & char11_inspection!=.
replace char10_design=char11_design                             if  inlist(char10_design,0,.) & char11_design!=0 & char11_design!=.
replace char10_installation=char11_installation                 if  inlist(char10_installation,0,.) & char11_installation!=0 & char11_installation!=.
replace char10_labelling=char11_labelling                       if  inlist(char10_labelling,0,.) & char11_labelling!=0 & char11_labelling!=.
replace char10_trial=char11_trial                               if  inlist(char10_trial,0,.) & char11_trial!=0 & char11_trial!=.
replace char10_certification=char11_certification               if  inlist(char10_certification,0,.) & char11_certification!=0 & char11_certification!=.
replace char10_system_management=char11_system_management       if  inlist(char10_system_management,0,.) & char11_system_management!=0 & char11_system_management!=.
replace char10_maintenance_duration=char11_maintenance_duration if  inlist(char10_maintenance_duration,0,.) & char11_maintenance_duration!=0 & char11_maintenance_duration!=.
replace char10_typefo_cat=char11_typefo_cat                     
rename  Lchar11_fibers_total Lchar10_fibers_total               

replace char17_autocharge=char25_autocharge     if  inlist(char17_autocharge,0,.) & char25_autocharge!=0 & char25_autocharge!=.
replace char17_maintenance=char25_maintenance   if  inlist(char17_maintenance,0,.) & char25_maintenance!=0 & char25_maintenance!=.
replace Lchar17_speed=Lchar25_speed             if  inlist(Lchar17_speed,0,.) & Lchar25_speed!=0 & Lchar25_speed!=.
replace Lchar17_modem_speed=Lchar25_modem_speed if  inlist(Lchar17_modem_speed,0,.) & Lchar25_modem_speed!=0 & Lchar25_modem_speed!=.
replace schar17_brand=schar25_brand if  schar17_brand=="" & schar25_brand!=""
replace schar17_model=schar25_model if  schar17_model=="" & schar25_model!=""
drop *char11* *char25*

local i = 1
foreach j in 3 5 6 7 8 9 10 14 16 17 19 20 21{
	rename *char`j'_* *char`i'_*
	rename C`j'_* C`i'_*
	local ++i
}

* Brands and models
foreach i in 1 5 6 8 10 12{
	replace brand=schar`i'_brand if brand=="" & schar`i'_brand!=""
	replace model=schar`i'_model if model=="" & schar`i'_model!=""
	drop schar`i'_brand schar`i'_model
}
replace brand="tim"      if char11_provider==1
replace brand="vodafone" if char11_provider==2

foreach var of varlist brand model{
	replace `var'=lower(`var')
	replace `var'=subinstr(`var',".","",.)
}
replace brand="" if inlist(brand, "altro", "xxxxxxx", "sconosciuta", "varie", "na", "assemblato", "assemblati", "non disponibile")
foreach x in "frezza spa" "gemeaz" "lunch time" "repas lunch" "ristoservice" "sodexho" "burgo" "bollani carta" "fabriano" ///
             "computer support italcard" {
			replace brand="`x'" if strpos(brand, "`x'") 
}
replace brand="hp" if brand=="hewlett - packard" | (brand=="" & strpos(model, "hp"))
replace brand="steinbeis" if brand=="steinbes"

levelsof brand, local(levels) 
	 foreach l of local levels {
	 replace model = subinstr(model, "`l'", "", .) if brand=="`l'"
 }
local sign "_" "-" 
replace model = subinstr(model,"`sign'","",.)
 
rename  brand brand_s
encode  brand_s, gen(brand)
replace brand=0 if brand==.

/* NOTE: ALL VARIABLES NAMED C`I'_CHAR REFER TO CHARACTERISTICS OF GOOD I THAT ARE SIGNIFICANT DETERMINANTS OF PRICES */

/* replace missing characteristics with mode/mean by good */
rename char2_firehazard_classification char2_firehazard_class
rename char3_firehazard_classification char3_firehazard_class
rename char2_serviziodiprogettazione char2_servproget
rename char9_market_classification char9_mkt_class


foreach i in 2 7 8 9 10 13{
	foreach var of varlist *Lchar`i'_*{
		egen mis`var' = mean(`var') if good==`i'
		replace `var'= mis`var' if missing(`var') & good==`i'
		drop mis`var'
	}
}

forvalues i=1/13{
	foreach var of varlist *char`i'_*{
		egen mis`var' = mode(`var') if good==`i'
		replace `var'= mis`var' if missing(`var') & good==`i'
		drop mis`var'
	}
}

/* ----------------------------------------------------- */
drop quantity? quantity?? Lquantity*
gen lquantity=log(quantity)
label var lquantity "log quantity"

gen lprice=log(price) 
label var lprice "log price"

local i = 1
while `i' <=13 {
gen quantity`i'=0
      replace quantity`i' = quantity if good==`i'
	  gen lquantity`i'=0
	  replace lquantity`i' = lquantity if good==`i'
   local i = `i' + 1
	} 

* PB types
label var PA_govtype "Type of PA"
label def PA_govtype 1 "Ministries and government" 2 "Social security" 5 "Regional councils" 6 "Province and town councils" 7 "Health centers" 9 "Mountain village councils" 10 "University" 15 "Other"
label val PA_govtype PA_govtype

label var PA_type "Type of PA"
label def PA_type 1 "Ministries and government" 2 "Social security" 5 "Regional councils" 6 "Province and town councils" 7 "Health centers" 9 "Mountain village councils" 10 "University"
label val PA_type PA_type

gen     PA_3types = 1 if PA_type<=2
replace PA_3types = 2 if PA_type==5 | PA_type==6
replace PA_3types = 3 if PA_type>=7 & PA_type<=10
label define tga 1 napoleonic 2 local 3 autonomous 
label values PA_3types tga
label var PA_3types "3 governance types"
rename PA_3types pa

tab pa, gen (pa_)
rename pa_1 napoleonic
rename pa_2 local
rename pa_3 autonomous

* Regions and macro regions
replace region = subinstr(region," ","_",.)
replace region = subinstr(region,"d'","",.)

egen macro_region=concat(region) 
replace macro_region ="nord_ovest" if inlist(region, "Liguria", "Lombardia", "Piemonte", "Valle_Aosta")
replace macro_region ="nord_est"   if inlist(region, "Emilia_Romagna", "Friuli_Venezia_Giulia", "Trentino_Alto_Adige", "Veneto")
replace macro_region ="centro"     if inlist(region, "Lazio", "Marche", "Toscana", "Umbria")
replace macro_region ="sud"        if inlist(region, "Abruzzo", "Basilicata", "Calabria", "Campania", "Puglia")  
replace macro_region ="isole"      if inlist(region, "Sardegna", "Sicilia") 

foreach i of varlist region macro_region {
	levelsof `i', local(names`i')
		foreach n of local names`i' {
			gen byte `n' = (`i' == "`n'")
	}
}

egen month_year =group(year month)


/* ----------------------------------------------------- */

compress
save "data/consip.dta",replace

cap log close
