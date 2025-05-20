
clear all
estimates clear

use "stata_input/IVQ_R8_newVars.dta", clear
format hhmem_key %13.0f 

replace ld_all_ages_contacts_week = . if ld_all_ages_contacts_week >720


************************************************************
**Q4: What variables are most strongly correlated with changes in contacts pre and post lockdown? 
************************************************************

*do the separate regressions for each place (changed to do this on a wide dataset)

*all places
asdoc reg diff_all_places_wk_ld ib3.occ_2 i.gender i.age_5 i.site_type i.ses_5, title(Determinants of difference in contacts by place pre-post lockdown) abb(.) save(tables/q4/reg_diff_by_place) replace

*home
asdoc reg diff_home_wk_ld ib3.occ_2 i.gender i.age_5 i.site_type i.ses_5, title(Difference for Home Contacts) abb(.)  append
*work 
asdoc reg diff_work_wk_ld ib3.occ_2 i.gender i.age_5 i.site_type i.ses_5, title(Difference for Work Contacts) abb(.)  append
*school 
asdoc reg diff_sch_wk_ld ib3.occ_2 i.gender i.age_5 i.site_type i.ses_5, title(Difference for School Contacts) abb(.) append
*transport
asdoc reg diff_trans_wk_ld ib3.occ_2 i.gender i.age_5 i.site_type i.ses_5, title(Difference for Transport Contacts) abb(.) append
*ent
asdoc reg diff_ent_we_ld ib3.occ_2 i.gender i.age_5 i.site_type i.ses_5, title(Difference for Entertainment Contacts) abb(.) append


*** nested (tested didn't work)

*all places
asdoc reg diff_all_places_wk_ld ib3.occ_2 i.gender i.age_5 i.site_type i.ses_5, title(Determinants of difference in contacts by place pre-post lockdown - nested) abb(.) nested cnames(diff_all places) save(tables/q4/reg_diff_by_place_nst) replace
*home
asdoc reg diff_home_wk_ld ib3.occ_2 i.gender i.age_5 i.site_type i.ses_5, abb(.) nested cnames(diff_home) append
*work 
asdoc reg diff_work_wk_ld ib3.occ_2 i.gender i.age_5 i.site_type i.ses_5, abb(.) nest cnames(diff_work) append
*school 
asdoc reg diff_sch_wk_ld ib3.occ_2 i.gender i.age_5 i.site_type i.ses_5, abb(.) nest cnames(diff_school) append
*transport
asdoc reg diff_trans_wk_ld ib3.occ_2 i.gender i.age_5 i.site_type i.ses_5, abb(.) nest cnames(diff_trans) append
*ent
asdoc reg diff_ent_we_ld ib3.occ_2 i.gender i.age_5 i.site_type i.ses_5,  abb(.) nest cnames(diff_ent) append


********************************************************************
*Q4b. in which of the places was there the most significant reduction in contacts?
********************************************************************

ttest tot_contacts_home_wk_ld == tot_contacts_home_wk_nld
ttest tot_contacts_work_wk_ld ==tot_contacts_work_wk_nld
ttest tot_contacts_school_wk_ld == tot_contacts_school_wk_nld
ttest tot_contacts_trans_wk_ld == tot_contacts_trans_wk_nld
ttest tot_contacts_ent_we_ld == tot_contacts_ent_we_nld


*****************************on aggregate differences ***************************************************************************

use "stata_input/ind_contacts_by_place.dta", clear
format hhmem_key %13.0f 

la values age_5 age_5
la values occ_2 oc2 
la values site_type site_types 


sort hhmem_key place_ld_stat

*somehow site type labels went missing
label values site_type site_type

*drop down to stats just total difference across all places
keep if place_ld_stat ==1
drop place_ld_stat
drop tot_contacts_wk_nld 
drop diff_contacts_ld 

*the results for the all places difference regression
asdoc reg diff_all_places ib3.occ_2 i.gender i.age_5 i.site_type i.ses_5, title(Regression Results for Difference in all Contacts pre-post lockdown) abb(.) replace(diff_reg.doc) 




********************************************************
** For plotting the margins on the difference and the drop
********************************************************

asdoc margins i.gender, replace save(tables/q3/margins_diff) abb(.) 
asdoc margins i.age_5, append save(tables/q3/margins_diff) abb(.) 
asdoc margins i.occ_2, append save(tables/q3/margins_diff) abb(.)
asdoc margins i.ses_5, append save(tables/q3/margins_diff) abb(.)
asdoc margins i.site_type, append save(tables/q3/margins_diff) abb(.) 

*** raw margins output for plotting in python and the graphs

margins i.gender 
marginsplot, fxsize(50) horizontal name(graph1, replace) 
graph export "plots/margins/margins_gender.png", replace
margins i.occ_2
marginsplot, fxsize(150) horizontal name(graph2, replace) 
graph export "plots/margins/margins_occ2.png", replace
margins i.ses_5
marginsplot, fxsize(80) horizontal name(graph3, replace)
graph export "plots/margins/margins_ses.png", replace
margins i.age_5
marginsplot, fxsize(80) horizontal name(graph4, replace)
graph export "plots/margins/margins_age.png", replace


graph combine graph1 graph2 graph3 graph4,
graph export "plots/margins/margins_comb.png", replace

********************************************************
** For plotting the lollipop plots with raw differences - use the WIDE dataset
********************************************************
use "stata_input/IVQ_R8_newVars.dta", clear
format hhmem_key %13.0f 

sum nld_all_ages_contacts_week,d
sum ld_all_ages_contacts_week,d

sum nld_all_ages_contacts_week if gender ==1 ,d
sum nld_all_ages_contacts_week if gender ==2 ,d

sum tot_contacts_home_wk_nld, d
sum tot_contacts_home_wk_ld, d

sum tot_contacts_work_wk_nld, d
sum tot_contacts_work_wk_ld, d

preserve
collapse (median) nld_all_ages_contacts_week ld_all_ages_contacts_week , by(gender)
export delimited "stata_output/pre_post_diff_gender_lollipop.csv", replace
restore

preserve 
collapse (median) nld_all_ages_contacts_week ld_all_ages_contacts_week , by(age_5)
export delimited "stata_output/pre_post_diff_age_lollipop.csv", replace
restore

preserve 
collapse (median) nld_all_ages_contacts_week ld_all_ages_contacts_week , by(ses_5)
export delimited "stata_output/pre_post_diff_ses_lollipop.csv", replace
restore

*use the long dataset for mean over places_nld
use "stata_input/ind_contacts_by_place.dta", clear
format hhmem_key %13.0f 

collapse (median) contacts_in_place_nld contacts_in_place_ld, by (place_mergeable)
export delimited "stata_output/pre_post_diff_place_lollipop.csv", replace
