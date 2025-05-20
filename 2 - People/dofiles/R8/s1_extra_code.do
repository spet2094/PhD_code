

**********************************************************************
***************************************************
* a version of contacts by PLACE (with exclusions) (all m_* variables)
***************************************************



use "stata_input/IVQ_R8_newVars_200cutoff.dta", clear
format hhmem_key %13.0f 

* nonlockdown

replace m_nld_all_ages_contacts_week = . if nld_all_ages_contacts_week >720

qui ds m_tot_contacts_*
foreach var in `r(varlist)' {
	replace `var' = . if `var' >720
}

// foreach x in school home work trans ent {
// 	replace tot_contacts_`x'_nld = . if tot_contacts_`x'_nld >720
// }	
sum tot_contacts_*

asdoc, text(Average no. of contacts by place on weekdays - non-lockdown. Excluding those who did not visit) fs(16) cmd  save(tables/q1/by_place_av_contacts_nld.doc), replace 
asdoc tabstat m_nld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f), append
asdoc tabstat m_nld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(gender) format(%9.0f), append
asdoc tabstat m_nld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(ses_5) format(%9.0f), append
asdoc tabstat m_nld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(age_5) format(%9.0f), append
asdoc tabstat m_nld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(site_type) format(%9.0f) stubwidth(9) cs(10), append
asdoc tabstat m_nld_all_ages_contacts_week, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] by(occ_2) format(%9.0f) stubwidth(9) cs(10), append


*just for the purpose of this table, simplify the variable names
rename tot_contacts_school_wk_nld school_nld
rename m_tot_contacts_work_wk_nld m_work_nld
rename m_tot_contacts_home_wk_nld m_home_nld
rename m_tot_contacts_trans_wk_nld m_trans_nld
rename m_tot_contacts_ent_we_nld m_ent_nld

asdoc tabstat m_home_nld, stat(mean p25 p50 p75 min max sd N) format(%9.0f) stubwidth(9) cs(10), append
asdoc tabstat m_work_nld if occupations!=10 & occupations !=11, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f) stubwidth(9) cs(10), append
// excluding unemployed and school goers
asdoc tabstat school_nld if occ_2==2, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f) stubwidth(9) cs(10), append
asdoc tabstat m_trans_nld, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f) stubwidth(9) cs(10), append
asdoc tabstat m_ent_nld, stat(mean p25 p50 p75 min max sd N) [fw=wgt_inv] format(%9.0f) stubwidth(9) cs(10), append


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
rename tot_contacts_school_wk_ld school_ld
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

