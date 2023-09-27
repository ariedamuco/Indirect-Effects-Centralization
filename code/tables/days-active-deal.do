use "data/consip.dta", clear
drop if consip==1 

include "code/intermediate/good-char.do"

* Table for Appendix: Number of days a deal is active
local forlab: value label good
forvalues i=1/13{
local label: label `forlab' `i'
local rtitle "`label'"

 if "`i'" == "1"{
      local replace "replace"
	  }
 else if "`i'" != "1"{
      local replace "append"
	  }
sum nrdays1 if good==`i'
local nrdays1=`r(mean)'

sum nrdays2 if good==`i'
local nrdays2=`r(mean)'

sum nrdays3 if good==`i'
local nrdays3=`r(mean)'

clear matrix	
matrix A = `nrdays1',`nrdays2',`nrdays3'
matrix list A
frmttable using output/tables/Appendix_descriptives, sdec(0) tex fragment `replace' statmat(A) title("Number of days a Consip deal is active") ///
          ctitle("","First deal", "Second deal", "Third deal") rtitle("`rtitle'")
}



