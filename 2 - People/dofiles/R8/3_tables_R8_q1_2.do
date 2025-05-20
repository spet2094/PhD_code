
clear all
cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/08_Fieldwork/08_Data/R8_data"

*Purpose: answer Q1 and Q2 of data analysis on social contacts 

use "IVQ_R8_newVars.dta", clear


**** Check occupations by site


* check the distribution of occupations for each of the sites they suggested 

**Selbourne - forestry estate - 5
tab occupations if site == 5
// can get estates, manufacturing, teachers, nurses, service, informal, students, unemployed, other, office (only 5)

*Sakubva - unknown - 14
tab occupations if site == 14
// higher proportion of informal petty traders, lower in estates

*Hobhouse - unknown - 15
tab occupations if site == 15
// few more army, similar to Sakubva, more petty traders

*Watsomba - roadside trading settlement - 9
tab occupations if site == 9
// higher in informal, subsistence ag. Still low office workers 

**** we are missing Nyazura -7 and Nyanga -8 which are commercial centres 
tab occupations if site == 7 // even more unemployed, not that many office workers
tab occupations if site == 8 // even more unemployed, slightly more office workers than in all other cats (26)


// Their recommendation: Selbourne and Hobhouse 

*Lockdown contacts cleaning contact variables 

local ld_work_week ld_work_wku15 ld_work_wk15_44 ld_work_wk45_64 ld_work_wk65plus
local ld_work_we ld_work_weu15 ld_work_we15_44 ld_work_we45_64 ld_work_we65plus

local ld_school_week ld_school_wku15 ld_school_wk15_44 ld_school_wk45_64 ld_school_wk65plus
local ld_school_we ld_school_weu15 ld_school_we15_44 ld_school_we45_64 ld_school_we65plus

local ld_trans_week ld_trans_wku15 ld_trans_wk15_44 ld_trans_wk45_64 ld_trans_wk65plus
local ld_trans_we ld_trans_weu15 ld_trans_we15_44 ld_trans_we45_64 ld_trans_we65plus

local ld_ent_week ld_ent_wku15 ld_ent_wk15_44 ld_ent_wk45_64 ld_ent_wk65plus
local ld_ent_we ld_ent_weu15 ld_ent_we15_44 ld_ent_we45_64 ld_ent_we65plus

local ld_other_week ld_other_wku15 ld_other_wk15_44 ld_other_wk45_64 ld_other_wk65plus
local ld_other_we ld_other_weu15 ld_other_we15_44 ld_other_we45_64 ld_other_we65plus

local ld_home_week ld_home_wku15 ld_home_wk15_44 ld_home_wk45_64 ld_home_wk65plus
local ld_home_we ld_home_weu15 ld_home_we15_44 ld_home_we45_64 ld_home_we65plus

local ld_contact_vars ld_work_wku15 ld_work_wk15_44 ld_work_wk45_64 ld_work_wk65plus ld_work_weu15 ld_work_we15_44 ld_work_we45_64 ld_work_we65plus ld_school_wku15 ld_school_wk15_44 ld_school_wk45_64 ld_school_wk65plus ld_school_weu15 ld_school_we15_44 ld_school_we45_64 ld_school_we65plus ld_trans_wku15 ld_trans_wk15_44 ld_trans_wk45_64 ld_trans_wk65plus ld_trans_weu15 ld_trans_we15_44 ld_trans_we45_64 ld_trans_we65plus ld_home_wku15 ld_home_wk15_44 ld_home_wk45_64 ld_home_wk65plus ld_home_weu15 ld_home_we15_44 ld_home_we45_64 ld_home_we65plus ld_ent_wku15 ld_ent_wk15_44 ld_ent_wk45_64 ld_ent_wk65plus ld_ent_weu15 ld_ent_we15_44 ld_ent_we45_64 ld_ent_we65plus ld_other_wku15 ld_other_wk15_44 ld_other_wk45_64 ld_other_wk65plus ld_other_weu15 ld_other_we15_44 ld_other_we45_64 ld_other_we65plus

