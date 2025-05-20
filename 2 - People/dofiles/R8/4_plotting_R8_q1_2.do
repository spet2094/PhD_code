
clear all

cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/08_Fieldwork/08_Data/R8_data/"
*Purpose: answer Q1 and Q2 of data analysis on social contacts 

use "stata_input/IVQ_R8_newVars.dta", clear


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



*overview of total contacts (all ages) across all areas - work, school, home, ent, trans and other


* 2 suggestions: 1. look at total number of obs by analysis 2. look at box plot of contacts by place 


****************************************************************************************************
* INDIVIDUAL PLACES*
											
								// run either this or the block below. Can't do both at the same time
****************************************************************************************************



// *… Typical weekday at work (A/B/C/D refer to ages <15, 15-44, 45-64, 65+)
// foreach x in `nld_work_week' {
// 	hist `x', name ("`x'") title ("`: variable label `x''") xtitle ("No. of contacts")
// }

// graph combine `nld_work_week', //,
// graph export "plots/combined_nld_work_contacts_by_age_excl100_wk_noz.png", width(16000) replace

// *typical day at school weekday
// foreach x in `nld_school_week' {
// 	hist `x', name ("`x'") title ("`: variable label `x''") xtitle ("No. of contacts")
// }

// graph combine `nld_school_week', //,
// graph export "plots/combined_nld_school_contacts_by_age_excl100_noz.png", width(16000) replace

// *a plot for school

// twoway (histogram ld_school_wk15_44, start(0) width(5) color(red%30)) ///        
//        (histogram nld_school_wk15_44, start(0) width(5) color(green%30)), ///   
//        legend(order(1 "school contacts +15yrs - ld" 2 "school contacts +15yrs - nld"  ))
	   
// graph export "plots/school contacts +15yrs.png", width(16000)  replace

// *a plot for entertainment 

// twoway (histogram ld_ent_we15_44, start(0) width(5) color(red%30)) ///        
//        (histogram nld_ent_we15_44, start(0) width(5) color(green%30)), ///   
//        legend(order(1 "ent contacts 15-44 - ld" 2 "ent contacts 15-44 - nld"  ))
	   
// graph export "plots/entertainment contacts 15-44.png", width(16000)  replace

// *a plot for work

// twoway (histogram ld_work_wk15_44, start(0) width(5) color(red%30)) ///        
//        (histogram nld_work_wk15_44, start(0) width(5) color(green%30)), ///   
//        legend(order(1 "work contacts 15-44 - ld" 2 "work contacts 15-44 - nld"  ))
	   
// graph export "plots/work contacts 15-44.png", width(16000)  replace

// *a plot for transport

// twoway (histogram ld_trans_wk15_44, start(0) width(5) color(red%30)) ///        
//        (histogram nld_trans_wk15_44, start(0) width(5) color(green%30)), ///   
//        legend(order(1 "transport 15-44 yrs - ld" 2 "transport 15-44yrs - nld"  ))
	   
// graph export "plots/transport contacts 15-44.png", width(16000)  replace

// *a plot for 2 occupational categories 

// twoway (histogram nld_work_wk15_44 if occupation==7, start(0) width(5) color(red%30)) ///        
//        (histogram nld_work_wk15_44 if occupation==8, start(0) width(5) color(green%30)), ///   
//        legend(order(1 "service workers 15-44 - nld" 2 "subs agri 15-44 - nld"  ))
	   
// graph export "plots/worker type contrast nld 15-44.png", width(16000)  replace

// *a plot for home

// twoway (histogram ld_home_wk15_44 if occupation==7, start(0) width(5) color(red%30)) ///        
//        (histogram nld_work_wk15_44 if occupation==8, start(0) width(5) color(green%30)), ///   
//        legend(order(1 "service workers 15-44 - nld" 2 "subs agri 15-44 - nld"  ))
	   
// graph export "plots/worker type contrast nld 15-44.png", width(16000)  replace



// *typical day on transport weekday
// foreach x in `nld_trans_week' {
// 	hist `x', name ("`x'") title ("`: variable label `x''") xtitle ("No. of contacts")
// }

// graph combine `ld_trans_week', //,
// graph export "plots/combined_nld_transport_contacts_by_age_excl100_noz.png", width(16000) replace
 

