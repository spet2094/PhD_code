use "/Users/sophieayling/Library/CloudStorage/OneDrive-UniversityCollegeLondon/GitHub/Disease-Modelling-SSA/data/raw/census/100_perc/abm_individual_new_092320_final_merged_complete_FINAL.dta", clear


label dir
numlabel `r(names)', add

* gender breakdown


tab sex // 48.09% male, 51.91 % female in census 

* age breakdown according to manicaland categories 

** add age category for respondent 
gen age_cat = . 
replace age_cat = . if age <15 & age !=. // recoded to missing so as to be comparable with R8 where there were no under 15 year olds.
replace age_cat = 2 if age >=15 & age <=44 & age !=. 
replace age_cat = 3 if age >=45 & age <=64 & age !=.
replace age_cat = 4 if age >=65 & age !=. 

label define age_cat 1 "under 15" 2 "15-44 yrs" 3 "45-64 yrs" 4 "65+ yrs"

label values age_cat age_cat
tab age_cat

/*
    age_cat |      Freq.     Percent        Cum.
------------+-----------------------------------
  15-44 yrs |  6,818,511       76.98       76.98
  45-64 yrs |  1,393,018       15.73       92.71
    65+ yrs |    645,794        7.29      100.00
------------+-----------------------------------
      Total |  8,857,323      100.00


*/


* economic status (either convert to occ_2 or visa versa )

tab economic_status 

gen occ_2 = 1 if inlist(economic_status, 5,6 )
replace occ_2 = 2 if economic_status=  1 
replace occ_2 = 3 if inlist(economic_status, 0,2,8 )
replace occ_2 = 4 if inlist(economic_status, 4 )
replace occ_2 = 5 if inlist(economic_status, 3 )
// no informal in econ_stat variable. Need to get the original to classify.

la define oc2 1 "manual labor" 2 "students or teachers" 3 "not employed or homemakers" 4 "workers - retail or public service" 5 "office workers" 6 "informal trading" 7 "other informal"



// or ultimately not necessary as can go from IVQ distributions to census 

cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/08_Fieldwork/08_Data/R8_data"

use "stata_input/z_IVQ_R8_newVars.dta", clear
format hhmem_key %13.0g

tab gender
// 42.24% male, 57.76 % female in census 
tab age_cat
/*
    age_cat |      Freq.     Percent        Cum.
------------+-----------------------------------
  15-44 yrs |      5,951       70.01       70.01
  45-64 yrs |      1,914       22.52       92.53
    65+ yrs |        635        7.47      100.00
------------+-----------------------------------
      Total |      8,500      100.00

*/


***** data received on the sample itself (for hh ivq)

import excel using "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/08_Fieldwork/08_Data/R8_data/raw/r8_hhmall_agesitesex.xlsx", first clear
// it has 23,721 obs whereas I only have 8,500 surveys so need to match on IVQ hhmem_key
format hhmem_key %13.0g

tab gender_8
tab age_8
