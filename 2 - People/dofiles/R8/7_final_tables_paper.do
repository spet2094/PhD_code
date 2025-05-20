clear all
cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/08_Fieldwork/08_Data/R8_data"

* Final dofile for Social Contacts Paper results 


**********************************************************************************
**Q1: What were the contact numbers in the study population by subgroup BEFORE the lockdown*
*************************************************************************

*********only using the 200cut off version

use "stata_input/IVQ_R8_newVars_200cutoff.dta", clear
format hhmem_key %13.0f 

tab occupations gender, col nofreq 

* do a version which is just tabstats without the asdoc

tabstat nld_all_ages_contacts_week, stat(mean median p25 p75) 
tabstat nld_all_ages_contacts_week, stat(median p25 p75) by(gender) 
tabstat nld_all_ages_contacts_week, stat(median p25 p75)  by(ses_5) 
tabstat nld_all_ages_contacts_week, stat(median p25 p75)  by(age_5) 
tabstat nld_all_ages_contacts_week, stat(median p25 p75)  by(site_type) 
tabstat nld_all_ages_contacts_week, stat(median p25 p75)  by(occ_2) 


tabstat nld_all_ages_contacts_we, stat(median p25 p75) 
tabstat nld_all_ages_contacts_we, stat(median p25 p75) by(gender) 
tabstat nld_all_ages_contacts_we, stat(median p25 p75)  by(ses_5) 
tabstat nld_all_ages_contacts_we, stat(median p25 p75)  by(age_5) 
tabstat nld_all_ages_contacts_we, stat(median p25 p75)  by(site_type) 
tabstat nld_all_ages_contacts_we, stat(median p25 p75)  by(occ_2)

ttest nld_all_ages_contacts_week == nld_all_ages_contacts_we
// use table1mc - example https://bmcinfectdis.biomedcentral.com/articles/10.1186/s12879-021-06604-8/tables/2 

* comparative ld 
tabstat ld_all_ages_contacts_week, stat(mean median p25 p75) 

************************************************************************
*tables for non-lockdown
************************************************************************

table1_mc, vars(nld_all_ages_contacts_week conts)

table1_mc, vars(gender cat \ ses_5 cat \ age_5 cat \ site_type cat \ occ_2 cat) saving("tables/q1/final/baseline_chars_r8.xlsx", replace) 

