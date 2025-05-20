
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

*a plot for work

twoway (histogram ld_work_wk15_44, start(0) width(5) color(red%30)) ///        
       (histogram nld_work_wk15_44, start(0) width(5) color(green%30)), ///   
       legend(order(1 "work contacts 15-44 - ld" 2 "work contacts 15-44 - nld"  ))
	   
//graph export "plots/compare_occupations/work contacts 15-44.png", width(16000)  replace

*do the same but with an area plot on kdensity?

// twoway (histogram ld_work_wk15_44, start(0) width(5) color(red%30)) ///        
//        (histogram nld_work_wk15_44, start(0) width(5) color(green%30)), ///   
//        legend(order(1 "work contacts 15-44 - ld" 2 "work contacts 15-44 - nld"  ))
	   
// graph export "plots/compare_occupations/work contacts 15-44.png", width(16000)  replace

// *a plot for transport

// twoway (histogram ld_trans_wk15_44, start(0) width(5) color(red%30)) ///        
//        (histogram nld_trans_wk15_44, start(0) width(5) color(green%30)), ///   
//        legend(order(1 "transport 15-44 yrs - ld" 2 "transport 15-44yrs - nld"  ))
	   
// graph export "plots/transport contacts 15-44.png", width(16000)  replace

*a plot for 2 occupational categories 

twoway (histogram nld_work_wk15_44 if occupation==7, start(0) width(5) color(red%30)) ///        
       (histogram nld_work_wk15_44 if occupation==8, start(0) width(5) color(green%30)), ///   
       legend(order(1 "service workers 15-44 - nld"  2 "informal: petty trader 15-44 - nld"))
	   
//graph export "plots/compare_occupations/worker type contrast nld 15-44.png", width(16000)  replace

*combined histogram and kdensity plots for work vs. all contacts ld and nld (all ages)
//comment out the following replaces just for visualization of the graph below

** lockdown
replace ld_all_ages_contacts_week = . if ld_all_ages_contacts_week ==0
replace tot_contacts_work_wk_ld = . if tot_contacts_work_wk_ld ==0

twoway (histogram ld_all_ages_contacts_week, start(0) width(5) color(red%30)) ///        
       (histogram tot_contacts_work_wk_ld, start(0) width(5) color(green%30)), ///
	   legend(order(1 "total contacts all ages - ld" 2 "work contacts all ages - ld" )) || ///
	   (kdensity ld_all_ages_contacts_week, color(red)) ///
	   (kdensity tot_contacts_work_wk_ld, color(green)) ///       
	   
//graph export "plots/overview/compare_work_vs_tot_all_ages_ld.png", width(16000)  replace

replace nld_all_ages_contacts_week = . if nld_all_ages_contacts_week ==0
replace tot_contacts_work_wk_nld = . if tot_contacts_work_wk_nld ==0

** non-lockdown

twoway (histogram nld_all_ages_contacts_week, start(0) width(5) color(red%30)) ///        
       (histogram tot_contacts_work_wk_nld, start(0) width(5) color(green%30)), ///
	   legend(order(1 "total contacts all ages - nld" 2 "work contacts all ages - nld" )) || ///
	   (kdensity nld_all_ages_contacts_week, color(red)) ///
	   (kdensity tot_contacts_work_wk_nld, color(green)) ///       
	   
//graph export "plots/overview/compare_work_vs_tot_all_ages_nld.png", width(16000)  replace

//referred to https://www.statalist.org/forums/forum/general-stata-discussion/general/1417021-plotting-two-or-more-overlapping-density-curves-on-the-same-graph

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
graph export "plots/compare_occupations/boxplot_cbo_weekdays_all_ages.png", replace

*distribution of number of contacts of all ages by age of respondent shows that the average number of contacts by age is much lower 
graph hbox ld_all_ages_contacts_week, over(age_cat) title("Distribution of contacts of all ages by age of respondent - weekdays") 
graph export "plots/compare_ages/boxplot_age_respondent_wk_all_ages.png", replace

*now check the distribution of ages WITHIN occupations
graph hbox age, over(occupations) title("Distribution of ages of respondents by occupation") 
graph export "plots/compare_occupations/boxplot_age_by_occupation.png", replace


*compare occupations BEFORE lockdown  

*for ease of visualization, cut off at 100?
drop if tot_contacts_work_wk_nld >100

*do half at one time. 
local occ_codes 1 2 3 4 6 7 

foreach x of local occ_codes {
	sum tot_contacts_work_wk_nld if occupations== `x'
}

foreach i of local occ_codes {
  capture drop x`i' d`i'
  kdensity tot_contacts_work_wk_nld if occupations== `i', generate(x`i'  d`i')
  }

*gen zero = 0

