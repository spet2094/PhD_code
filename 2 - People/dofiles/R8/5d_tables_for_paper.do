clear all
cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/08_Fieldwork/08_Data/R8_data"

* Final dofile for Social Contacts Paper results 


**********************************************************************************
**Q1: What were the contact numbers in the study population by subgroup BEFORE the lockdown*
**********************************************************************************


**********************************************************************
***************************************************
* a version with 200 cut off for the paper as default 
***************************************************


foreach x in _200cutoff {
	use "stata_input/IVQ_R8_newVars`x'.dta", clear
format hhmem_key %13.0f 

	asdoc, text(Average no. of contacts per individual on weekdays - non-lockdown. Cleaned for >`x') fs(16) cmd  save(tables/q1/final/comp_av_contacts_nld`x'.doc), replace 
asdoc tabstat nld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f), append
asdoc tabstat nld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(gender) format(%9.0f), append
asdoc tabstat nld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(ses_5) format(%9.0f), append
asdoc tabstat nld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(age_5) format(%9.0f), append
asdoc tabstat nld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(site_type) format(%9.0f) stubwidth(9) cs(10), append
asdoc tabstat tot_contacts_work_wk_nld, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(occ_2) format(%9.0f) stubwidth(9) cs(10), append
// note the by occupation is just contacts at work

*just for the purpose of this table, simplify the variable names
rename tot_contacts_school_wk_nld school_nld
rename tot_contacts_work_wk_nld work_nld
rename tot_contacts_home_wk_nld home_nld
rename tot_contacts_trans_wk_nld trans_nld
rename tot_contacts_ent_we_nld ent_nld

asdoc tabstat home_nld, stat(mean p25 p50 p75 min max sd N) format(%9.0f) stubwidth(9) cs(10), append
asdoc tabstat work_nld, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f) stubwidth(9) cs(10), append
*only including school goers below
asdoc tabstat school if occ_2==2, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f) stubwidth(9) cs(10), append
asdoc tabstat trans_nld, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f) stubwidth(9) cs(10), append
asdoc tabstat ent_nld, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f) stubwidth(9) cs(10), append
}


**********************************************************************************
**Q2: What variables are most strongly correlated with the number of contacts people had pre-lockdown*
**********************************************************************************

//a) on wide dataset - overall contacts (all ages, all places) and their associations 

use "stata_input/IVQ_R8_newVars_200cutoff.dta", clear
format hhmem_key %13.0f 

replace nld_all_ages_contacts_week = . if nld_all_ages_contacts_week >720
e

*generate a bottom 60 vs top 40 for the ses_5
gen b60= .
replace b60=1 if inlist(ses_5,1,2,3)
replace b60=0 if inlist(ses_5,4,5)

la define b60 0 "t40" 1 "b60"
la values b60 b60

asdoc nbreg nld_all_ages_contacts_week ib3.occ_2 i.gender i.age_5 i.site_type i.b60,  irr abb(.) save(tables/q2/q2_nb_reg_wide_irr) replace

asdoc nbreg nld_all_ages_contacts_week ib3.occ_2 i.gender i.age_5 i.site_type i.b60, abb(.) save(tables/q2/q2_nb_reg_wide) replace


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

*1- for overall (contacts across all individual locations together) ie tot_contacts total across all places summed everywhere

asdoc xtnbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site_type i.b60, irr fe abb(.) save(tables/q2/q2_nb_reg_long_v1) replace
//check this with Guy, esp the addition of xtset category on L96 and the fe specification not including place variable explicitly. it is using 20k obs I'm not sure why 

// we decided this is not very useful because it doesn't allow differences by location, however, can be reported for comparison in an annex 


*2 - 1 model as per below but fe for place_ld_stat 5 for individual places 
//
// xtset place_ld_stat
// asdoc xtnbreg tot_contacts_wk_nld i.place_ld_stat ib3.occ_2 i.gender i.age_5 i.site_type i.ses_5, fe irr abb(.) save(tables/q2/q2_nb_reg_long_v2) replace
// //it runs 300 iterations and then says 'convergence not acheived' ... we decided to throw this one out

*2 - This will be one per place

