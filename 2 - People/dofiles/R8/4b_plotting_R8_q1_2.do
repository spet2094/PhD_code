
clear all
cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/08_Fieldwork/08_Data/R8_data"

*Purpose: subset analyses on contacts

*********CONTACTS BY PLACE - SEPARATE DATASETS*****************

use "stata_output/ind_contacts_by_place.dta", clear
e
*add a drop over 50 
drop if tot_contacts_week_all_ages >50 //923 obs deleted
// if I did cut off at 30 it would cut us down by 2,141 obs 

graph hbox tot_contacts_week_all_ages if lockdown ==1 , over(place) title ("Contacts during the week - lockdown, by Place") 
graph export "plots/compare_places/contacts_by_place_ld.png", replace

graph hbox tot_contacts_week_all_ages if lockdown ==0 , over(place) title ("Contacts during the week - non-lockdown, by Place") 
graph export "plots/contacts_by_place_nld.png", replace

**compare lockdown non-lockdown for all places

la define ld 0 "non-lockdown" 1 "lockdown"
la values  lockdown ld
graph hbox tot_contacts_week_all_ages, over (lockdown) over(place)  title ("Contacts during the week - by Place") 
graph export "plots/compare_places/contacts_by_place_ld_vs_nld_over50cut.png", replace

**compare lockdown non-lockdown by gender

*figure out what to do with outliers
drop if tot_contacts_week_all_ages >50

la define gender 1 male 2 female 
la values gender gender
graph hbox tot_contacts_week_all_ages, over (lockdown) over(gender)  title ("Contacts during the week - by Gender") 
graph export "plots/contacts_by_gender_ld_vs_nld_cutover50.png", replace


**********JUST LOCKDOWN DATASET - to compare places*******

use "stata_output/ind_lockdown_contacts_by_place.dta", clear

*figure out what to do with outliers
drop if tot_contacts_wk_ld >50

forvalues i=1/5 {
  capture drop x`i' d`i'
  kdensity tot_contacts_wk_ld if place== `i', generate(x`i'  d`i')
  }

gen zero = 0

twoway rarea d1 zero x1, color("blue%50") ///
	||  rarea d2 zero x2, color("purple%50") ///
	||  rarea d3 zero x3, color("orange%50")  ///
	||  rarea d4 zero x4, color("red%50") ///
	||	rarea d5 zero x5, color("green%50") ///
		title("Area plot of contacts by place - lockdown wkdays") ///
		ytitle("Smoothed density") ///
		legend(ring(0) pos(2) col(1) order(1 "home" 2 "work" 3 "school" 4 "transport" 5 "ent"))     

	graph export plots/compare_places/area_plot_ld_contacts_by_place_cut50plus.png, width(1000) replace

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
		title("Area plot of contacts by place - non-lockdown wkdays") ///
		ytitle("Smoothed density") ///
		legend(ring(0) pos(2) col(1) order(1 "home" 2 "work" 3 "school" 4 "transport" 5 "ent"))     

	graph export plots/compare_places/area_plot_nld_contacts_by_place_cut100plus.png, width(500) replace

la define gender 1 male 2 female 
la values gender gender
graph hbox tot_contacts_wk_nld, over(gender)  title ("Contacts during the week - by Gender, NLD") 
graph export "plots/nld/contacts_by_gender_nld_cutover50.png", replace


graph hbox tot_contacts_wk_nld, over(age_cat)  title ("Contacts during the week - by age group, NLD") 
graph export "plots/nld/contacts_by_age_nld_cutover50.png", replace

graph hbox tot_contacts_wk_nld, over(ses_5)  title ("Contacts during the week - by ses group, NLD") 
graph export "plots/nld/contacts_by_ses_nld_cutover50.png", replace



