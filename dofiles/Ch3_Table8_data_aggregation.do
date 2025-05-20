* Making IPUMS 403 ward estimates at 761 CDR shapefile level 

cap cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/06_Data and Modelling/thesis_data/"

tempfile temp1 temp2 temp3 temp4 temp5 temp6 temp7 temp8 temp9 temp10

/*Files needed
- Master key for mapping ipums to 761 wards
- ipums 5 percent sample
- population count file from WorldPop at 761 level for combination 
*/


*****************************************************************************

* 1. Import the key for ipums, 761 and 1961 - this is at the 1961 level

import delimited using "shapefiles/master_key_ipum_761_1961.csv", clear


* see if I can re-match the 3 761 wards that are missing ZW150414, ZW160113, ZW180533
//br if inlist(ward_761_id, "ZW150414", "ZW160113","ZW180533") // they got lost in the QGIS merge so putting them back 

set obs 1973
replace ward_761_id = "ZW150414" in 1970
replace ward_761_id = "ZW150414" in 1971

replace ward_761_id = "ZW160113" in 1972
replace ward_761_id = "ZW180533" in 1973

* replace the corresponding keys 

replace ipum2012 = 5004001 in 1970
replace ipum2012 = 5004002 in 1971

replace ipum2012 = 6001001 if ward_761_id == "ZW160113"
replace ipum2012 = 8005001 if ward_761_id == "ZW180533" 

replace ward_1961_code ="ZW150414"  if ward_761_id == "ZW150414"
replace ward_1961_code ="ZW160113" if ward_761_id == "ZW160113"
replace ward_1961_code ="ZW180533"  if ward_761_id == "ZW180533" 

*count how many 1961s per 403 so I know how to weight 403 values where they are split across multiple 761s 

by ipum2012, sort: egen multi_1961_to_403 = count(ward_1961_code)

* count how many 761s have more than one unique ipums 403 value that needs to be split 

* 1. Tag the first occurrence of each unique 'ipum2012' within 'ward_761_id'
bysort ward_761_id ipum2012: gen tag = (_n == 1)
* Step 2: Count the unique occurrences by summing the 'tag' variable
by ward_761_id: egen multi_403_to_761 = total(tag)

save `temp1', replace

*****************************************************************************


* 2. now create one map of IPUMS to 1961 where 1961 is unique and I can add in the population weight count for the 1961 (conducted in QGIS with WP join attributes by location)

import delimited using "population/1961_ward_pop_counts/1961_ward_pop_counts.csv", clear 

codebook z_sum  

// note that there are 41 wards without pop counts. When I look a these on the map, it's because they are small urban ward without a centroid. will monitor what happens to these later 
rename z_sum pop_count_1961
rename adm3_pcode ward_1961_code

merge 1:m ward_1961_code using `temp1'

duplicates report ward_1961_code // reveals 10 duplicate copies where the 1961 wards are across 2 761 wards. Only 7001001 is a total duplicate in IPUMS, equivalent to ZW170122 in 1961

keep ward_1961_code ipum2012 multi_1961_to_403 pop_count_1961 ward_761_id multi_403_to_761

export delimited using "population/1961_ward_pop_counts/1961_ward_pop_counts_per_403.csv", replace

codebook ward_761_id if pop_count_1961 !=.
// 759 unique wards with population count data  
//br ward_761_id if pop_count_1961==.
save `temp2', replace

*****************************************************************************

* 3. on the other side, I need to join the 403 ipums estimates and then recalculate them at the 761 level 

use "population/IPUMS_2012/ipums_5p_2012_preprocessed.dta", clear 

rename geo3_zw2012 ipum2012
//br if ipum2012 == 50004001

gen male=1 if sex==1
replace male=0 if sex==2

replace urban=0 if urban==1
replace urban=1 if urban==2

foreach x in occ_2 occ4 empstatd {
	tabulate `x', gen(`x'_dummy)
}

