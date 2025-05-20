
clear all

****************do lockdown equivalents
**************************************************************************************************
* generate the descriptive tables for each of the cut off options 
**************************************************************************************************

foreach x in _50cutoff _100cutoff _200cutoff {
	use "stata_input/IVQ_R8_newVars`x'.dta", clear
	asdoc, text(Average no. of contacts per individual on weekdays - lockdown with `x') fs(16) cmd ///
	save(tables/q1/comp_av_contacts_ld`x'.doc), replace 
	asdoc tabstat ld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f), append
	asdoc tabstat ld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(gender) format(%9.0f), append
	asdoc tabstat ld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(ses_5) format(%9.0f), append
	asdoc tabstat ld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(age_5) format(%9.0f), append
	asdoc tabstat ld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(site_type) format(%9.0f) ///
		stubwidth(9) cs(10), append
	asdoc tabstat ld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(occ_2) format(%9.0f) ///
	stubwidth(9) cs(10), append

	*just for the purpose of this table, simplify the variable names
	rename tot_contacts_school_wk_ld school_ld
	rename tot_contacts_work_wk_ld work_ld
	rename tot_contacts_home_wk_ld home_ld
	rename tot_contacts_trans_wk_ld trans_ld
	rename tot_contacts_ent_we_ld ent_ld
	

	asdoc tabstat home_ld, stat(mean p25 p50 p75 min max sd N) format(%9.0f) stubwidth(9) cs(10), append
	asdoc tabstat work_ld, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f) stubwidth(9) cs(10), append
	*only including school goers below
	asdoc tabstat school_ld if occ_2==2, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f) stubwidth(9) cs(10), append
	asdoc tabstat trans_ld, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f) stubwidth(9) cs(10), append
	asdoc tabstat ent_ld, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f) stubwidth(9) cs(10), append
}


use "stata_input/IVQ_R8_newVars_200cutoff.dta", clear
format hhmem_key %13.0f 

*for lshtm presentation am showing with 200 cut off 

qui ds diff_*
foreach var in `r(varlist)' {
	replace `var'=. if nld_all_ages_contacts_week >200 |ld_all_ages_contacts_week >200
}


************************************************************
**Q4: What variables are most strongly correlated with changes in contacts pre and post lockdown? 
************************************************************

*do the separate regressions for each place (changed to do this on a wide dataset)

*all places
asdoc reg diff_all_places_wk_ld ib3.occ_2 i.gender i.age_5 i.site_type i.ses_5, title(Determinants of difference in contacts by place pre-post lockdown) abb(.) save(tables/q4/reg_diff_by_place_200) replace

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
asdoc reg diff_all_places_wk_ld ib3.occ_2 i.gender i.age_5 i.site_type i.ses_5, title(Determinants of difference in contacts by place pre-post lockdown - nested) abb(.) nested cnames(diff_all places) save(tables/q4/reg_diff_by_place_nst_200) replace
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

use "stata_input/ind_contacts_by_place_py_max200.dta", clear
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
asdoc reg diff_all_places ib3.occ_2 i.gender i.age_5 i.site_type i.ses_5, title(Regression Results for Difference in all Contacts pre-post lockdown) abb(.) replace(diff_reg_200.doc) 




********************************************************
** For plotting the margins on the difference and the drop
********************************************************
asdoc margins, replace save(tables/q3/margins_diff_200) abb(.) 
asdoc margins i.gender, append save(tables/q3/margins_diff_200) abb(.) 
asdoc margins i.age_5, append save(tables/q3/margins_diff_200) abb(.) 
asdoc margins i.occ_2, append save(tables/q3/margins_diff_200) abb(.)
asdoc margins i.ses_5, append save(tables/q3/margins_diff_200) abb(.)
asdoc margins i.site_type, append save(tables/q3/margins_diff_200) abb(.) 

*** raw margins output for plotting in python and the graphs

margins i.gender 
marginsplot, fxsize(50) horizontal name(graph1, replace) 
graph export "plots/margins/margins_gender_200.png", replace
margins i.occ_2
marginsplot, fxsize(150) horizontal name(graph2, replace) 
graph export "plots/margins/margins_occ2_200.png", replace
margins i.ses_5
marginsplot, fxsize(80) horizontal name(graph3, replace)
graph export "plots/margins/margins_ses_200.png", replace
margins i.age_5
marginsplot, fxsize(80) horizontal name(graph4, replace)
graph export "plots/margins/margins_age_200.png", replace


graph combine graph1 graph2 graph3 graph4,
graph export "plots/margins/margins_comb_200.png", replace