*get the significance statistics (z for gender and chi for all others), then add them in manually to the tables produced above
foreach var in gender ses_5 age_5 site_type occ_2 {
table1_mc, by(`var') vars(nld_all_ages_contacts_week conts %5.0f) 
}

**********************************************************************
*tables by place
**********************************************************************
**POPULATION LEVEL
*just for the purpose of this table, simplify the variable names
rename pop_tot_contacts_school_wk_nld pop_school_nld
rename tot_contacts_work_wk_nld work_nld
rename tot_contacts_home_wk_nld home_nld
rename tot_contacts_trans_wk_nld trans_nld
rename tot_contacts_ent_we_nld ent_nld

tabstat home_nld, stat(mean median p25 p75 N) 
tabstat work_nld, stat(mean median p25 p75 N) 
*only including school goers below
tabstat pop_school_nld, stat(mean median p25 p75 N) 

tabstat trans_nld, stat(mean median p25 p75 N) 
tabstat ent_nld, stat(mean median p25 p75 N) 


*PLACE LEVEL

*just for the purpose of this table, simplify the variable names
rename place_tot_contacts_school_wk_nld place_school_nld
rename m_tot_contacts_work_wk_nld m_work_nld
rename m_tot_contacts_home_wk_nld m_home_nld
rename m_tot_contacts_trans_wk_nld m_trans_nld
rename m_tot_contacts_ent_we_nld m_ent_nld

tabstat m_home_nld, stat(mean median p25 p75 N) 
tabstat m_work_nld, stat(mean median p25 p75 N) 
*only including school goers below
tabstat place_school_nld if occ_2==2, stat(mean median p25 p75 N) 

tabstat m_trans_nld, stat(mean median p25 p75 N) 
tabstat m_ent_nld, stat(mean median p25 p75 N) 

sum pop_school_nld place_school_nld

***************************************************************************
**Q2: What variables are most strongly correlated with the number of contacts people had pre-lockdown*
***************************************************************************

//a) on wide dataset - overall contacts (all ages, all places) and their associations 

use "stata_input/IVQ_R8_newVars_200cutoff.dta", clear
format hhmem_key %13.0f 

*generate a bottom 60 vs top 40 for the ses_5
gen b60= .
replace b60=1 if inlist(ses_5,1,2,3)
replace b60=0 if inlist(ses_5,4,5)

la define b60 0 "t40" 1 "b60"
la values b60 b60

// asdoc nbreg nld_all_ages_contacts_week ib3.occ_2 i.gender i.age_5 i.site_type i.ses_5,  irr abb(.) save(tables/q2/final/q2_nb_reg_wide_irr)  title(2. Correlates of pre-lockdown contacts - Negative binomial regression) replace

**estout version of this table (Adapt to include multiple columns)
eststo clear
eststo: nbreg nld_all_ages_contacts_week  i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2, irr 

estout using tables/q2/final/q2_nb_reg_wide_irr.txt, cells("b (fmt(%7.2f)) ci_l ci_u _star")  title ("Correlates of pre-lockdown contacts - Negative binomial regression") label eform refcat()  replace


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

*2 - This will be one per place (SI)

*home
asdoc nbreg contacts_in_place_nld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2 if place_ld_stat==6, irr abb(.)  title(Regression results by Place - Non-lockdown, Home) save(tables/q2/final/q2_nbreg_by_place) replace 

*work
asdoc nbreg contacts_in_place_nld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2 i.b60 if place_ld_stat==7 & occupations!=10 & occupations !=11, irr abb(.)  title(Non-lockdown, Work) save(tables/q2/final/q2_nbreg_by_place) append
*school
asdoc nbreg contacts_in_place_nld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2 if place_ld_stat==8 & occupations==10, irr abb(.)  title(Non-lockdown, School) save(tables/q2/final/q2_nbreg_by_place) append 
*transport
asdoc nbreg contacts_in_place_nld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2 if place_ld_stat==9, irr abb(.)  title(Non-lockdown, Transport) save(tables/q2/final/q2_nbreg_by_place) append 
*entertainment
asdoc nbreg contacts_in_place_nld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2 if place_ld_stat==10, irr abb(.)  title(Non-lockdown, Entertainment) save(tables/q2/final/q2_nbreg_by_place) append

// changed covariates as per 1

*** try to do the nesting another way (1. everybody first (population level), 2. subset including work and school subsets and transport and entertainment for those who use)

*home
asdoc nbreg contacts_in_place_nld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2 if place_ld_stat==6, label nested irr abb(.)  title(Negative Binomial regression results by Place compared) save(tables/q2/final/q2_nbreg_by_place_nst) replace 
*work (include everybody - can separately subset occupations!=10 & occupations !=11) 
asdoc nbreg contacts_in_place_nld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2 if place_ld_stat==7, label nested irr abb(.) save(tables/q2/final/q2_nbreg_by_place_nst) append
*school
asdoc nbreg contacts_in_place_nld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2 if place_ld_stat==8 & occupations==10, label nested irr abb(.) save(tables/q2/final/q2_nbreg_by_place_nst) append 
*transport
asdoc nbreg contacts_in_place_nld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2 if place_ld_stat==9, label nested irr abb(.)  save(tables/q2/final/q2_nbreg_by_place_nst) append 
*entertainment
asdoc nbreg contacts_in_place_nld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2 if place_ld_stat==10, label nested irr abb(.) save(tables/q2/final/q2_nbreg_by_place_nst) append

//using tables/q2/final/q2_nb_reg_wide_irr.txt

*3 - In the below model we are allowing socio economic characteristics to vary by place as an interaction term ()
asdoc nbreg contacts_in_place_nld i.place_ld_stat##(ib3.occ_2 i.gender i.age_5 i.site_type i.b60), irr abb(.) title(Interaction Model by Place - Negative Binomial Regression) save(tables/q2/final/q2_interaction) replace

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

replace diff_all_places_wk_ld = . if diff_all_places_wk_ld >200

*first export differences in totals and significance level by place and by age group
asdoc, text(Diff no. of contacts per individual on weekdays - ld vs. nld) fs(16) cmd  save(tables/q3/final/diff_contacts_ld_nld.doc), replace 
asdoc tabstat diff_all_places_wk_ld, stat(mean median min max N) format(%9.0f), append
asdoc tabstat diff_all_places_wk_ld, stat(mean median min max N) by(gender) format(%9.0f), append
asdoc tabstat diff_all_places_wk_ld, stat(mean median min max N) by(ses_5) format(%9.0f), append
asdoc tabstat diff_all_places_wk_ld, stat(mean median min max N) by(age_5) format(%9.0f), append
asdoc tabstat diff_all_places_wk_ld, stat(mean median min max N) by(site_type) format(%9.0f) stubwidth(9) cs(10), abb(.) append
asdoc tabstat diff_all_places_wk_ld, stat(mean median min max N) by(occ_2) format(%9.0f) stubwidth(9) cs(10), abb(.) append

* do a version which is just tabstats without the asdoc

tabstat diff_all_places_wk_ld, stat(mean median p25 p75 N) 
tabstat diff_all_places_wk_ld, stat(mean median p25 p75 N) by(gender) 
tabstat diff_all_places_wk_ld, stat(mean median p25 p75 N)  by(ses_5) 
tabstat diff_all_places_wk_ld, stat(mean median p25 p75 N)  by(age_5) 
tabstat diff_all_places_wk_ld, stat(mean median p25 p75 N)  by(site_type) 
tabstat diff_all_places_wk_ld, stat(mean median p25 p75 N)  by(occ_2) 

table1_mc, vars(diff_all_places_wk_ld conts)

table1_mc, vars(gender cat \ ses_5 cat \ age_5 cat \ site_type cat \ occ_2 cat) saving("tables/q1/final/diff_chars_r8.xlsx", replace) 

*this needs changing to be m_ differences 

tabstat m_diff_home_wk_ld, stat(mean median p25 p75 N) 
tabstat m_diff_sch_wk_ld if occ_2==2, stat(mean median p25 p75 N) 
tabstat m_diff_work_wk_ld if occupations!=10 & occupations !=11, stat(mean median p25 p75 N) 
tabstat m_diff_trans_wk_ld, stat(mean median p25 p75 N)  
tabstat m_diff_ent_we_ld, stat(mean median p25 p75 N)  

tabstat diff_home_wk_ld, stat(mean median p25 p75 N) 
tabstat diff_sch_wk_ld if occ_2==2, stat(mean median p25 p75 N) 
tabstat diff_work_wk_ld if occupations!=10 & occupations !=11, stat(mean median p25 p75 N) 
tabstat diff_trans_wk_ld, stat(mean median p25 p75 N)  
tabstat diff_ent_we_ld, stat(mean median p25 p75 N)  


************************************************************
**Q3: HOW BIG WAS THE CHANGE PRE-POST LOCKDOWN
************************************************************

*First do the same lockdown descriptive stats as for Q1 
use "stata_input/IVQ_R8_newVars_200cutoff.dta", clear
format hhmem_key %13.0f 

* do a version which is just tabstats without the asdoc

tabstat ld_all_ages_contacts_week, stat(median p25 p75 N) 
tabstat ld_all_ages_contacts_week, stat(median p25 p75 N) by(gender) 
tabstat ld_all_ages_contacts_week, stat(median p25 p75 N)  by(ses_5) 
tabstat ld_all_ages_contacts_week, stat(median p25 p75 N)  by(age_5) 
tabstat ld_all_ages_contacts_week, stat(median p25 p75 N)  by(site_type) 
tabstat ld_all_ages_contacts_week, stat(median p25 p75 N)  by(occ_2) 

*table 1mc version 
table1_mc, vars(ld_all_ages_contacts_week conts)


table1_mc, vars(gender cat \ ses_5 cat \ age_5 cat \ site_type cat \ occ_2 cat) saving("tables/q1/final/ld_chars_r8.xlsx", replace) 

*get the significance statistics (z for gender and chi for all others), then add them in manually to the tables produced above
foreach var in gender ses_5 age_5 site_type occ_2 {
table1_mc, by(`var') vars(ld_all_ages_contacts_week conts %5.0f) stat
}


**********************************************************************
*tables by place
**********************************************************************
**POPULATION LEVEL
*just for the purpose of this table, simplify the variable names
rename pop_tot_contacts_school_wk_ld pop_school_ld
rename tot_contacts_work_wk_ld work_ld
rename tot_contacts_home_wk_ld home_ld
rename tot_contacts_trans_wk_ld trans_ld
rename tot_contacts_ent_we_ld ent_ld

tabstat home_ld, stat(mean median p25 p75 N) 
tabstat work_ld, stat(mean median p25 p75 N) 
*only including school goers below
tabstat pop_school_ld if occ_2==2, stat(mean median p25 p75 N) 
tabstat trans_ld, stat(mean median p25 p75 N) 
tabstat ent_ld, stat(mean median p25 p75 N) 


*PLACE LEVEL

*just for the purpose of this table, simplify the variable names
rename place_tot_contacts_school_wk_ld place_school_ld
rename m_tot_contacts_work_wk_ld m_work_ld
rename m_tot_contacts_home_wk_ld m_home_ld
rename m_tot_contacts_trans_wk_ld m_trans_ld
rename m_tot_contacts_ent_we_ld m_ent_ld

tabstat m_home_ld, stat(mean median p25 p75 N) 
tabstat m_work_ld, stat(mean median p25 p75 N) 
*only including school goers below
tabstat place_school_ld if occ_2==2, stat(mean median p25 p75 N) 
tabstat m_trans_ld, stat(mean median p25 p75 N) 
tabstat m_ent_ld, stat(mean median p25 p75 N) 


*plot the margins

********************************************************
** For plotting the margins on the difference and the drop
********************************************************

*first need to run the regression 

reg diff_all_places i.gender i.ses_5 i.age_5 i.site_type ib3.occ_2

asdoc margins , replace save(tables/q3/final/margins_diff) abb(.) 
asdoc margins i.gender, append save(tables/q3/final/margins_diff) abb(.) 
asdoc margins i.ses_5, append save(tables/q3/final/margins_diff) abb(.)
asdoc margins i.age_5, append save(tables/q3/final/margins_diff) abb(.)
asdoc margins i.site_type, append save(tables/q3/final/margins_diff) abb(.)  
asdoc margins i.occ_2, append save(tables/q3/final/margins_diff) abb(.)


********************************************************
** For plotting the python lollipop plots with raw differences - use the WIDE dataset and copy and paste these
*******************************************************

foreach x in nld_all_ages_contacts_week ld_all_ages_contacts_week {
tabstat `x', stat(mean p25 p50 p75 min max sd N)
tabstat `x', stat(mean p25 p50 p75 min max sd N) by (gender)
tabstat `x', stat(mean p25 p50 p75 min max sd N) by (ses_5)
tabstat `x', stat(mean p25 p50 p75 min max sd N) by (age_5)
tabstat `x', stat(mean p25 p50 p75 min max sd N) by (site_type)
tabstat `x', stat(mean p25 p50 p75 min max sd N) by (occ_2)
}

*just for the purpose of this table, simplify the variable names
rename place_tot_contacts_school_wk_nld place_school_nld
rename m_tot_contacts_work_wk_nld m_work_nld
rename m_tot_contacts_home_wk_nld m_home_nld
rename m_tot_contacts_trans_wk_nld m_trans_nld
rename m_tot_contacts_ent_we_nld m_ent_nld


qui ds m_home* m_work* m_trans* m_ent*
foreach var in `r(varlist)' {
tabstat `var', stat(mean p25 p50 p75 min max sd N),
}