tab occ_2

rename occ_2_dummy1 occ2_manual_labor
rename occ_2_dummy2 occ2_students_teachers
rename occ_2_dummy3 occ2_not_employed
rename occ_2_dummy4 occ2_retail_public_service
rename occ_2_dummy5 occ2_office_workers
rename occ_2_dummy6 occ2_informal_trading
rename occ_2_dummy7 occ2_other_informal
//
rename occ4_dummy1 occ4_ag_estates
rename occ4_dummy2 occ4_manu_mining_trades
rename occ4_dummy3 occ4_police_army
rename occ4_dummy4 occ4_education
rename occ4_dummy5 occ4_health_social_wk
rename occ4_dummy6 occ4_service_retail
rename occ4_dummy7 occ4_informal_trade
rename occ4_dummy8 occ4_subsistence_ag
rename occ4_dummy9 occ4_unemployed_not_ag
rename occ4_dummy10 occ4_other
rename occ4_dummy11 occ4_transport_sector
rename occ4_dummy12 occ4_office_worker
rename occ4_dummy13 occ4_religious

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


// no point running reg at individual level because the outcome is ward level


collapse (mean) male urban age under_12 teenage_13 young_adult middle_adult older_adult occ2_* occ4_* emp* yrschool, by(ipum2012)
sum emp_in_school // .1973045 mean

gen ward_id = ipum2012
export delimited "population/IPUMS_2012/403_ipums_ward_vars_only.csv", replace 
// just for R visualization also 

gen male_10 = male*10 //for easier interpretation using IRR according to GH
drop empstat empstatd 

merge 1:m ipum2012 using `temp2'
tab ward_761_id if _merge==2
codebook ipum2012 if _merge==3

// no IPUMS data for 761 wards ZW150414 and ZW152115 
tab ward_1961_code if _merge==2
// same 2 
codebook ward_1961_code if pop_count_1961==.
codebook ward_761_id 

keep if _merge ==3
codebook ward_761_id 
codebook ipum2012

// lost 1 IPUMS ward because no data collected for it 760 left 

*****************************************************************************
*4. I also need to merge in the population of the 761 wards so that I can do the weighting 

*****************************************************************************

*5. Now, final stage of the process, recalculate all the estimates for the 761 wards. Let's start with the age variable


*c. The following code allows for the most complicated case: if there are 2 different 1961 values to a 761 ward, then I would take the weighted average of the 1961 values within the 761 ward, disregarding the 403. I don´t at this point need to consider the 403 anymore. 

by ward_761_id, sort: egen pop_tot_1961_761 = total(pop_count_1961)
gen pop_weight_1961_761 = pop_count_1961/pop_tot_1961_761

codebook ward_761_id if pop_count_1961 ==.
//br if pop_count_1961 ==.
// gone from 41 with missing pop counts to 27 with missing pop counts, so this is good (seeing as they are tiny anyway)
codebook ward_761_id if pop_weight_1961_761 ==.
// also 27 so good. 

gen age_761_w = .
replace age_761_w = age*pop_weight_1961_761
by ward_761_id, sort: egen age_761_c  = total(age_761_w) 

* Now replicate this for other variables before collapse 

// foreach x in urban under_12 teenage_13_18 young_adult_19_34 middle_adult_35_64 older_adult_65 occ_ag_estates occ_manu_mining_trades occ_police_army occ_education occ_health_social_wk occ_service_retail occ_informal_petty_trade occ_subsistence_ag occ_unemployed_not_ag occ_other occ_transport_sector occ_office_worker occ_religious emp_niu emp_employed emp_unemployed emp_housework emp_unable_disabled emp_in_school emp_inactive emp_unknown yrschool male_10 male {
// 			gen `x'_761_w = .
// 			replace `x'_761_w = `x'*pop_weight_1961_761
// 			by ward_761_id, sort: egen `x'_761_c  = total(`x'_761_w) 
// 			drop `x'_761_w `x'
// }