*let's make a local of the summary variables 
local summary_vars_ld ld_all_ages_contacts_week ld_all_ages_contacts_we ld_all_ages_contacts_7days nld_all_ages_contacts_week nld_all_ages_contacts_we nld_all_ages_contacts_7days

local nld_work_week nld_work_wku15 nld_work_wk15_44 nld_work_wk45_64 nld_work_wk65plus
local nld_work_we nld_work_weu15 nld_work_we15_44 nld_work_we45_64 nld_work_we65plus
local nld_school_week nld_school_wku15 nld_school_wk15_44 nld_school_wk45_64 nld_school_wk65plus
local nld_school_we nld_school_weu15 nld_school_we15_44 nld_school_we45_64 nld_school_we65plus

local nld_trans_week nld_trans_wku15 nld_trans_wk15_44 nld_trans_wk45_64 nld_trans_wk65plus

local nld_trans_we nld_trans_weu15 nld_trans_we15_44 nld_trans_we45_64 nld_trans_we65plus

local nld_home_week nld_home_wku15 nld_home_wk15_44 nld_home_wk45_64 nld_home_wk65plus
local nld_home_we nld_home_weu15 nld_home_we15_44 nld_home_we45_64 nld_home_we65plus

local nld_ent_week nld_ent_wku15 nld_ent_wk15_44 nld_ent_wk45_64 nld_ent_wk65plus
local nld_ent_we nld_ent_weu15 nld_ent_we15_44 nld_ent_we45_64 nld_ent_we65plus

local nld_other_week nld_other_wku15 nld_other_wk15_44 nld_other_wk45_64 nld_other_wk65plus
local nld_other_we nld_other_weu15 nld_other_we15_44 nld_other_we45_64 nld_other_we65plus

local nld_contact_vars nld_work_wku15 nld_work_wk15_44 nld_work_wk45_64 nld_work_wk65plus nld_work_weu15 nld_work_we15_44 nld_work_we45_64 nld_work_we65plus nld_school_wku15 nld_school_wk15_44 nld_school_wk45_64 nld_school_wk65plus nld_school_weu15 nld_school_we15_44 nld_school_we45_64 nld_school_we65plus nld_trans_wku15 nld_trans_wk15_44 nld_trans_wk45_64 nld_trans_wk65plus nld_trans_weu15 nld_trans_we15_44 nld_trans_we45_64 nld_trans_we65plus nld_home_wku15 nld_home_wk15_44 nld_home_wk45_64 nld_home_wk65plus nld_home_weu15 nld_home_we15_44 nld_home_we45_64 nld_home_we65plus nld_ent_wku15 nld_ent_wk15_44 nld_ent_wk45_64 nld_ent_wk65plus nld_ent_weu15 nld_ent_we15_44 nld_ent_we45_64 nld_ent_we65plus nld_other_wku15 nld_other_wk15_44 nld_other_wk45_64 nld_other_wk65plus nld_other_weu15 nld_other_we15_44 nld_other_we45_64 nld_other_we65plus


*locals for age categories 
local u15_contacts_wk_ld ld_work_wku15 ld_school_wku15 ld_trans_wku15 ld_home_wku15 ld_ent_wku15 ld_other_wku15

local u15_contacts_wk_nld nld_work_wku15 nld_school_wku15 nld_trans_wku15 nld_home_wku15 nld_ent_wku15 nld_other_wku15

local a15_44_contacts_wk_ld  ld_work_wk15_44 ld_school_wk15_44 ld_trans_wk15_44 ld_home_wk15_44 ld_ent_wk15_44 ld_other_wk15_44

local a15_44_contacts_wk_nld  nld_work_wk15_44 nld_school_wk15_44 nld_trans_wk15_44 nld_home_wk15_44 nld_ent_wk15_44 nld_other_wk15_44

local a45_64_contacts_wk_ld ld_work_wk45_64 ld_school_wk45_64 ld_trans_wk45_64 ld_home_wk45_64 ld_ent_wk45_64 ld_other_wk45_64

