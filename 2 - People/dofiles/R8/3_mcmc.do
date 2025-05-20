
*** applied to my data

use "stata_input/IVQ_R8_newVars.dta", clear
format hhmem_key %13.0f 

gen b60= .
replace b60=1 if inlist(ses_5,1,2,3)
replace b60=0 if inlist(ses_5,4,5)

la define b60 0 "t40" 1 "b60"
la values b60 b60
bayes, nchains(3) rseed(16): nbreg nld_all_ages_contacts_week ib3.occ_2 i.gender i.age_5 i.site_type i.b60

*explore convergence 

bayesgraph trace {nld_all_ages_contacts_week:age_5}

bayesstats summary
