
clear
cap log close
set more off
set scheme burd5


use "data/consip.dta"


gen recenter_start = .
replace recenter_start = date - deal_start1 if date<=deal_end1 
replace recenter_start = date - deal_start2 if date>deal_end1 & date<=deal_end2
replace recenter_start = date - deal_start3 if date>deal_end2 & date<=deal_end3
replace recenter_start = date - deal_start4 if date>deal_end3 & date<=deal_end4

gen recenter_end = .
replace recenter_end = date - deal_end1 if date<deal_start2
replace recenter_end = date - deal_end2 if date>=deal_start2 & date<deal_start3
replace recenter_end = date - deal_end3 if date>=deal_start3 & date<deal_start4
replace recenter_end = date - deal_end4 if date>=deal_start4
replace recenter_end = . if date<deal_start1

* gen everconsip2
gen everconsip2=0
forvalues i=1/13 {
levelsof id if good==`i' & consip==1, local(n)
foreach j in `n'{
replace everconsip2=1 if good==`i' & id==`j'
}
}
replace everconsip2=. if neverconsip==1

** Keep out of Consip purchases
keep if consip==0

* Start of a deal
gen double round_start=.
forvalues i=-360(30)-1 {
replace round_start=`i' if recenter_start>=`i' &  recenter_start<`i'+30
}
forvalues i=0(30)359 {
replace round_start=`i' if recenter_start>=`i' &  recenter_start<`i'+30
}

egen tag_id = tag(id round_start)
egen distinct_id = total(tag_id), by(round_start) 

*** Graphs
preserve
collapse (max) distinct_id, by(round_start)
twoway (dot distinct_id round_start), xline(0) ytitle("Number of PBs") xtitle(" ", size(small)) 
gr save "output/figures/pbs_start.gph", replace
restore

preserve
collapse (count) distinct_id, by(round_start)
drop if round_start==.
twoway (dot distinct_id round_start), xline(0) ytitle("Number of observations") xtitle(" ", size(small)) 
gr save "output/figures/obs_start.gph", replace
restore

gr combine output/figures/pbs_start.gph output/figures/obs_start.gph, ycommon 
gr export "output/figures/descriptives_start.pdf", replace

* distinguishing by everconsip2
drop tag_id distinct_id
egen tag_id = tag(id round_start) if everconsip2==0
egen distinct_id = total(tag_id) if everconsip2==0, by(round_start)

preserve
collapse (mean) distinct_id, by(round_start everconsip2)
twoway (dot distinct_id round_start if everconsip2==0), xline(0) ytitle("Number of PBs") xtitle(" ", size(small)) 
gr save "output/figures/pbs_startNeverconsip.gph", replace
restore

preserve
collapse (count) distinct_id, by(round_start everconsip2)
drop if round_start==.
twoway (dot distinct_id round_start if everconsip2==0), xline(0) ytitle("Number of observations") xtitle(" ", size(small)) 
gr save "output/figures/obs_startNeverconsip.gph", replace
restore

gr combine output/figures/pbs_startNeverconsip.gph output/figures/obs_startNeverconsip.gph, ycommon 
gr export output/figures/descriptives_startNeverconsip.pdf, replace

drop tag_id distinct_id
egen tag_id = tag(id round_start) if everconsip2==1
egen distinct_id = total(tag_id) if everconsip2==1, by(round_start)

preserve
collapse (mean) distinct_id, by(round_start everconsip2)
twoway (dot distinct_id round_start if everconsip2==1), xline(0) ytitle("Number of PBs") xtitle(" ", size(small)) 
gr save "output/figures/pbs_startEverconsip.gph", replace
restore

preserve
collapse (count) distinct_id, by(round_start everconsip2)
drop if round_start==.
twoway (dot distinct_id round_start if everconsip2==1), xline(0) ytitle("Number of observations") xtitle(" ", size(small)) 
gr save "output/figures/obs_startEverconsip.gph", replace
restore

gr combine output/figures/pbs_startEverconsip.gph output/figures/obs_startEverconsip.gph, ycommon 
gr export "output/figures/descriptives_startEverconsip.pdf", replace
drop tag_id distinct_id

* End of a deal 
gen double round_end=.
forvalues i=-359(30)0 {
replace round_end=`i' if recenter_end>=`i' &  recenter_end<`i'+30
}
forvalues i=1(30)360 {
replace round_end=`i' if recenter_end>=`i' &  recenter_end<`i'+30
}

egen tag_id = tag(id round_end)
egen distinct_id = total(tag_id), by(round_end) 

*** Graphs
preserve
collapse (mean) distinct_id, by(round_end)
twoway (dot distinct_id round_end), xline(0) ytitle("Number of PBs") xtitle(" ") 
gr save "output/figures/pbs_end.gph", replace
restore

preserve
collapse (count) distinct_id, by(round_end)
drop if round_end==.
twoway (dot distinct_id round_end), xline(0) ytitle("Number of observations") xtitle(" ") 
gr save "output/figures/obs_end.gph", replace
restore

gr combine output/figures/pbs_end.gph output/figures/obs_end.gph, ycommon
gr export "output/figures/descriptives_end.pdf", replace

* distinguishing by everconsip2
drop tag_id distinct_id
egen tag_id = tag(id round_end) if everconsip2==0
egen distinct_id = total(tag_id) if everconsip2==0, by(round_end)

preserve
collapse (mean) distinct_id, by(round_end everconsip2)
twoway (dot distinct_id round_end if everconsip2==0), xline(0) ytitle("Number of PBs") xtitle(" ") 
gr save "output/figures/pbs_endNeverconsip.gph", replace
restore

preserve
collapse (count) distinct_id, by(round_end everconsip2)
drop if round_end==.
twoway (dot distinct_id round_end if everconsip2==0), xline(0) ytitle("Number of observations") xtitle(" ") 
gr save "output/figures/obs_endNeverconsip.gph", replace
restore

gr combine output/figures/pbs_endNeverconsip.gph output/figures/obs_endNeverconsip.gph, ycommon
gr export "output/figures/descriptives_endNeverconsip.pdf", replace

drop tag_id distinct_id
egen tag_id = tag(id round_end) if everconsip2==1
egen distinct_id = total(tag_id) if everconsip2==1, by(round_end)

preserve
collapse (mean) distinct_id, by(round_end everconsip2)
twoway (dot distinct_id round_end if everconsip2==1), xline(0) ytitle("Number of PBs") xtitle(" ") 
gr save "output/figures/pbs_endEverconsip.gph", replace
restore

preserve
collapse (count) distinct_id, by(round_end everconsip2)
drop if round_end==.
twoway (dot distinct_id round_end if everconsip2==1), xline(0) ytitle("Number of observations") xtitle(" ") 
gr save "output/figures/obs_endEverconsip.gph", replace
restore

gr combine "output/figures/pbs_endEverconsip.gph" "output/figures/obs_endEverconsip.gph", ycommon
gr export "output/figures/descriptives_endEverconsip.pdf", replace
