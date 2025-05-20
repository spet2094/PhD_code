clear all

cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/08_Fieldwork/08_Data/R8_data/"
tempfile temp1


use "raw/IVQ_R8_renamed.dta", clear
format hhmem_key %13.0f 

codebook hhmem_key
sort hhmem_key

duplicates report 

save `temp1', replace

* merge with the household data 

use "raw/HHQ_R8.dta", clear
format hhmem_key %13.0f 
duplicates report hhmem_key // there are no duplicates

*add the cleaning there is on line 413 of the IVQ genNewVar file 

codebook hhmem_key
replace hhmem_key=1401295802 if hhmem_key==1400354802
replace hhmem_key=1401295801 if hhmem_key==1400354801
replace hhmem_key=709953803 if hhmem_key==709933803
replace hhmem_key=709950801 if hhmem_key==709901801
replace hhmem_key=709949802 if hhmem_key==709900802

*remove the <15s as we can't really sample weight those responses in IVQ anyway for number of contacts

drop if age_8 < 15
drop if age_8 >100 // just cleaning 
*drop if dup==1 // this is incorrect 
drop dup 

sort hhmem_key

*variables to keep from hhq
drop if personalive_8 ==2 // not keeping those deceased at the time of the survey
*just keep age and sex 
keep hhkey hhmem_key relatehoh_8 gender_8 age_8 site

merge 1:1 hhmem_key using `temp1'
// there are 16 obs in IVQ that don't appear in the hh_mem keys

*save and do weights

*generate participation variable 
gen participation =.
replace participation =1 if _merge==3
replace participation =0 if _merge==1 
replace participation =1 if _merge==2 // this is a bit odd because they are 15 ivqs that were not in the households. 

*generate age categories for hhq 
gen hh_age_cat_5 = .
replace hh_age_cat_5 = 1 if age_8 <15 & age_8 !=.
replace hh_age_cat_5 = 2 if age_8 >=15 & age_8 <=29 & age_8 !=. 
replace hh_age_cat_5 = 3 if age_8 >=30 & age_8 <=44 & age_8 !=. 
replace hh_age_cat_5 = 4 if age_8 >=45 & age_8 <=64 & age_8 !=.
replace hh_age_cat_5 = 5 if age_8 >=65 & age_8 !=. 
tab hh_age_cat_5, m

label define hh_age_cat_5 1 "under 15" 2 "15-29 yrs" 3 "30-44 yrs" 4 "45-64 yrs" 5 "65+ yrs"

label values hh_age_cat_5 hh_age_cat_5
tab hh_age_cat_5 participation, chi2
tab site participation, chi2
tab gender_8 participation , chi2
// shows there is a significant difference in response rate between the subgroups above

*generate weights based on age gender and site
logit participation i.hh_age_cat_5 ib2.site if gender_8 ==1
predict wgt_m

logit participation i.hh_age_cat_5 ib2.site if gender_8 ==2
predict wgt_f

sum wgt_*

gen wgt_all = wgt_m if gender_8==1
replace wgt_all = wgt_f if gender_8 == 2
gen wgt_inv = 1 /wgt_all
qui sum wgt_inv if participation ==1
replace wgt_inv = wgt_inv / `r(mean)'
la var wgt_inv "inverse sampling weights"

order hhkey hhmem_key gender_8 age_8 site participation hh_age_cat_5 wgt_m wgt_f wgt_all wgt_inv

drop wgt_f wgt_m wgt_all

*just keep the IVQ obs so it can be used in the cleaned dataset

keep if _merge==3

keep hhmem_key wgt_inv
sort hhmem_key
save "stata_input/IVQ_HHQ_R8_weighted.dta", replace