local a45_64_contacts_wk_nld nld_work_wk45_64 nld_school_wk45_64 nld_trans_wk45_64 nld_home_wk45_64 nld_ent_wk45_64 nld_other_wk45_64

local a65_plus_contacts_wk_ld ld_work_wk65plus ld_school_wk65plus ld_trans_wk65plus ld_home_wk65plus ld_ent_wk65plus ld_other_wk65plus

local a65_plus_contacts_wk_nld nld_work_wk65plus nld_school_wk65plus nld_trans_wk65plus nld_home_wk65plus nld_ent_wk65plus nld_other_wk65plus

**week all ages of contacts by place 

local ld_all_ages_wk tot_contacts_work_wk_ld tot_contacts_school_wk_ld tot_contacts_home_wk_ld tot_contacts_trans_wk_ld tot_contacts_ent_wk_ld ld_all_ages_contacts_week

local nld_all_ages_wk tot_contacts_work_wk_nld tot_contacts_school_wk_nld tot_contacts_home_wk_nld tot_contacts_trans_wk_nld tot_contacts_ent_wk_nld nld_all_ages_contacts_week


local contacts_av_by_occ ld_av_cbo_overall nld_av_cbo_overall ld_av_cbo_wk nld_av_cbo_wk ld_av_cbo_we nld_av_cbo_we ld_av_cbo_work_wk nld_av_cbo_work_wk ld_av_cbo_sch_wk nld_av_cbo_sch_wk ld_av_cbo_home_wk nld_av_cbo_home_wk ld_av_cbo_trans_wk nld_av_cbo_trans_wk  ld_av_cbo_ent_wk nld_av_cbo_ent_wk

local contacts_med_by_occ ld_med_cbo_overall nld_med_cbo_overall ld_med_cbo_wk nld_med_cbo_wk ld_med_cbo_we nld_med_cbo_we ld_med_cbo_work_wk nld_med_cbo_work_wk ld_med_cbo_sch_wk nld_med_cbo_sch_wk ld_med_cbo_home_wk nld_med_cbo_home_wk ld_med_cbo_trans_wk nld_med_cbo_trans_wk ld_med_cbo_ent_wk nld_med_cbo_ent_wk


** weekend all ages of contacts by place

local ld_all_ages_we tot_contacts_work_we_ld tot_contacts_school_we_ld tot_contacts_home_we_ld tot_contacts_trans_we_ld tot_contacts_ent_we_ld ld_all_ages_contacts_we

local nld_all_ages_we tot_contacts_work_we_nld tot_contacts_school_we_nld tot_contacts_home_we_nld tot_contacts_trans_we_nld tot_contacts_ent_we_nld nld_all_ages_contacts_we

*local of relevant vars (mixed from week and weekend for ent)
local all_ages_mix tot_contacts_work_wk_ld tot_contacts_work_wk_nld tot_contacts_school_wk_ld tot_contacts_school_wk_nld tot_contacts_home_wk_ld  tot_contacts_home_wk_nld tot_contacts_trans_wk_ld tot_contacts_trans_wk_nld tot_contacts_ent_we_ld tot_contacts_ent_we_nld