*school separate because needs to be school kids only
qui ds  place_school* 
foreach var in `r(varlist)' {
tabstat `var' if occ_2==2, stat(mean p25 p50 p75 min max sd N)
}

* margins by place

*first need to run the regression 
preserve

keep if occ_2==2
reg diff_sch_wk_ld i.gender i.ses_5 i.age_5 i.site_type ib3.occ_2 

asdoc margins , replace save(tables/q3/final/margins_diff_school) abb(.) 
asdoc margins i.gender, append save(tables/q3/final/margins_diff_school) abb(.) 
asdoc margins i.age_5, append save(tables/q3/final/margins_diff_school) abb(.) 
asdoc margins i.occ_2, append save(tables/q3/final/margins_diff_school) abb(.)
asdoc margins i.ses_5, append save(tables/q3/final/margins_diff_school) abb(.)
asdoc margins i.site_type, append save(tables/q3/final/margins_diff_school) abb(.) 

restore 
************************************************************
**Q4: What variables are most strongly correlated with changes in contacts pre and post lockdown? 
************************************************************

*all places
asdoc reg diff_all_places_wk_ld i.gender i.ses_5 i.age_5 i.site_type ib3.occ_2, title(Determinants of difference in contacts by place pre-post lockdown) abb(.) save(tables/q4/final/reg_diff_by_place) replace