*home
asdoc nbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site_type i.b60 if place_ld_stat==6, irr abb(.)  title(Regression results by Place - Non-lockdown, Home) save(tables/q2/q2_nb_reg_long_v4) replace 
*work
asdoc nbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site_type i.b60 if place_ld_stat==7 & occupations!=10 & occupations !=11, irr abb(.)  title(Non-lockdown, Work) save(tables/q2/q2_nb_reg_long_v4) append
*school
asdoc nbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site_type i.b60 if place_ld_stat==8 & occupations==10, irr abb(.)  title(Non-lockdown, School) save(tables/q2/q2_nb_reg_long_v4) append 
*transport
asdoc nbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site_type i.b60 if place_ld_stat==9, irr abb(.)  title(Non-lockdown, Transport) save(tables/q2/q2_nb_reg_long_v4) append 
*entertainment
asdoc nbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site i.b60 if place_ld_stat==10, irr abb(.)  title(Non-lockdown, Entertainment) save(tables/q2/q2_nb_reg_long_v4) append

// changed covariates as per 1

*labelled
// bys place_ld_stat: asdoc nbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site_type i.b60, label nested irr abb(.) title(Negative Binomial regression results by Place compared) save(tables/q2/q2_nb_reg_long_v4_nested_dnu)  replace 
// this isn't right because it doesn't allow us to explicitly specify conditions as below e.g. those who don't go to school in the school contacts

*** try to do the nesting another way (1. everybody first (population level), 2. subset including work and school subsets and transport and entertainment for those who use)

*home
asdoc nbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site_type i.b60 if place_ld_stat==6, label nested irr abb(.)  title(Negative Binomial regression results by Place compared) save(tables/q2/q2_nb_reg_long_v4_nst) replace 
*work (include everybody - can separately subset occupations!=10 & occupations !=11) 
asdoc nbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site_type i.b60 if place_ld_stat==7, label nested irr abb(.) save(tables/q2/q2_nb_reg_long_v4_nst) append
*school
asdoc nbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site_type i.b60 if place_ld_stat==8 & occupations==10, label nested irr abb(.) save(tables/q2/q2_nb_reg_long_v4_nst) append 
*transport
asdoc nbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site_type i.b60 if place_ld_stat==9, label nested irr abb(.)  save(tables/q2/q2_nb_reg_long_v4_nst) append 
*entertainment
asdoc nbreg contacts_in_place_nld ib3.occ_2 i.gender i.age_5 i.site_type i.b60 if place_ld_stat==10, label nested irr abb(.) save(tables/q2/q2_nb_reg_long_v4_nst) append

// see if i can find a way to make just nested results of this more accurate one 

*3 - In the below model we are allowing socio economic characteristics to vary by place as an interaction term ()
asdoc nbreg contacts_in_place_nld i.place_ld_stat##(ib3.occ_2 i.gender i.age_5 i.site_type i.b60), irr abb(.) save(tables/q2/q2_nb_reg_long_v3) replace

// after running this regression, are each of the interaction terms heterogeneous across places (via chi squared)
testparm i.place_ld_stat#(i.gender )
testparm i.place_ld_stat#(i.age_5)
testparm i.place_ld_stat#(i.occ_2)
testparm i.place_ld_stat#(i.site_type)
testparm i.place_ld_stat#(i.b60)
// the effect of each of these covariates varies by place
// chi2 value of !=0 means heterogeneity between gender by place 
// ses is least affected by place because value is closest to zero out of them
// <1.96 for z score, squared <3.92  
// in () after chi2 is the degrees of freedom 
// methods section write up that we did this interaction model to check that it makes sense to look at place separately (showing chi squared values) then put the reg table in the supplementary table. but include the testparm

************************************************************
**Q3: How big was the change in reported contacts pre-post lockdown - just the difference variable
************************************************************

use "stata_input/IVQ_R8_newVars_200cutoff.dta", clear

replace diff_all_places_wk_ld = . if diff_all_places_wk_ld >720

