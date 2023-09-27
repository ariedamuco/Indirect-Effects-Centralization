keep if centering_var>=`first_lead' & centering_var<=`last_lag'


local last_lag =`last_lag' - `first_lead'+1
local normalize_lead =`normalize_lead' - `first_lead'
local normalize_lead_b =`normalize_lead'-1
local normalize_lead_a =`normalize_lead'+1
 
tab centering_var, gen(centering_var_ind)


areg lprice centering_var_ind1-centering_var_ind`normalize_lead_b' centering_var_ind`normalize_lead_a'-centering_var_ind`last_lag' i.good $quantity `lasso_char' `sample_reg', a(id) vce(cluster id)


	
replace centering_var_ind`normalize_lead' = 0

    forvalues i = 1/`last_lag' {
        if `i' != `normalize_lead' {
            gen ci_low`i' = _b[centering_var_ind`i'] - 1.96*_se[centering_var_ind`i']
            gen ci_high`i' = _b[centering_var_ind`i'] + 1.96*_se[centering_var_ind`i']
            gen coef`i' = _b[centering_var_ind`i']
            gen st_dev`i' = _se[centering_var_ind`i']
        }
    }

    gen ci_low`normalize_lead' = 0
    gen ci_high`normalize_lead' = 0
    gen coef`normalize_lead' = 0
    gen st_dev`normalize_lead' = 0

	

	
	
keep  coef* ci* st_dev*
gen id=_n
reshape long coef ci_low ci_high st_dev, i(id) j(leads_lags)
drop id
duplicates drop