est store q4_reg, title(Model 2)
estout q4_reg using tables/q4/final/reg_diff_by_place.txt, cells("b ci_l ci_u _star")  title ("Determinants of difference in contacts by place pre-post lockdown") label  replace


// change defaults to push out point estimate and CI side by side (estout does this, and outreg)

***********POP LEVEL 

*all places
asdoc reg diff_all_places_wk_ld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2, title(Determinants of difference in contacts by place pre-post lockdown - nested) abb(.) nested cnames(All places) save(tables/q4/final/reg_diff_by_place_nst) replace

*home
asdoc reg diff_home_wk_ld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2, abb(.) nested cnames(Home) append
*work (IGNORE STUDENTS)
asdoc reg diff_work_wk_ld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2 if occupation !=10, abb(.) nest cnames(Work) append
*school (ONLY COUNT STUDENTS AND TEACHERS)
asdoc reg diff_sch_wk_ld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2 if occ_2==2, abb(.) nest cnames(School) append
*transport
asdoc reg diff_trans_wk_ld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2, abb(.) nest cnames(Trans) append
*ent
asdoc reg diff_ent_we_ld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2,  abb(.) nest cnames(Ent) append

** use estout version 

*all places
reg diff_all_places_wk_ld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2
eststo allplaces
*home
reg diff_home_wk_ld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2
eststo home
*work (IGNORE STUDENTS)
asdoc reg diff_work_wk_ld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2 if occupation !=10
eststo work
*school (ONLY COUNT STUDENTS AND TEACHERS)
asdoc reg diff_sch_wk_ld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2 if occ_2==2
eststo school
*transport
asdoc reg diff_trans_wk_ld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2
eststo transport
*ent
asdoc reg diff_ent_we_ld i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2
eststo entertainment 

esttab allplaces home work school transport entertainment using "tables/q4/final/reg_diff_by_place_nst.rtf", se r2 legend replace




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
asdoc reg diff_all_places ib3.occ_2 i.gender i.age_5 i.site_type i.ses_5, title(Regression Results for Difference in all Contacts pre-post lockdown) abb(.) save(tables/q4/final/diff_reg.doc), replace


