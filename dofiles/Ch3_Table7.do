* For district level mobility analysis
// Fig 10 of chapter 3 see L91-L92
// table 7 of chapter 3  see L97 - L109
tempfile temp1 temp2

cap cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/06_Data and Modelling/thesis_data/mobility/district_level/probabilities/"
import delimited "d_comb_prob_stay.csv", clear


* create 5 groups for each 

//group them in to quintiles of mobility
xtile nld_prob_leave_5 = nld_prob_leave, nq(5)
xtile ld_prob_leave_5 = ld_prob_leave, nq(5)

tab nld_prob_leave_5
tab ld_prob_leave_5

save `temp1', replace 

*bring in census data and collapse to district level for some simple descriptives on the districts before and during lockdown 

use  "../../../population/IPUMS_2012/ipums_5p_2012_preprocessed.dta", clear

rename new_district_id dist_no

*collapse IVs to DV level 
gen male=1 if sex==1
replace male=0 if sex==2


replace urban=0 if urban==1
replace urban=1 if urban==2

foreach x in occ4 empstatd {
	tabulate `x', gen(`x'_dummy)
}

rename occ4_dummy1 occ_ag_estates
rename occ4_dummy2 occ_manu_mining_trades
rename occ4_dummy3 occ_police_army
rename occ4_dummy4 occ_education
rename occ4_dummy5 occ_healthcare_social_work
rename occ4_dummy6 occ_service_retail
rename occ4_dummy7 occ_informal_petty_trade
rename occ4_dummy8 occ_subsistence_ag
rename occ4_dummy9 occ_unemployed_not_ag
rename occ4_dummy10 occ_other
rename occ4_dummy11 occ_transport_sector
rename occ4_dummy12 occ_office_worker
rename occ4_dummy13 occ_religious

rename empstatd_dummy1 emp_niu
rename empstatd_dummy2 emp_employed
rename empstatd_dummy3 emp_unemployed
rename empstatd_dummy4 emp_housework
rename empstatd_dummy5 emp_unable_disabled
rename empstatd_dummy6 emp_in_school
rename empstatd_dummy7 emp_inactive
rename empstatd_dummy8 emp_unknown
// in work, not in work but want work, not in work not wanting 
// employed, unemployed, inschool, anyone else

replace yrschool=5 if yrschool==91
replace yrschool=9 if yrschool==92
replace yrschool=9 if yrschool==93
replace yrschool=14 if yrschool==94
replace yrschool=. if inlist(98,99)

// age : create Manicaland categories (school, working, retired etc.)

gen under_12= (age >=0 & age <12)
gen teenage_13_18=(age >=13 & age <=18)
gen young_adult_19_34=(age >=19 & age <=34)
gen middle_adult_35_64= (age >=35 & age <=64)
gen older_adult_65=(age >=65)


// no point running reg at individual level because the outcome is district level


collapse (mean) male urban age under_12 teenage_13 young_adult middle_adult older_adult occ_* emp* yrschool, by(dist_no)

gen male_10 = male*10

merge m:1 dist_no using `temp1'

*just tabulate the characteristics of districts with the highest probability of leavers in nld (high prob =5)

** long
tabstat nld_prob_leave male urban age occ_ag_est occ_manu_m emp_emp emp_in_sch yrschool, by(nld_prob_leave_5) long col(stat)  varwidth(20)
tabstat ld_prob_leave male urban age occ_ag_est occ_manu_m emp_emp emp_in_sch yrschool, by(ld_prob_leave_5) long col(stat)  varwidth(20)


ologit nld_prob_leave_5 male_10 urban young_adult_19_34 occ_ag_est occ_manu_m emp_emp emp_in_sch yrschool 

reg nld_prob_leave male_10 urban young_adult_19_34 occ_ag_est occ_manu_m emp_emp emp_in_sch yrschool, robust 

*bivariate associations recommended by guy because so few observations
reg nld_prob_leave male_10, robust 

est store dist_mob, title(DistMobility)
esttab dist_mob using ../tables/dist_mob.csv, eform cells("b(fmt(2)) ci_l(fmt(2)) ci_u(fmt(2))  _star") title("Bivariate Associations with the Probability of District Departures Pre-lockdown") label replace

foreach x in urban young_adult_19_34 occ_ag_est occ_manu_m emp_emp emp_in_sch yrschool {
reg nld_prob_leave `x', robust 
est store dist_mob, title(DistMobility)
esttab dist_mob using ../tables/dist_mob.csv, eform cells("b(fmt(2)) ci_l(fmt(2)) ci_u(fmt(2))  _star") label append

}

* output




* try to understand if there are clear indicators of what drives the difference between ld and nld 
gen dif= nld_prob_leave - ld_prob_leave
xtile dif_5 = dif, nq(5)
ologit dif_5 male_10 urban young_adult_19_34 occ_ag_est occ_manu_m emp_emp emp_in_sch yrschool 
reg dif male_10 urban young_adult_19_34 occ_ag_est occ_manu_m emp_emp emp_in_sch yrschool 

keep dist_no nld_prob_leave ld_prob_leave

export delimited using "../plots/data_for_sankey.csv", replace

*** for the sankey plot make a combined one of the pairs 

import delimited "d_prob_move_pairs_nld.csv", clear 
gen source_target = source+target
sort source_target
save `temp2', replace

import delimited "d_prob_move_pairs_ld.csv", clear 
gen source_target = source+target
sort source_target

merge 1:1 source_target using `temp2'

drop source_target _merge dist_no

xtile prob_move_q_nld = nld_prob_move, nq(5)
xtile prob_move_q_ld = ld_prob_move, nq(5)


export delimited using "../plots/pairs_for_sankey.csv", replace


** just check the counts 

import delimited using "../counts/nld_district_total_trip_counts.csv", clear 
sum d_* // no negative counts here 