twoway rarea d1 zero x1, color("blue%50") ///
	||  rarea d2 zero x2, color("purple%50") ///
	||  rarea d3 zero x3, color("orange%50")  ///
	||  rarea d4 zero x4, color("red%50") ///
	||	rarea d6 zero x6, color("green%50") ///
	||	rarea d7 zero x7, color("emerald%50") ///
		title("Area plot of contacts by occupation - non-lockdown wkdays") ///
		ytitle("Smoothed density") ///
		legend(ring(0) pos(2) col(1) order(1 "estates" 2 "manufacturing" 3 "police" 4 "teacher" 5 "doctor or nurse" 6 "services or retail shops"))     

graph export plots/compare_occupations/area_plot1_nld_contacts_by_occupation_cut100plus.png, width(800) replace

**second half

local occ_codes2  8 9 10 11 12 15


foreach x of local occ_codes2 {
	sum tot_contacts_work_wk_nld if occupations== `x'
}

foreach i of local occ_codes2 {
  capture drop x`i' d`i'
  kdensity tot_contacts_work_wk_nld if occupations== `i', generate(x`i'  d`i')
  }

twoway rarea d8 zero x8, color("forest_green%50") ///
	||	rarea d9 zero x9, color("gray%50") ///
	||	rarea d10 zero x10, color("orange%50") ///
	||	rarea d11 zero x11, color("purple%50") ///
	///||	rarea d12 zero x12, color("brown%50") ///
	||	rarea d15 zero x15, color("cyan%50") ///
		title("Area plot of contacts by occupation - non-lockdown wkdays") ///
		ytitle("Smoothed density") ///
		legend(ring(0) pos(2) col(1) order(1 "informal: petty trading" 2 "informal: subsistence ag" 3 "student" 4 "unemployed" 5 "office worker"))     
// removing other 
graph export plots/compare_occupations/area_plot2_nld_contacts_by_occupation_cut100plus.png, width(800) replace
	
	// do the same but with kdensity rather than rarea see if clearer - code below doesn't work yet 
	

// local occ_codes 1 2 3 4 6 7 8 9 10 11 12 15

// foreach x of local occ_codes {
// 	sum tot_contacts_work_wk_ld if occupations== `x'
// }

// foreach i of local occ_codes {
//   capture drop x`i' d`i'
//   kdensity tot_contacts_work_wk_ld if occupations== `i', generate(x`i'  d`i')
//   }

// twoway kdensity d1 zero x1, color("blue%50") ///
// 	||  kdensity d2 zero x2, color("purple%50") ///
// 	||  kdensity d3 zero x3, color("orange%50")  ///
// 	||  kdensity d4 zero x4, color("red%50") ///
// 	||	kdensity d6 zero x6, color("green%50") ///
// 	||	kdensity d7 zero x7, color("emerald%50") ///
// 	||	kdensity d8 zero x8, color("forest_green%50") ///
// 	||	kdensity d9 zero x9, color("gray%50") ///
// 	||	kdensity d10 zero x10, color("magenta%50") ///
// 	||	kdensity d11 zero x11, color("teal%50") ///
// 	||	kdensity d12 zero x12, color("brown%50") ///
// 	||	kdensity d15 zero x15, color("cyan%50") ///
// 		title("Area plot of contacts by occupation - lockdown wkdays") ///
// 		ytitle("Smoothed density") ///
// 		legend(ring(0) pos(2) col(1) order(1 "estates" 2 "manufacturing" 3 "police" 4 "teacher" 5 "doctor or nurse" 6 "services or retail shops" 7 "informal: petty trading" 8 "informal: subsistence ag" 9 "student" 10 "unemployed" 11 "other" 12 "office worker"))     

// graph export plots/compare_occupations/kdens_plot_ld_contacts_by_occupation_cut100plus.png, width(800) replace

**********************************************************************
*CONTACTS by OCCUPATION (CbO)* - a JOY DIVISION PLOT 
**********************************************************************

*the three packages below are required to run this code 
net install cleanplots, from("https://tdmize.github.io/data/cleanplots")
net install palettes, replace from("https://raw.githubusercontent.com/benjann/palettes/master/")
net install colrspace, replace from("https://raw.githubusercontent.com/benjann/colrspace/master/")


set scheme cleanplots


levelsof occupation, local(levels)
foreach x of local levels {
    summ tot_contacts_work_wk_nld if occupation==`x'
   
}

egen tag = tag(occupation tot_contacts_work_wk_nld)
summ tot_contacts_work_wk_nld
gen xpoint = `r(min)' if tag==1

gen ypoint=.
levelsof occupation, local(levels)
local items = `r(r)' + 6
foreach x of local levels {
    summ occupation
    local newx = `r(max)' + 1 - `x'   // reverse the sorting
    lowess tot_contacts_work_wk_nld if occupation==`newx', bwid(0.05) gen(y`newx') nograph

    gen ybot`newx' =  `newx'/ 2.8     // squish the axis
    gen ytop`newx' = y`newx' + ybot`newx'
    colorpalette matplotlib autumn, n(`items') nograph
    local mygraph `mygraph' rarea  ytop`newx' ybot`newx' date  , fc("`r(p`newx')'%75")  lc(white)  lw(thin) || 

    replace ypoint = (ytop`newx' + 1/8) if xpoint!=. & occupation==`newx' 
}
