clear all
cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/08_Fieldwork/08_Data/R8_data"


use "stata_input/IVQ_R8_newVars_200cutoff.dta", clear
format hhmem_key %13.0f 


** do occupation tables for model input - note as I want one table, just for the purpose of display, i'm making a separate wp (workplace) variable which puts students in the 'workplace'

gen tot_contacts_wp_wk_nld=tot_contacts_work_wk_nld
replace tot_contacts_wp_wk_nld=tot_contacts_school_wk_nld if occupations == 10

gen tot_contacts_wp_wk_ld=tot_contacts_work_wk_ld
replace tot_contacts_wp_wk_ld=tot_contacts_school_wk_ld if occupations == 10

*create an occupations category that corresponds to census categories
gen economic_status=.
replace economic_status=1 if occupations==11
replace economic_status=2 if occupations==10
replace economic_status=3 if occupations==18
replace economic_status=4 if occupations==15
replace economic_status=5 if occupations==4
replace economic_status=6 if inlist(occupations,6,7,8,16,17)
// this is a weird category as service workers includes nurses and doctors, service or retail, informal petty trading, transport workers, sex workers
replace economic_status=7 if inlist(occupations, 1,9)
replace economic_status=8 if occupations==2
replace economic_status=9 if occupations==38
replace economic_status=10 if occupations==12

la define economic_status 1 "not working" 2 "students" 3 "homemakers" 4 "office workers" 5 "teachers" 6 "service workers" 7 "agricultural workers" 8 "industry workers" 9 "army" 10 "disabled and not working"
la values economic_status economic_status

tab economic_status

*now use the combined 'workplace' variable
tabstat tot_contacts_wp_wk_nld, stat(mean p25 p50 p75 sd) by(economic_status) format(%9.0f) labelwidth(50)

tabstat tot_contacts_wp_wk_ld, stat(mean p25 p50 p75 sd N)  by(economic_status) format(%9.0f) labelwidth(50)

preserve
*output for joy plots exclusively for occupation 
keep hhmem_key economic_status tot_contacts_wp_wk_nld tot_contacts_wp_wk_ld 

save "stata_input/IVQ_R8_newVars_200cutoff_econ_stat_only.dta", replace
restore

**************************************************************************************************
* test number of obs dropped at 100 contacts cut off
**************************************************************************************************
replace nld_all_ages_contacts_week = . if nld_all_ages_contacts_week >100

replace ld_all_ages_contacts_week = . if ld_all_ages_contacts_week >100

qui ds tot_contacts_*
foreach var in `r(varlist)' {
	replace `var' = . if `var' >100
}
tabstat nld_all_ages_contacts_week ld_all_ages_contacts_week tot_contacts_*, stat(mean p25 p50 p75 min max sd N) columns(s) varwidth(30)

save "stata_input/IVQ_R8_newVars_100cutoff.dta", replace


**************************************************************************************************
* test number of obs dropped at 50 contacts cut off
**************************************************************************************************

replace nld_all_ages_contacts_week = . if nld_all_ages_contacts_week >50

replace ld_all_ages_contacts_week = . if ld_all_ages_contacts_week >50

qui ds tot_contacts_*
foreach var in `r(varlist)' {
	replace `var' = . if `var' >50
}

* cut off at 50 contacts
tabstat nld_all_ages_contacts_week ld_all_ages_contacts_week tot_contacts_*, stat(mean p25 p50 p75 min max sd N) columns(s) varwidth(30)

save "stata_input/IVQ_R8_newVars_50cutoff.dta", replace

**************************************************************************************************
* generate the descriptive tables for each of the cut off options 
**************************************************************************************************

