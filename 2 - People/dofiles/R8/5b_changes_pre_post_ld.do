clear all
cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/08_Fieldwork/08_Data/R8_data/"
tempfile temp1


// 2. What variables are most strongly correlated with the number of contacts people had pre-lockdown? 

* using only nonlockdown dataset running negative binomial to get baseline number of contacts AND correlates on those 

// 4. What variables are most strongly correlated with changes in contacts between pre and post lockdown?

* using the CHANGE dataset to look at linear regression + margins of change (for all the variables)

//coeff plot , margins plot  

******adapt below 


*3. How big was the drop in reported contacts pre-post lockdown? 


use "stata_output/ind_contacts_by_place.dta", clear
label dir
numlabel `r(names)', add
format hhmem_key %13.0g

tab place
*average from all places
sum tot_contacts_week_all_ages if lockdown == 1, d
//
sum tot_contacts_week_all_ages if lockdown == 0, d

*average by place

foreach x in 1 2 3 4 5 {
sum tot_contacts_week_all_ages if lockdown == 1 & place ==`x',d

}
//
foreach x in 1 2 3 4 5 {
sum tot_contacts_week_all_ages if lockdown == 0 & place ==`x', d

}

*averages by occupation
tab occupations
foreach x in 1 2 3 4 6 7 8 9 10 11 12 15 16 17 18 {
sum tot_contacts_week_all_ages if lockdown == 1 & occupation ==`x', d

}
//
foreach x in 1 2 3 4 6 7 8 9 10 11 12 15 16 17 18 {
sum tot_contacts_week_all_ages if lockdown == 0 & occupation ==`x'

}


*average by age 

tab age_cat
foreach x in 2 3 4 {
sum tot_contacts_week_all_ages if lockdown == 1 & age_cat ==`x'

}


tab age_cat
foreach x in 2 3 4 {
sum tot_contacts_week_all_ages if lockdown == 0 & age_cat ==`x'

}

*average by gender
tab gender
foreach x in 1 2 {
sum tot_contacts_week_all_ages if lockdown == 0 & gender ==`x'

}


*by ses
tab ses_5
foreach x in 1 2 3 4 5 {
sum tot_contacts_week occ_2 if lockdown == 0 & ses_5 ==`x'

}


**********REGRESSIONS

*Did the change in contacts between LD/nLD differ more significantly by population characteristics
// e.g. was age significant in the reduction in contacts
** using just the difference variable, and keeping only one set of values per place 
//https://www.youtube.com/watch?v=H95BHswbT3w but then I need to collapse the dataset to just the average values over places

keep if inlist(place_ld_stat,1,2,3,4,5)

rename tot_contacts_week_all_ages tot_contacts_week_ld
gen tot_contacts_week_nld = tot_contacts_week_ld - diff_contacts_ld

drop place_ld_stat lockdown tot_contacts_all_places

order hhmem_key gender age age_cat occupations occ_2 site ses ses_5 age_5  tot_contacts_week_nld tot_contacts_week_ld diff_contacts_ld place

collapse (first) tot_contacts_week* age_5 ses_5 gender occ_2 site diff_contacts_ld, by (hhmem_key  place )

tabstat diff_contacts_ld, stat(min max p25 p50 p75 mean sd ) by (occ_2)
tabstat diff_contacts_ld, stat(min max p25 p50 p75 mean sd ) by (place)



la values age_5 age_5
la values occ_2 oc2 

label values place place 

sort hhmem_key place

*calculate totals per individual 
by hhmem_key, sort: egen contacts_all_places_nld = total(tot_contacts_week_nld)
by hhmem_key, sort: egen contacts_all_places_ld = total(tot_contacts_week_ld)
gen diff_all_places = contacts_all_places_ld - contacts_all_places_nld

keep if place ==1
drop place 
drop tot_contacts_week_nld tot_contacts_week_ld
drop diff_contacts_ld 

reg diff_all_places ib3.occ_2 i.gender i.age_5 i.site i.ses_5
margins i.gender 
marginsplot
graph export "plots/margins/margins_gender_everyone_everywhere.png", width(800) replace  
margins i.occ_2
marginsplot, horiz
graph export "plots/margins/margins_occ2_everyone_everywhere.png", width(800) replace  

 
e

// guy to send me the code for that


// by hhmem_key, sort: egen contacts_all_places_mean = mean(contacts_all_places_av)
// gen contacts_all_places_av_str = contacts_all_places_av - contacts_all_places_mean

*let's make a series of histograms that compare the differences across categories 


*for each of the places  
local place 1 2 3 4 5

foreach x of local place {
	sum diff_contacts_ld if place == `x'
}

foreach i of local place {
  capture drop x`i' d`i'
  kdensity diff_contacts_ld if place== `i', generate(x`i'  d`i')
  }

gen zero = 0

twoway rarea d1 zero x1, color("blue%50") ///
	||  rarea d2 zero x2, color("purple%50") ///
	||  rarea d3 zero x3, color("orange%50")  ///
	||  rarea d4 zero x4, color("red%50") ///
	||	rarea d5 zero x5, color("green%50") ///
		title("Area plot of diff in contacts ld vs. nld by place") ///
		ytitle("Smoothed density") ///
		legend(ring(0) pos(2) col(1) order(1 "home" 2 "work" 3 "school" 4 "transport" 5 "entertainment" ))     
	
graph export "plots/diff_in_contacts/diff_in_contacts_by_place.png", width(800) replace


*box plots broken down by place  
graph hbox diff_contacts_ld, over(place) title("Reductions in contacts by place - ld vs nld") 
graph export "plots/diff_in_contacts/reductions_contacts_by_place.png", replace

*box plots broken down by occupation 
graph hbox diff_contacts_ld, over(occ_2) title("Reductions in contacts by occupation - ld vs nld") 
graph export "plots/diff_in_contacts/reductions_contacts_by_occ.png", replace

*histograms of them individually
foreach x in 1 2 3 4 5 {
	hist diff_contacts_ld if place == `x'
}

//xtset hhmem_key // lockdown
// xtreg contacts_all_places_av i.age_5 i.gender i.occ_2, fe
//
* 1. predictors of total contacts
xtnbreg tot_contacts_all_places i.lockdown ib3.occ_2 i.gender i.age_5 i.site i.ses_5, fe irr

* 2. predictors of change 

//generate a variable with change between the two rounds then run a linear regression on that variable

reg diff_contacts_ld ib3.occ_2 i.gender i.age_5 i.site i.ses_5

// ib3 is setting the not employed or homemaker as the comparator category
*********


* 3. predictors of change using interactions 

* look at difference 
xtnbreg tot_contacts_all_places i.lockdown##(ib3.occ_2 i.gender i.age_5 i.site i.ses_5), fe irr

// lockdown##occ_2 = this tells us that the drop that lockdown caused was larger for 2,3,5,6 than it was for unemployed 








nbreg contacts_all_places_av i.lockdown ib3.occ_2 i.gender i.age_5 i.site i.ses_5

nbreg tot_contacts_all_places lockdown ib3.occ_2 i.gender i.age_5 i.site i.ses_5, irr