foreach x in urban under_12 teenage_13_18 young_adult_19_34 middle_adult_35_64 older_adult_65 occ2_manual_labor occ2_students_teachers occ2_not_employed occ2_retail_public_service occ2_office_workers occ2_informal_trading occ2_other_informal occ4_ag_estates occ4_manu_mining_trades occ4_police_army occ4_education occ4_health_social_wk occ4_service_retail occ4_informal_trade occ4_subsistence_ag occ4_unemployed_not_ag occ4_transport_sector occ4_office_worker emp_niu emp_employed emp_unemployed emp_housework emp_unable_disabled emp_in_school emp_inactive emp_unknown yrschool male_10 male {
			gen `x'_761_w = .
			replace `x'_761_w = `x'*pop_weight_1961_761
			by ward_761_id, sort: egen `x'_761_c  = total(`x'_761_w) 
			drop `x'_761_w `x'
}


* just have a variable with the number of 1961s to a 761 so I can average 
by ward_761_id, sort: egen multi_1961_to_761 = count(ward_1961_code)

* order it so I can see it more clearly 
order ward_761_id ward_1961_code multi_1961_to_761 pop_tot_1961_761 pop_weight_1961_761

*finally collapse back down to the 761 ward level 

// local originals urban under_12 teenage_13_18 young_adult_19_34 middle_adult_35_64 older_adult_65 occ_ag_estates occ_manu_mining_trades occ_police_army occ_education occ_health_social_wk occ_service_retail occ_informal_petty_trade occ_subsistence_ag occ_unemployed_not_ag occ_other occ_transport_sector occ_office_worker occ_religious emp_niu emp_employed emp_unemployed emp_housework emp_unable_disabled emp_in_school emp_inactive emp_unknown yrschool male_10 male

collapse (mean) male_761 male_10 urban age_761_c under_12 teenage_13* young_adult* middle_adult* older_adult* occ2_* occ4_* emp* yrschool* (first) multi_1961_to_761 pop_tot_1961_761, by(ward_761_id)

sort ward_761_id
rename pop_tot_1961_761 pop_count_761

// foreach x in male_761 male_10 urban age_761_c under_12 teenage_13* young_adult* middle_adult* older_adult* occ_* emp* yrschool* {
// codebook ward_761_id if `x' ==. // not missing any obs at this level 
// 				}
export delimited "population/761_ward_level_ipums/761_ward_level_ipums.csv", replace

codebook ward_761_id 
// fixed ! all 761 are merged

save `temp3', replace


*** Now aggregate with all other files at the 761 level 
* a) RWI poverty indices (population weighted)
import delimited "wealth_index/HDX/761_ward_level/761_ward_poverty_mean.csv", clear

rename ward_id ward_761_id
sort ward_761_id

merge 1:1 ward_761_id using `temp3'
codebook ward_761_id if rwi_mean == . // there are 55 wards where they didn't have estimates for RWI

drop _merge

save `temp4', replace

* the remainder i have merged in using the nearest centroid to the 55 

import delimited "wealth_index/HDX/761_ward_level/55_unmatched_rwi_nearest.csv", clear
rename ward_id ward_761_id
rename rwi rwi_mean
sort ward_761_id

merge 1:1 ward_761_id using `temp4'
drop _merge // the 55 got filled in 

codebook ward_761_id if rwi_mean !=. // good all filled 

*normalize the rwi_mean score
egen rwi_min =min(rwi_mean)
egen rwi_max =max(rwi_mean)
gen rwi_norm = (rwi_mean-rwi_min)/(rwi_max-rwi_min)
sum rwi_norm
drop rwi_mean rwi_min rwi_max 

sort ward_761_id 