*home distributions -- later will want to check this against the census for % of people who live alone 
foreach x in ld_home_wku15 ld_home_wk15_44 ld_home_wk45_64 ld_home_wk65plus ld_home_weu15 ld_home_we15_44 ld_home_we45_64 ld_home_we65plus  {
	tab `x'
	
}



****************************************************************************************************************************

***ALL TABLES  

**************************************************************


*overview of contacts across all areas - work, school, home, ent, trans and other

sum tot_contacts_work_wk_nld // across all occupational categories the mean is 8.6

estpost sum `ld_contact_vars'
esttab using "stata_output/ld_contacts_allplaces_excl_over50.csv", cells("count(fmt(2)) mean(fmt(2)) median(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))")nomtitle nonumber replace 
esttab using "stata_output/ld_contacts_allplaces_excl_over50.txt", cells("count(fmt(2)) mean(fmt(2)) median(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))")nomtitle nonumber replace 

estpost sum `ld_all_ages_wk'
esttab using "stata_output/ld_contacts_all_ages_wk_excl_over50.csv", cells("count(fmt(2)) mean(fmt(2)) median(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))")nomtitle nonumber replace 
esttab using "stata_output/ld_contacts_all_ages_wk_excl_over50.txt", cells("count(fmt(2)) mean(fmt(2)) median(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))")nomtitle nonumber replace 

estpost sum `nld_all_ages_wk'
esttab using "stata_output/nld_contacts_all_ages_wk_excl_over50.csv", cells("count(fmt(2)) mean(fmt(2)) median(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))")nomtitle nonumber replace 
esttab using "stata_output/nld_contacts_all_ages_wk_excl_over50.txt", cells("count(fmt(2)) mean(fmt(2)) median(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))")nomtitle nonumber replace 

estpost sum `all_ages_mix'
esttab using "stata_output/all_ages_mix_excl_over50.csv", cells("count(fmt(2)) mean(fmt(2)) median(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))")nomtitle nonumber replace 

esttab using "stata_output/all_ages_mix_excl_over50.txt", cells("count(fmt(2)) mean(fmt(2)) median(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))")nomtitle nonumber replace 


*overview of contacts across all areas - work, school, home, ent, trans and other

estpost sum `nld_contact_vars'
esttab using "stata_output/nld_contacts_allplaces_excl_over50.csv", cells("count(fmt(2)) mean(fmt(2)) median(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))")nomtitle nonumber replace 
esttab using "stata_output/nld_contacts_allplaces_excl_over50.txt", cells("count(fmt(2)) mean(fmt(2)) median(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))")nomtitle nonumber replace 


estpost sum `ld_all_ages_wk'
esttab using "stata_output/ld_contacts_all_ages_wk_excl_over50.csv", cells("count(fmt(2)) mean(fmt(2)) median(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))")nomtitle nonumber replace 
esttab using "stata_output/ld_contacts_all_ages_wk_excl_over50.txt", cells("count(fmt(2)) mean(fmt(2)) median(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))")nomtitle nonumber replace 

estpost sum `nld_all_ages_wk'
esttab using "stata_output/nld_contacts_all_ages_wk_excl_over50.csv", cells("count(fmt(2)) mean(fmt(2)) median(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))")nomtitle nonumber replace 
esttab using "stata_output/nld_contacts_all_ages_wk_excl_over50.txt", cells("count(fmt(2)) mean(fmt(2)) median(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))")nomtitle nonumber replace 

estpost sum `all_ages_mix'
esttab using "stata_output/all_ages_mix_excl_over50.csv", cells("count(fmt(2)) mean(fmt(2)) median(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))")nomtitle nonumber replace 

esttab using "stata_output/all_ages_mix_excl_over50.txt", cells("count(fmt(2)) mean(fmt(2)) median(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))")nomtitle nonumber replace 

* averages by age group of contacts 

local contacts_by_age_group ld_all_u15_contacts_wk nld_all_u15_contacts_wk ld_all_15_44_contacts_wk nld_all_15_44_contacts_wk ld_all_45_64_contacts_wk nld_all_45_64_contacts_wk ld_all_65_plus_contacts_wk nld_all_65_plus_contacts_wk

estpost sum `contacts_by_age_group'
esttab using "stata_output/contacts_by_age_group_50cutoff.csv", cells("count(fmt(2)) mean(fmt(2)) median(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))")nomtitle nonumber replace 

esttab using "stata_output/contacts_by_age_group_50cutoff.txt", cells("count(fmt(2)) mean(fmt(2)) median(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))")nomtitle nonumber replace 


*overview of total contacts (all ages) across all areas - work, school, home, ent, trans and other


* 2 suggestions: 1. look at total number of obs by analysis 2. look at box plot of contacts by place 

*create separate datasets for home, school, work, community


local occ_codes 1 2 3 4 6 7 8 9 10 11 12 15
foreach x of local occ_codes {
	sum tot_contacts_work_wk_nld if occupations == `x'
}

// within occupations it differs a lot more 
// as high as 25 in 4 and low as 1.14 in another (check graphs and table to see if it matches )