// *typical day at entertainment weekend
// foreach x in `nld_ent_we' {
// 	hist `x', name ("`x'") title ("`: variable label `x''") xtitle ("No. of contacts")
// }

// graph combine `nld_ent_we', //,
// graph export "plots/combined_nld_ent_contacts_by_age_excl100_we_noz.png", width(16000) replace


// *typical day at home weekday
// foreach x in `nld_home_week' {
// 	hist `x', name ("`x'") title ("`: variable label `x''") xtitle ("No. of contacts")
// }

// graph combine `nld_home_week', //,
// graph export "plots/combined_nld_home_contacts_by_age_excl100_wk_noz.png", width(16000) replace


*********************************
** ALL GRAPHS 

* INDIVIDUAL PLACES*
// run either this or the block below. Can't do both at th same time
****************************************************************************************************



// *… Typical weekday at work (A/B/C/D refer to ages <15, 15-44, 45-64, 65+)
// foreach x in `ld_work_week' {
// 	hist `x', name ("`x'") title ("`: variable label `x''") xtitle ("No. of contacts")
// }

// graph combine `ld_work_week', //,
// graph export "plots/combined_ld_work_contacts_by_age_excl100_wk_noz.png", width(16000) replace

// *typical day at school weekday
// foreach x in `ld_school_week' {
// 	hist `x', name ("`x'") title ("`: variable label `x''") xtitle ("No. of contacts")
// }

// graph combine `ld_school_week', //,
// graph export "plots/combined_ld_school_contacts_by_age_excl100_noz.png", width(16000) replace


// *typical day on transport weekday
// foreach x in `ld_trans_week' {
// 	hist `x', name ("`x'") title ("`: variable label `x''") xtitle ("No. of contacts")
// }

// graph combine `ld_trans_week', //,
// graph export "plots/combined_ld_transport_contacts_by_age_excl100_noz.png", width(16000) replace
 

// *typical day at entertainment weekend
// foreach x in `ld_ent_we' {
// 	hist `x', name ("`x'") title ("`: variable label `x''") xtitle ("No. of contacts")
// }

// graph combine `ld_ent_we', //,
// graph export "plots/combined_ld_ent_contacts_by_age_excl100_we_noz.png", width(16000) replace


// *typical day at home weekday
// foreach x in `ld_home_week' {
// 	hist `x', name ("`x'") title ("`: variable label `x''") xtitle ("No. of contacts")
// }

// graph combine `ld_home_week', //,
// graph export "plots/combined_ld_home_contacts_by_age_excl100_wk_noz.png", width(16000) replace


// foreach x in `ld_contact_vars' {
// 	hist `x', name ("`x'") title ("`: variable label `x''") xtitle ("No. of contacts")
// }

// graph combine `ld_contact_vars' // title ("Histograms of Work Contacts during Lockdown"), size(medium)
// graph export "plots/combined_all_ld_contacts_excl_over100.png", width(16000) replace


******************************************
********************LARGE GRAPHS OF ALL CONTACTS**********************


// *for the combined graph titles are being tricky but this is just to get an overview 

// foreach x in `nld_contact_vars' {
// 	hist `x', name ("`x'") title ("`: variable label `x''") xtitle ("No. of contacts")
// }

// graph combine `nld_contact_vars', // title ("Histograms of Work Contacts during Lockdown"), size(medium)
// graph export "plots/combined_all_nld_contacts_excl_over100.png", width(16000)  replace

****************************************************************************************************
* CONTACTS BY ALL AGES PER INDIVIDUAL*

**********************************************************************


*overview of total contacts (all ages) across all areas - work, school, home, ent, trans and other



******************************************************************************
*CONTACTS by OCCUPATION (CbO)*
******************************************************************************


***** we want to start looking at number of contacts by occupation \

// Q2: Who has more/less social contacts (overall and by contact type/setting)? - stratified by sex and HIV status - associations with site type, age, education, employment/occupation, SES, religion, and marital status



**some visuals to compare the occupational category distributions

*boxplot of number of contacts across all ages by occupation 

graph hbox ld_all_ages_contacts_week, over(occupations) title("Distribution of contacts of all ages by occupation - weekdays") 
graph export "plots/boxplot_cbo_weekdays_all_ages.png", replace

*distribution of number of contacts of all ages by age of respondent shows that the average number of contacts by age is much lower 
graph hbox ld_all_ages_contacts_week, over(age_5) title("Distribution of contacts of all ages by age of respondent - weekdays") 
graph export "plots/boxplot_age_respondent_wk_all_ages.png", replace