*first export differences in totals and significance level by place and by age group
asdoc, text(Diff no. of contacts per individual on weekdays - ld vs. nld) fs(16) cmd  save(tables/q3/diff_contacts_ld_nld.doc), replace 
asdoc tabstat diff_all_places_wk_ld, stat(mean median min max sd N) format(%9.0f), append
asdoc tabstat diff_all_places_wk_ld, stat(mean median min max sd N) by(gender) format(%9.0f), append
asdoc tabstat diff_all_places_wk_ld, stat(mean median min max sd N) by(ses_5) format(%9.0f), append
asdoc tabstat diff_all_places_wk_ld, stat(mean median min max sd N) by(age_5) format(%9.0f), append
asdoc tabstat diff_all_places_wk_ld, stat(mean median min max sd N) by(site_type) format(%9.0f) stubwidth(9) cs(10), abb(.) append
asdoc tabstat diff_all_places_wk_ld, stat(mean median min max sd N) by(occ_2) format(%9.0f) stubwidth(9) cs(10), abb(.) append

asdoc tabstat diff_home_wk_ld, stat(mean median min max sd N) format(%9.0f), append
asdoc tabstat diff_sch_wk_ld if occupation==10, stat(mean median min max sd N) format(%9.0f), append
asdoc tabstat diff_work_wk_ld if occupations!=10 & occupations !=11, stat(mean median min max sd N) format(%9.0f), append
asdoc tabstat diff_trans_wk_ld, stat(mean median min max sd N) format(%9.0f), append
asdoc tabstat diff_ent_we_ld, stat(mean median min max sd N) format(%9.0f), append

************************************************************
**Q3: Looking at the ld variable
************************************************************

use "stata_input/IVQ_R8_newVars.dta", clear
format hhmem_key %13.0f 

replace ld_all_ages_contacts_week = . if ld_all_ages_contacts_week >720

asdoc, text(Average no. of contacts per individual on weekdays - lockdown. Removing extreme outliers) fs(16) cmd  save(tables/q1/comp_av_contacts_ld.doc), replace 
asdoc tabstat ld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f), append
asdoc tabstat ld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(gender) format(%9.0f), append
asdoc tabstat ld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(ses_5) format(%9.0f), append
asdoc tabstat ld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(age_5) format(%9.0f), append
asdoc tabstat ld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(site_type) format(%9.0f) stubwidth(9) cs(10), append
asdoc tabstat ld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(occ_2) format(%9.0f) stubwidth(9) cs(10), append

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


***************************************************
* a version of contacts by PLACE (with exclusions) - lockdown
***************************************************

* lockdown

replace m_ld_all_ages_contacts_week = . if ld_all_ages_contacts_week >720

qui ds m_tot_contacts_*
foreach var in `r(varlist)' {
	replace `var' = . if `var' >720
}

// foreach x in school home work trans ent {
// 	replace tot_contacts_`x'_ld = . if tot_contacts_`x'_ld >720
// }	
sum tot_contacts_*

asdoc, text(Average no. of contacts by place on weekdays - non-lockdown. Excluding those who did not visit) fs(16) cmd  save(tables/q1/by_place_av_contacts_ld.doc), replace 
asdoc tabstat m_ld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f), append
asdoc tabstat m_ld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(gender) format(%9.0f), append
asdoc tabstat m_ld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(ses_5) format(%9.0f), append
asdoc tabstat m_ld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(age_5) format(%9.0f), append
asdoc tabstat m_ld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(site_type) format(%9.0f) stubwidth(9) cs(10), append
asdoc tabstat m_ld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(occ_2) format(%9.0f) stubwidth(9) cs(10), append


*just for the purpose of this table, simplify the variable names
rename m_tot_contacts_work_wk_ld m_work_ld
rename m_tot_contacts_home_wk_ld m_home_ld
rename m_tot_contacts_trans_wk_ld m_trans_ld
rename m_tot_contacts_ent_we_ld m_ent_ld

asdoc tabstat m_home_ld, stat(mean p25 p50 p75 min max sd N) format(%9.0f) stubwidth(9) cs(10), append
asdoc tabstat m_work_ld if occupations!=10 & occupations !=11, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f) stubwidth(9) cs(10), append
// excluding unemployed and school goers
asdoc tabstat school_ld if occ_2==2, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f) stubwidth(9) cs(10), append
asdoc tabstat m_trans_ld, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f) stubwidth(9) cs(10), append
asdoc tabstat m_ent_ld, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f) stubwidth(9) cs(10), append