// foreach x in male_761 male_10 urban age_761_c under_12 teenage_13 young_adult middle_adult older_adult occ_ag_estates_761_c occ_manu_mining_trades_761_c occ_police_army_761_c occ_education_761_c occ_health_social_wk_761_c occ_service_retail_761_c occ_informal_petty_trade_761_c occ_subsistence_ag_761_c occ_unemployed_not_ag_761_c occ_other_761_c occ_transport_sector_761_c occ_office_worker_761_c occ_religious_761_c emp_niu_761_c emp_employed_761_c emp_unemployed_761_c emp_housework_761_c emp_unable_disabled_761_c emp_in_school_761_c emp_inactive_761_c emp_unknown_761_c yrschool_761_c rwi_norm {
// tab ward_761_id if `x' ==. 
// now none are missing so we are good 

foreach x in male_761 male_10 urban age_761_c under_12 teenage_13 young_adult middle_adult older_adult occ2_manual_labor_761_c occ2_students_teachers_761_c occ2_not_employed_761_c occ2_retail_public_service_761_c occ2_office_workers_761_c occ2_informal_trading_761_c occ2_other_informal_761_c emp_niu_761_c emp_employed_761_c emp_unemployed_761_c emp_housework_761_c emp_unable_disabled_761_c emp_in_school_761_c emp_inactive_761_c emp_unknown_761_c yrschool_761_c rwi_norm {
	tab ward_761_id if `x' ==. 
				} 
				
********************************************************************************************************************

* for those where it is unreasonable for them to be zero clean them ZW132601  ZW140207 ZW142107 and  ZW160606 are zero for a few  
// foreach x in male_761 male_10 age_761_c under_12 teenage_13 young_adult middle_adult older_adult occ_ag_estates_761_c occ_manu_mining_trades_761_c occ_police_army_761_c occ_education_761_c occ_health_social_wk_761_c occ_service_retail_761_c occ_informal_petty_trade_761_c occ_subsistence_ag_761_c occ_unemployed_not_ag_761_c occ_other_761_c occ_transport_sector_761_c occ_office_worker_761_c occ_religious_761_c emp_niu_761_c emp_employed_761_c emp_unemployed_761_c emp_housework_761_c emp_unable_disabled_761_c emp_in_school_761_c emp_inactive_761_c emp_unknown_761_c yrschool_761_c rwi_norm {
// 				tab ward_761_id if `x' ==0 
// 				} // 

//br if inlist(ward_761_id, "ZW132601", "ZW140207", "ZW142107", "ZW160606")
// fixed!  

foreach x in male_761 male_10 age_761_c under_12 teenage_13 young_adult middle_adult older_adult occ2_manual_labor_761_c occ2_students_teachers_761_c occ2_not_employed_761_c occ2_retail_public_service_761_c occ2_office_workers_761_c occ2_informal_trading_761_c occ2_other_informal_761_c emp_niu_761_c emp_employed_761_c emp_unemployed_761_c emp_housework_761_c emp_unable_disabled_761_c emp_in_school_761_c emp_inactive_761_c emp_unknown_761_c yrschool_761_c rwi_norm {
				tab ward_761_id if `x' ==0 
				} // 

*replace the zeros with means because it is throwing off the graph 

replace male_761 =  .480 				if male_761 ==0
replace age_761_c = 23.00014			if age_761_c ==0
replace emp_in_school_761_c = .1973045 	if emp_in_school_761_c==0

// this is just for the two wards without pop data 

********************************************************************************************************************
save `temp5', replace
codebook ward_761_id // 761 complete 

export delimited "population/761_ward_level_ipums/761_ward_level_plus_rwi.csv", replace
// just doing this for the R maps 
sum male_761_c // Male average .482, Max .5599 at the 761 level 
//was average .480 min .355 max .569 at 403 level - so things can change 
sum age_761_c 
// in 761 obs ,mean, std, min, max 761    22.98378    1.754955          0   28.18637
// in 403  obs,mean, std, min, max  402    23.00014     1.50795   19.21173   29.25224

********* now adding in the urban data from GHSL (18th Oct 2024, post 1st draft)

 
import delimited "land_type/761_ward_level/GHSL_761_ward_urbanity.csv", clear

rename ward_id ward_761_id 

merge 1:1 ward_761_id using `temp5'

replace ghsl_norm = 1 if ward_761_id =="ZW182203" // you can tell from the name and the census characteristiscs that this is an urban ward 
//br if inlist(ward_761_id, "ZW120107", "ZW140505", "ZW160315", "ZW180417" )
// all still there 

drop _merge 

tab ward_761_id if ghsl_norm == .
// great! clean 
save `temp6', replace

** bring in SUBSCRIBER COUNTS  

*** nonlockdown

import delimited "mobility/ward_level/output/subscriber_counts/i5_ward_nld_mean_sub_counts", clear 

rename region_lag ward_761_id
rename day_pop nld_subscriber_count

merge 1:1 ward_761_id using `temp6'
// 12 wards don't have a subscriber count  in nld :(
drop _merge
save `temp7', replace

*** early lockdown

import delimited "mobility/ward_level/output/subscriber_counts/i5_ward_march_ld_mean_sub_counts", clear 
rename region_lag ward_761_id
rename day_pop eld_subscriber_count

merge 1:1 ward_761_id using `temp7'
drop _merge
// 13 wards don't have a subscriber count in ld :(

save `temp8', replace 

*** late lockdown

import delimited "mobility/ward_level/output/subscriber_counts/i5_ward_nld_mean_sub_counts", clear 
rename region_lag ward_761_id
rename day_pop lld_subscriber_count

merge 1:1 ward_761_id using `temp8'
drop _merge

save `temp9', replace

//br if nld_subscriber_count ==. | eld_subscriber_count==.

*check how diff they are from eachother 
gen dif_sub_count = nld_subscriber_count-eld_subscriber_count
tab dif_sub_count,m 
// so they aren't really similar enough to replace one with the other when missing. They are intrinsically different 


** Bring in combined mobility FLOW COUNTS from nld, eLd, lLd // no longer using the Probabilities given Robbie's issues

import delimited "mobility/ward_level/non_cumulative/flow_counts_pairs_comb_761_i5.csv", clear 
// 750 wards with nld flow data, 746 with ld flow data. So we will drop down the analysis to these numbers. Will first generate a pairs dataset and then a single dataset 
codebook source if flow_nld !=. // 752 
codebook source if flow_eld !=. // 752
codebook source if flow_lld !=. // 752 

rename source ward_761_id 
sort ward_761_id

merge m:1 ward_761_id using `temp9'
// there are 9 wards that don't have any targets in the pairs (ZW120115, ZW120620, ZW120716, ZW130220, ZW132108, ZW140220, ZW150706, ZW160625, ZW160717)
codebook ward_761_id if _merge==3 // this is still 752 so we are okay
drop if target==""

drop _merge error_mean

* check missings 
// foreach x in  flow_nld flow_eld flow_lld male_761_c urban_761_c age_761_c under_12_761_c under_12_761_c teenage_13_18_761_c young_adult_19_34_761_c middle_adult_35_64_761_c older_adult_65_761_c occ_ag_estates_761_c occ_manu_mining_trades_761_c occ_police_army_761_c occ_education_761_c occ_health_social_wk_761_c occ_service_retail_761_c occ_informal_petty_trade_761_c occ_subsistence_ag_761_c occ_unemployed_not_ag_761_c occ_other_761_c occ_transport_sector_761_c occ_office_worker_761_c occ_religious_761_c emp_niu_761_c emp_employed_761_c emp_unemployed_761_c emp_housework_761_c emp_unable_disabled_761_c emp_in_school_761_c emp_inactive_761_c emp_unknown_761_c yrschool_761_c multi_1961_to_761 rwi_norm {
// tab ward_761_id if `x' ==.  
// 				} // none missing anymore! 

foreach x in  flow_nld flow_eld flow_lld male_761_c urban_761_c age_761_c under_12_761_c under_12_761_c teenage_13_18_761_c young_adult_19_34_761_c middle_adult_35_64_761_c older_adult_65_761_c occ2_manual_labor_761_c occ2_students_teachers_761_c occ2_not_employed_761_c occ2_retail_public_service_761_c occ2_office_workers_761_c occ2_informal_trading_761_c occ2_other_informal_761_c  occ4_ag_estates occ4_manu_mining_trades occ4_police_army occ4_education occ4_health_social_wk occ4_service_retail occ4_informal_trade occ4_subsistence_ag occ4_unemployed_not_ag occ4_transport_sector occ4_office_worker emp_niu_761_c emp_employed_761_c emp_unemployed_761_c emp_housework_761_c emp_unable_disabled_761_c emp_in_school_761_c emp_inactive_761_c emp_unknown_761_c yrschool_761_c multi_1961_to_761 rwi_norm {
tab ward_761_id if `x' ==.  
				} // none missing anymore! 

*rename all the variables with the source characteristics as such 
rename ward_name s_ward_name
rename province_n s_province_n
rename district_i s_district_i
rename district_n s_district_n
rename *_c s_*
rename ghsl s_ghsl_urb
rename rwi_norm s_rwi_norm
rename pop_count_761 s_pop_count_761

rename ward_761_id source 

rename target ward_761_id
sort ward_761_id

merge m:1 ward_761_id using `temp9' 

*in the same way drop where the other side of the pair is missing 
drop if source==""

rename *_c t_*
rename ghsl t_ghsl_urb
rename rwi_norm t_rwi_norm
rename pop_count_761 t_pop_count_761

//keep if _merge ==3
rename ward_761_id target 

codebook source // 752 before we take out the poverty data 

*now generate a variable which has the pairs in it 

gen source_target = source + "-" + target 

sort source_target
isid source_target

codebook source_target // 564,752 unique pairs (752*752 would be 565,504 - 752 = 564,752)

codebook source_target if flow_eld !=. 
gen diff_flow_nld_eld = flow_nld - flow_eld // this only applies for non source-source pairs 
gen diff_flow_nld_lld = flow_nld - flow_lld // this only applies for non source-source pairs 

drop _merge
sort source_target
isid source_target

save `temp10', replace 


*add in euclidean distance for the centroid - to - centroid points for 761 wards

import dbase "shapefiles/wards/ZW_agg_761_wards/761_ward_distance_matrix.dbf", clear

gen source_target = InputID + "-" + TargetID 

duplicates tag source_target, gen (dup_pair)
tab dup_pair

drop if InputID ==""

*take an average of all the duplicate values so I can have unique pairs 
by source_target, sort: egen av_dist = mean(Distance)
by source_target, sort: gen dup = _n

*generate a distance value that is in kms 
gen av_dist_km = av_dist/1000
drop Distance
drop if dup !=1 
codebook InputID // back to 761 
isid source_target
codebook source_target //578,397 unique pairs 

merge 1:1 source_target using `temp10'

codebook source if _merge==3 //752 individual wards
codebook source_target if _merge==3 // 564,752 pairs 


* if it is in CDR but not in distance, this is largely because they are the same place source target combos which the distance matrix didn't calculate 

replace av_dist = 0 if source==target
drop if source ==""
*keep if _merge ==3
codebook source_target // 579,121 unique source-targets - some of the original pairs got lost 

drop InputID TargetID dup_pair dup 
order source target flow_* nld_sub eld_ lld_ dif* av_dist s_* t_*

* generate a total moves variable per source ward, for the offset term but removing the count of people who moved from home to home 

by source, sort: egen tot_moves_from_source_nld = total(flow_nld) 
by source, sort: egen tot_moves_from_source_eld = total(flow_eld) 
by source, sort: egen tot_moves_from_source_lld = total(flow_lld) 

by source, sort: egen source_to_source_moves_nld = total(flow_nld) if source==target
by source, sort: egen source_to_source_moves_eld = total(flow_eld) if source==target
by source, sort: egen source_to_source_moves_lld = total(flow_lld) if source==target

gen excl_moves_from_source_nld = tot_moves_from_source_nld - source_to_source_moves_nld 
gen excl_moves_from_source_eld = tot_moves_from_source_eld - source_to_source_moves_eld 
gen excl_moves_from_source_lld = tot_moves_from_source_lld - source_to_source_moves_lld 

drop tot_moves_from_source_nld tot_moves_from_source_eld tot_moves_from_source_lld

** Last bit of cleaning - 11 wards dropped from analysis so we are down to 750: 

// POPULATION DATA:  there are two observations that got lost in the analysis because no population centroids fit inside the ward. Ideally I would find some way to reallocate the population to them but for the moment, I will not include them in the analysis: ward_id ZW132601, ZW142107

drop if inlist(source, "ZW132601", "ZW142107")

// WHERE WARDS DIDN'T HAVE CELL TOWERS ACTIVE: ZW120115, ZW120620, ZW120716, ZW130220, ZW132108, ZW140220, ZW150706, ZW160625, ZW160717 - they were already not in the count data 

drop if inlist(source, "ZW120115", "ZW120620", "ZW120716", "ZW130220", "ZW132108", "ZW140220", "ZW150706", "ZW160625", "ZW160717")

*now to make it even, I have to also drop the target wards because presumably they wouldn't be picked up either 

drop if inlist(target, "ZW132601", "ZW142107")
drop if inlist(target, "ZW120115", "ZW120620", "ZW120716", "ZW130220", "ZW132108", "ZW140220", "ZW150706", "ZW160625", "ZW160717")

// now I have 750*750 obs = 562,500 - before dropping the equal pairs 
codebook source


// // multiply occupations by 10 
// foreach x in t_occ_transport_sector t_occ_ag_estates t_occ_manu_mining_trades {
// 	gen `x'_10 = `x'*10
// }
//
// foreach x in s_occ_transport_sector s_occ_ag_estates s_occ_manu_mining_trades {
// 	gen `x'_10 = `x'*10
// }


foreach x in s_occ4_ag_estates_761 s_occ4_manu_mining_trades_761 s_occ4_police_army_761 s_occ4_education_761 s_occ4_health_social_wk_761 s_occ4_service_retail_761 s_occ4_informal_trade_761 s_occ4_subsistence_ag_761 s_occ4_unemployed_not_ag_761 s_occ4_transport_sector_761 s_occ4_office_worker_761  {
	gen `x'_10 = `x'*10 
}
// need to add target ones if I use this in the analysis


foreach x in s_occ2_manual_labor_761 s_occ2_students_teachers_761 s_occ2_not_employed_761  s_occ2_office_workers_761 s_occ2_informal_trading_761 s_occ2_other_informal_761 t_occ2_manual_labor_761 t_occ2_students_teachers_761 t_occ2_not_employed_761 t_occ2_office_workers_761 t_occ2_informal_trading_761 t_occ2_other_informal_761 {
	gen `x'_10 = `x'*10
}

rename s_occ2_retail_public_service_761 s_occ2_retail_public_service_10
rename t_occ2_retail_public_service_761 t_occ2_retail_public_service_10

*multiply proportion of young adults by 10 
gen s_young_adult_19_34_10 = s_young_adult_19_34_761*10
gen t_young_adult_19_34_10 = t_young_adult_19_34_761*10

*generate trips per subscriber 
gen excl_trips_per_subscriber_nld = excl_moves_from_source_nld/nld_subscriber_count

gen excl_trips_per_subscriber_eld = excl_moves_from_source_eld/eld_subscriber_count
 
gen excl_trips_per_subscriber_lld = excl_moves_from_source_eld/lld_subscriber_count

export delimited "combined_estimates/comb_761_wards_pairs_nld_ld.csv", replace

*now just keep the source values for source to source 

// for this I need to keep the total count of source to all targets over the total count of 

keep if source == target 

drop if source == ""

drop t_* av_dist
drop flow_nld flow_eld flow_lld // these are the counts of trips below subscriber count at ward level, but instead of using that, we use the excl metric to mean count of trips to other wards 
drop diff_flow_nld_eld diff_flow_nld_lld // this is misleading because it includes the people that stayed for source-source


* for this difference, my reference point is always the NLD, so here, the difference is always computed relative to NLD,we know that there was an increase in moves per subscriber betwen nld --> eld, and a drop in moves nld-->lld 

gen diff_trips_nld_eld_per_sub=  excl_trips_per_subscriber_nld - excl_trips_per_subscriber_eld

replace diff_trips_nld_eld_per_sub =. if (excl_moves_from_source_nld ==0 | excl_moves_from_source_eld==0)

gen diff_trips_nld_lld_per_sub=  excl_trips_per_subscriber_nld - excl_trips_per_subscriber_lld

replace diff_trips_nld_lld_per_sub =. if (excl_moves_from_source_nld ==0 | excl_moves_from_source_lld==0)


sum diff_trips_nld_eld_per_sub  diff_trips_nld_lld_per_sub
// hist diff_trips_ld_nld_per_subscriber
// hist diff_trips_ld_nld_counts 
// much more normally distributed now 

* no point in keeping the obs

codebook source // 750 obs

order source target excl* diff_trips* s_* 


export delimited "combined_estimates/comb_761_wards_indiv_nld_ld.csv", replace

* check missings 
// foreach x in excl_moves_from_source_nld excl_moves_from_source_ld diff_trips_ld_nld_counts diff_trips_ld_nld_per_subscriber  s_ghsl_urb s_male_761 s_urban_761 s_age_761 s_under_12_761 s_teenage_13_18_761 s_young_adult_19_34_761 s_middle_adult_35_64_761 s_older_adult_65_761 s_occ_ag_estates_761 s_occ_manu_mining_trades_761 s_occ_police_army_761 s_occ_education_761 s_occ_health_social_wk_761 s_occ_service_retail_761 s_occ_informal_petty_trade_761 s_occ_subsistence_ag_761 s_occ_unemployed_not_ag_761 s_occ_other_761 s_occ_transport_sector_761 s_occ_office_worker_761 s_occ_religious_761 s_emp_niu_761 s_emp_employed_761 s_emp_unemployed_761 s_emp_housework_761 s_emp_unable_disabled_761 s_emp_in_school_761 s_emp_inactive_761 s_emp_unknown_761 s_yrschool_761 s_rwi_norm  {
// tab source if `x' ==.  
// 				} 

* occ2 categories of employment 
foreach x in excl_moves_from_source_nld excl_moves_from_source_eld excl_moves_from_source_lld diff_trips_nld_eld_per_sub diff_trips_nld_lld_per_sub  s_ghsl_urb s_male_761 s_urban_761 s_age_761 s_under_12_761 s_teenage_13_18_761 s_young_adult_19_34_761 s_middle_adult_35_64_761 s_older_adult_65_761 s_occ2_manual_labor_761 s_occ2_students_teachers_761 s_occ2_not_employed_761 s_occ2_retail_public_service_10 s_occ2_office_workers_761 s_occ2_informal_trading_761 s_occ2_other_informal_761 s_emp_niu_761 s_emp_employed_761 s_emp_unemployed_761 s_emp_housework_761 s_emp_unable_disabled_761 s_emp_in_school_761 s_emp_inactive_761 s_emp_unknown_761 s_yrschool_761 s_rwi_norm  {
tab source if `x' ==.  
				} 
				

				
				
* identify the wards with missing info

tab source if nld_subscriber_count ==.
tab source if eld_subscriber_count ==.

// where the subscriber counts were missing
