
********************************************************
** For plotting the lollipop plots with raw differences - use the WIDE dataset
********************************************************
use "stata_input/IVQ_R8_newVars_200cutoff.dta", clear
format hhmem_key %13.0f 

*for all displays, make max 200 (as per lshtm presentation 2nd may 2023)
replace nld_all_ages_contacts_week = . if nld_all_ages_contacts_week >200

*for all displays, make max 200
replace ld_all_ages_contacts_week = . if ld_all_ages_contacts_week >200

*for the margins also, I want the max diff to correspond only to values of 200 & below



graph hbox nld_all_ages_contacts_week, over(occupations) title("Distribution of contacts of all ages by occupation - weekdays") 
graph export "plots/compare_occupations/boxplot_cbo_weekdays_all_ages.png", replace



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

**********************************************************************************
**Q2: What variables are most strongly correlated with the number of contacts people had pre-lockdown*
**********************************************************************************


//a) on wide dataset - overall contacts (all ages, all places) and their associations 

use "stata_input/IVQ_R8_newVars_200cutoff.dta", clear
format hhmem_key %13.0f 

replace nld_all_ages_contacts_week = . if nld_all_ages_contacts_week >720


*generate a bottom 60 vs top 40 for the ses_5
gen b60= .
replace b60=1 if inlist(ses_5,1,2,3)
replace b60=0 if inlist(ses_5,4,5)

la define b60 0 "t40" 1 "b60"
la values b60 b60

asdoc nbreg nld_all_ages_contacts_week ib3.occ_2 i.gender i.age_5 i.site_type i.b60,  irr abb(.) save(tables/q2/q2_nb_reg_wide_irr_200) replace

asdoc nbreg nld_all_ages_contacts_week ib3.occ_2 i.gender i.age_5 i.site_type i.b60, abb(.) save(tables/q2/q2_nb_reg_wide_200) replace


//b) on long dataset - originally ran 6 regressions. Cutting down here to those that make sense 

* nonlockdown by place 
use "stata_input/ind_nld_contacts_by_place.dta", clear
xtset hhmem_key place_ld_stat // establish that its a panel of individuals and places

*generate a bottom 60 vs top 40 for the ses_5
gen b60= .
replace b60=1 if inlist(ses_5,1,2,3)
replace b60=0 if inlist(ses_5,4,5)

la define b60 0 "t40" 1 "b60"
la values b60 b60


*2 - 1 model as per below but fe for place_ld_stat 5 for individual places 
//
// xtset place_ld_stat
// asdoc xtnbreg tot_contacts_wk_nld i.place_ld_stat ib3.occ_2 i.gender i.age_5 i.site_type i.ses_5, fe irr abb(.) save(tables/q2/q2_nb_reg_long_v2) replace
// //it runs 300 iterations and then says 'convergence not acheived' ... we decided to throw this one out

*2 - This will be one per place

*home
asdoc nbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site_type i.b60 if place_ld_stat==6, irr abb(.)  title(Regression results by Place - Non-lockdown, Home) save(tables/q2/q2_nb_reg_long_v4_200) replace 
*work
asdoc nbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site_type i.b60 if place_ld_stat==7 & occupations!=10 & occupations !=11, irr abb(.)  title(Non-lockdown, Work) save(tables/q2/q2_nb_reg_long_v4_200) append
*school
asdoc nbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site_type i.b60 if place_ld_stat==8 & occupations==10, irr abb(.)  title(Non-lockdown, School) save(tables/q2/q2_nb_reg_long_v4_200) append 
*transport
asdoc nbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site_type i.b60 if place_ld_stat==9, irr abb(.)  title(Non-lockdown, Transport) save(tables/q2/q2_nb_reg_long_v4_200) append 
*entertainment
asdoc nbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site i.b60 if place_ld_stat==10, irr abb(.)  title(Non-lockdown, Entertainment) save(tables/q2/q2_nb_reg_long_v4_200) append

***** nested version 


*home
asdoc nbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site_type i.b60 if place_ld_stat==6, label nested irr abb(.)  title(Negative Binomial regression results by Place compared) save(tables/q2/q2_nb_reg_long_v4_nst_200) replace 
*work (include everybody - can separately subset occupations!=10 & occupations !=11) 
asdoc nbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site_type i.b60 if place_ld_stat==7, label nested irr abb(.) save(tables/q2/q2_nb_reg_long_v4_nst_200) append
*school
asdoc nbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site_type i.b60 if place_ld_stat==8 & occupations==10, label nested irr abb(.) save(tables/q2/q2_nb_reg_long_v4_nst_200) append 
*transport
asdoc nbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site_type i.b60 if place_ld_stat==9, label nested irr abb(.)  save(tables/q2/q2_nb_reg_long_v4_nst_200) append 
*entertainment
asdoc nbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site_type i.b60 if place_ld_stat==10, label nested irr abb(.) save(tables/q2/q2_nb_reg_long_v4_nst_200) append