foreach x in _50cutoff _100cutoff _200cutoff {
	use "stata_input/IVQ_R8_newVars`x'.dta", clear
	asdoc, text(Average no. of contacts per individual on weekdays - non-lockdown with `x') fs(16) cmd ///
	save(tables/q1/comp_av_contacts_nld`x'.doc), replace 
	asdoc tabstat nld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f), append
	asdoc tabstat nld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(gender) format(%9.0f), append
	asdoc tabstat nld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(ses_5) format(%9.0f), append
	asdoc tabstat nld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(age_5) format(%9.0f), append
	asdoc tabstat nld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(site_type) format(%9.0f) ///
		stubwidth(9) cs(10), append
	asdoc tabstat nld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(occ_2) format(%9.0f) ///
	stubwidth(9) cs(10), append

	*just for the purpose of this table, simplify the variable names
	rename tot_contacts_school_wk_nld school_nld
	rename m_tot_contacts_work_wk_nld work_nld
	rename m_tot_contacts_home_wk_nld home_nld
	rename m_tot_contacts_trans_wk_nld trans_nld
	rename m_tot_contacts_ent_we_nld ent_nld

	asdoc tabstat home_nld, stat(mean p25 p50 p75 min max sd N) format(%9.0f) stubwidth(9) cs(10), append
	asdoc tabstat work_nld, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f) stubwidth(9) cs(10), append
	*only including school goers below
	asdoc tabstat school if occ_2==2, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f) stubwidth(9) cs(10), append
	asdoc tabstat trans_nld, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f) stubwidth(9) cs(10), append
	asdoc tabstat ent_nld, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f) stubwidth(9) cs(10), append
}

**************************************************************************************************
*create a dataset that focuses on the outliers between 100-720, and 200-720
**************************************************************************************************
use "stata_input/IVQ_R8_newVars.dta", clear

gen b60= .
replace b60=1 if inlist(ses_5,1,2,3)
replace b60=0 if inlist(ses_5,4,5)

la define b60 0 "t40" 1 "b60"
la values b60 b60


qui ds nld_all_ages_contacts_week ld_all_ages_contacts_week
foreach var in `r(varlist)' {
	gen o_50_`var' = 1  if `var' >50
	gen o_100_`var' = 1 if `var' >100
	gen o_200_`var' = 1 if `var' >200
}

foreach x in o_50 o_100 o_200 {
	preserve 
	keep if `x'_nld_all_ages_contacts_week ==1 
	save "stata_output/outliers_R8_`x'.dta", replace
	restore
}

**************************************************************************************************
************************Do analysis on outlier datasets
**************************************************************************************************

*just to check the creation worked 
foreach x in o_50 o_100 o_200 {
	use "stata_output/outliers_R8_`x'.dta", clear
	tabstat nld_all_ages_contacts_week ld_all_ages_contacts_week tot_contacts_*, stat(N) 		columns(s) varwidth(30)
	*all asdoc tables
	asdoc, text(Observations by subgroup in outlier sample `x') fs(11) cmd  save(tables/q1/outlier_sample_`x'.doc), replace
	asdoc tab gender, append
	asdoc tab ses_5, 	append
	asdoc tab age_5, 	append
	asdoc tab site_type, append
	asdoc tab occ_2, append
	asdoc nbreg nld_all_ages_contacts_week ib3.occ_2 i.gender i.age_5 i.site_type i.b60,  irr abb(.) save(tables/q2/		q2_nb_reg_wide_irr_`x') replace
}

*I think i need to make a table where I can compare the proportion of each subgroup in terms of number of observations and % of total


************************Create a dummy to indicate the outliers and do a logistic regression on the existence of the dummy 


use "stata_input/IVQ_R8_newVars.dta", clear


gen b60= .
replace b60=1 if inlist(ses_5,1,2,3)
replace b60=0 if inlist(ses_5,4,5)

la define b60 0 "t40" 1 "b60"
la values b60 b60

qui ds nld_all_ages_contacts_week ld_all_ages_contacts_week
foreach var in `r(varlist)' {
	gen o_50_`var' = 0  
	replace o_50_`var'=1 if `var' >50
	gen o_100_`var' = 0
	replace o_100_`var'=1 if `var' >100
	gen o_200_`var' = 0
	replace o_200_`var'=1 if `var' >200
}

* logistic regression on the dummy 

foreach x in o_50 o_100 o_200 {
asdoc logit `x'_nld_all_ages_contacts_week ib2.occ_2 i.gender i.age_5 i.site_type i.ses_5, save(tables/q1/logistic_outliers/`x'_logit_nld) replace

}


logit o_50_nld_all_ages_contacts_week ib4.occupations i.gender i.age_5 i.site_type i.ses_5

logit o_100_nld_all_ages_contacts_week ib4.occupations i.gender i.age_5 i.site_type i.ses_5

logit o_200_nld_all_ages_contacts_week ib2.occ_2 i.gender i.age_5 i.site_type i.ses_5
