

use "data/consip.dta", clear
include "code/intermediate/good-char.do"
xtset id 

pdslasso lprice post_consip (i.good i.year i.month $quantity `goods_char') if consip==0, fe partial(i.good i.year i.month $quantity ) r loptions(prestd) noi 


pdslasso lprice post_consip (i.good  month_year $quantity `goods_char') if consip==0, fe partial(i.good  month_year $quantity ) r loptions(prestd) noi 