*now check the distribution of ages WITHIN occupations
graph hbox age, over(occupations) title("Distribution of ages of respondents by occupation") 
graph export "plots/boxplot_age_by_occupation.png", replace


******************CONTACTS BY PLACE - SEPARATE DATASETS*****************

use "stata_input/ind_lockdown_contacts_by_place", clear

graph hbox contacts_in_place_ld, over(place_ld_stat) title ("Contacts during the week - lockdown, by Place") 
graph export "plots/contacts_by_place_ld.png", replace

use "stata_input/ind_nld_contacts_by_place", clear
graph hbox contacts_in_place_nld, over(place_ld_stat) title ("Contacts during the week - non-lockdown, by Place") 
graph export "plots/contacts_by_place_nld.png", replace

**compare lockdown non-lockdown for all places (ended up doing this in python)
// use "stata_input/ind_contacts_by_place.dta", replace
// la define ld 0 "non-lockdown" 1 "lockdown"
// la values  lockdown ld
// graph hbox tot_contacts_week_all_ages, over (lockdown) over(place)  title ("Contacts during the week - by Place") 
// graph export "plots/contacts_by_place_ld_vs_nld.png", replace
//
// **for each place /// to do 
// forvalues i=1/2 {
//   capture drop x`i' d`i'
//   kdensity tot_contacts_wk_ld if place== `i', generate(x`i'  d`i')
//   }
//
// gen zero = 0
//
// twoway rarea d1 zero x1, color("blue%50") ///
// 	||  rarea d2 zero x2, color("red%50") ///
// 		title("Area plot of contacts in ") ///
// 		ytitle("Smoothed density") ///
// 		legend(ring(0) pos(2) col(1) order(1 "home" 2 "work" 3 "school" 4 		"transport" 5 "ent"))     
//
// 	graph export plots/lockdowns/area_plot_ld_contacts_by_place_cut50plus.png, width(500) replace

**generate overlay distributions per place 

// graph hbox tot_contacts_week_all_ages, over(place) over (lockdown)
//  title("Contacts by Place on Weekdays - Lockdown vs. Non-lockdown")

************************JUST LOCKDOWN DATASET - to compare places*******

use "stata_input/ind_lockdown_contacts_by_place.dta", clear

*figure out what to do with outliers
drop if tot_contacts_wk_ld >50

forvalues i=1/5 {
  capture drop x`i' d`i'
  kdensity tot_contacts_wk_ld if place_ld_stat== `i', generate(x`i'  d`i')
  }

gen zero = 0

twoway rarea d1 zero x1, color("blue%50") ///
	||  rarea d2 zero x2, color("purple%50") ///
	||  rarea d3 zero x3, color("orange%50")  ///
	||  rarea d4 zero x4, color("red%50") ///
	||	rarea d5 zero x5, color("green%50") ///
		title("Area plot of contacts by place - lockdown wkdays") ///
		ytitle("Smoothed density") ///
		legend(ring(0) pos(2) col(1) order(1 "home" 2 "work" 3 "school" 4 		"transport" 5 "ent"))     

	graph export plots/lockdowns/area_plot_ld_contacts_by_place_cut50plus.png, width(500) replace

************************JUST NON-LOCKDOWN DATASET - to compare places*******

use "stata_output/ind_nld_contacts_by_place.dta", clear

*figure out what to do with outliers
drop if tot_contacts_wk_nld >50

forvalues i=6/10 {
  capture drop x`i' d`i'
  kdensity tot_contacts_wk_nld if place== `i', generate(x`i'  d`i')
  }

gen zero = 0

twoway rarea d6 zero x6, color("blue%50") ///
	||  rarea d7 zero x7, color("purple%50") ///
	||  rarea d8 zero x8, color("orange%50")  ///
	||  rarea d9 zero x9, color("red%50") ///
	||	rarea d10 zero x10, color("green%50") ///
		title("Area plot of contacts by place - lockdown wkdays") ///
		ytitle("Smoothed density") ///
		legend(ring(0) pos(2) col(1) order(1 "home" 2 "work" 3 "school" 4 		"transport" 5 "ent"))     

	graph export plots/nld/area_plot_nld_contacts_by_place_cut50.png, width(500) replace


