
use "data/consip.dta", clear

include "code/intermediate/good-char.do"

preserve
** TAble 1 Panel A: Sample characteristics, by PB type

* Expenditure
gen exp = price*quantity
egen totalspend = total(exp), by(PA_govtype year)
egen temp_tot = total(exp), by(year)
replace totalspend=totalspend/1000000

* Summary Ns
gen N_jit = 1
bys id PA_govtype: gen N_i = _n==1
bys PA_govtype good: gen N_j = _n == 1 

bys PA_govtype: gen N_jout = (post_consip==1 & consip==0)
bys PA_govtype: gen N_joutact = (activeD==1 & consip==0)

	

collapse (sum) N_* post_consip activeD (mean) totalspend, by(PA_govtype) fast

replace post_consip = post_consip/N_jit
replace N_jout = N_jout/N_jit
replace activeD = activeD/N_jit
replace N_joutact = N_joutact/N_jit
		

order PA_govtype N_jit N_i N_j totalspend post_consip N_jout activeD N_joutact 


estpost tabstat N_jit N_i N_j totalspend post_consip N_jout activeD N_joutact, by(PA_govtype) 
esttab using  "output/tables/Table1_panelA.tex", noobs nomtitle ///
cells("N_jit N_i N_j totalspend(fmt(2)) post_consip(fmt(2)) N_jout(fmt(2)) activeD(fmt(2)) N_joutact(fmt(2))") ///
nonumber  varwidth(30) ///
collab(`"N. of total observations"' `"N. of PBs"' `"N. of different goods purchased"' `"Average yearly expenditure"' `"Post-Consip purchases"' `"Out-of-Consip purchases"' `"Purchases while deal active"' `"Out-of-Consip while deal active"' , lhs("`:var lab PA_govtype'")) tex replace


restore



** Table 1 Panel B: Sample characteristics, by good type

* Summary Ns
preserve
gen N_jit = 1
bys id good: gen N_i = _n==1
bys good: gen N_jout = (consip==0)
bys good: gen N_joutact = (activeD==1 & consip==0)

* Mean price and sd
egen mu_p = mean(price), by(good year)
egen sd_p = sd(price), by(good year)
gen cv_jt = sd_p/mu_p
	
collapse (sum) N_* post_consip activeD (mean) mu_p cv_jt, by(good) fast

replace post_consip = post_consip/N_jit
replace N_jout = N_jout/N_jit
replace activeD = activeD/N_jit
replace N_joutact = N_joutact/N_jit
	

order good N_jit N_i post_consip N_jout activeD N_joutact mu_p cv_jt


estpost tabstat N_jit N_i mu_p cv_jt post_consip N_jout activeD N_joutact , by(good) 
esttab using  "output/tables/Table1_panelB.tex", noobs nomtitle ///
cells("N_jit N_i mu_p(fmt(2)) cv_jt(fmt(2)) post_consip(fmt(2)) N_jout(fmt(2)) activeD(fmt(2)) N_joutact(fmt(2)) ") ///
nonumber varwidth(30) ///
collab(`"N. of total purchases"' `"N. of different PBs"' `"Average price"' `"Coefficient of variation (price)"' `"Post-Consip purchases"' `"Out-of-Consip purchases"' `"Purchases while deal active"' `"Out-of-Consip while deal active"' , lhs("`:var lab good'")) tex replace
	



