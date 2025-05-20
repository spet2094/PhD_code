
clear all
cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/08_Fieldwork/08_Data/R8_data"

*Purpose: answer Q1 and Q2 of data analysis on social contacts 

use "IVQ_R8_newVars.dta", clear


*quantile the ses variable


//curvefit tot_contacts_work_wk_ld ses, f(w)
// need to figure out how to do this - what kind of function am I looking for.

// *distribution of contacts by socio-economic status 
// graph twoway scatter tot_contacts_work_wk_ld  ses, title("Number of contacts by socio-economic status")  legend(pos(12) ring(0) col(2))
// graph export "plots/ses/compare_ses_tot_contacts_work_wk_ld_bar.png", replace
//
// *try with different ses variables 
// graph twoway scatter  tot_contacts_work_wk_nld  ses_5 || lfit tot_contacts_work_wk_nld ses_5, title("Number of contacts by socio-economic status-work nld ") legend(pos(12) ring(0) col(2))
// graph export "plots/ses/compare_ses_contacts_wk_nld.png", replace

**rather than poisson, it's negative binomial 
*what socio-economic variables are associated with the number of contacts people have? 

*** for the purpose of this analysis, we need to combine school contacts --> work contacts for students
replace tot_contacts_work_wk_ld = tot_contacts_school_wk_ld if occupation == 10
replace tot_contacts_work_wk_nld = tot_contacts_school_wk_nld if occupation == 10


*another occupation grouping that means more similar categories go together
gen occ_2 = 1 if inlist(occupation, 1,2)
replace occ_2 = 2 if inlist(occupation, 4,10)
replace occ_2 = 3 if inlist(occupation,11,18)
replace occ_2 = 4 if inlist(occupation,3,6,7,16)
replace occ_2 = 5 if inlist(occupation, 15)
replace occ_2 = 6 if inlist(occupation, 8)
replace occ_2 = 7 if inlist(occupation, 9, 17)
la define oc2 1 "manual labor" 2 "students or teachers" 3 "not employed or homemakers" 4 "workers - retail or public service" 5 "office workers" 6 "informal trading" 7 "other informal"

la values occ_2 oc2 

* compare categorizations 


foreach x in 1 2 3 4 5 6 7 {
	sum tot_contacts_work_wk_nld if occ_2 == `x'
}

foreach x in 1 2 3 4 6 7 8 9 10 11 12 15 16 17 18 {
sum tot_contacts_work_wk_nld if occupation ==`x'

}

 ****NEGATIVE BINOMIAL - for

**AT WORK - NON LOCKDOWN FIRST 
nbreg tot_contacts_work_wk_nld ib3.occ_2 i.gender i.age_5 i.site i.ses_5, irr

nbreg tot_contacts_work_wk_nld ib3.occ_2 i.gender i.age_5 i.site i.ses_5

 // ib3.occ_2 - sets baseline of the occ_2 variable comparison to the not employed or homemaker category

 
 
outreg2 using plots/ses/r_nbreg_work, excel replace ctitle(lockdown)
nbreg tot_contacts_work_wk_nld  i.ses_5 i.gender age i.occupation i.site
outreg2 using plots/ses/r_nbreg_work, excel append ctitle(non-lockdown)

***AT HOME - NON LOCKDOWN FIRST
nbreg tot_contacts_home_wk_nld ib3.occ_2 i.gender i.age_5 i.site i.ses_5, irr

nbreg tot_contacts_home_wk_nld ib3.occ_2 i.gender i.age_5 i.site i.ses_5


nbreg tot_contacts_home_wk_ld  i.ses_5 i.gender age i.occupation i.site
outreg2 using plots/ses/r_nbreg_home, word replace ctitle(lockdown)
nbreg tot_contacts_home_wk_nld  i.ses_5 i.gender age i.occupation i.site
outreg2 using plots/ses/r_nbreg_home, word append ctitle(non-lockdown)


**IN ENTERTAINMENT NON LOCKDOWN on weekends
nbreg tot_contacts_ent_we_nld ib3.occ_2 i.gender i.age_5 i.site i.ses_5, irr
outreg2 using plots/ses/r_nbreg_ent, word replace ctitle(lockdown)

nbreg tot_contacts_ent_we_nld  i.ses_5 i.gender age i.occupation i.site
outreg2 using plots/ses/r_nbreg_ent, word replace ctitle(lockdown)

**ON TRANSPORT NON LOCKDOWN FIRST 
nbreg tot_contacts_trans_wk_nld ib3.occ_2 i.gender i.age_5 i.site i.ses_5, irr


nbreg tot_contacts_trans_wk_ld  i.ses_5 i.gender age i.occupation i.site
outreg2 using plots/ses/r_nbreg_trans, word replace ctitle(lockdown)

nbreg tot_contacts_trans_wk_nld  i.ses_5 i.gender age i.occupation i.site
outreg2 using plots/ses/r_nbreg_trans, word replace ctitle(lockdown)



****POISSON 

// **at work (ld and nld)
// nbreg tot_contacts_work_wk_ld  ses i.gender i.occupation i.site
// outreg2 using plots/ses/r_poisson, excel replace ctitle(lockdown)
// poisson tot_contacts_work_wk_nld  ses i.gender i.occupation i.site
// outreg2 using plots/ses/r_poisson, excel append ctitle(non-lockdown)


***OLS

//
// **at home (ld and nld)
// reg tot_contacts_home_wk_ld  ses i.gender i.occupation i.site
// outreg2 using plots/ses/r_ols, word replace ctitle(lockdown)
// reg tot_contacts_home_wk_nld  ses i.gender i.occupation i.site
// outreg2 using plots/ses/r_ols, word append ctitle(non-lockdown)
//
// **at school (ld and nld)
// reg tot_contacts_sch_wk_ld  ses i.gender i.occupation i.site
// reg tot_contacts_sch_wk_nld  ses i.gender i.occupation i.site
//
// **in the community (ld and nld)
// reg tot_contacts__wk_ld  ses i.gender i.occupation i.site
// reg tot_contacts_sch_wk_nld  ses i.gender i.occupation i.site
