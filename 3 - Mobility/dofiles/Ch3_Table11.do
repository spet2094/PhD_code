*** RESEARCH QUESTION: Where in the country do we see greater movement between places and what socio-economic factors can help to explain the differences? Why do people flow from i to j? 

cap cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/06_Data and Modelling/thesis_data/"

import delimited "combined_estimates/comb_761_wards_pairs_nld_ld.csv", clear

** CONDUCT ANALYSIS
codebook source if flow_nld !=.

*do the poisson regression as was suggestd by Guy, where we are attempting to explain the flow from i to j for each ward pair examining the relationship with the gender proportion, the age distribution of its residents, the years of schooling of residents and the number of agricultural workers, manufacturers and employed people in the target ward. Exposure term is the total number of moves for that source ward to all other wards 

// hist flow_nld if flow_nld !=0, bin(1000) 
gen r_flow_nld = round(flow_nld)
drop flow_nld
rename r_flow_nld flow_nld 

*check if i generate a flow per subscriber count what happens 
gen flow_nld_per_subscribers = flow_nld /nld_subscriber_count
// hist flow_nld_per_subscriber if flow_nld_per_subscribers, bin(1000)


//
// replace flow_nld =. if flow_nld==0 
// //drop if flow_nld ==0
// gen log_flow_nld = log(flow_nld)
// hist flow_nld
//
// xtile x_flow_nld = log_flow_nld , nq(5) altdef
// tab x_flow_nld
// forvalues x = 1/5 {
// 	sum flow_nld  if x_flow_nld==`x'
// }
//


*I need to exclude the pairs where the source == destination 
drop if source == target // now I have 561,750 obs which is 750*750 - 750
//drop if flow_nld==0
// if I do this, I end up with just 61,674 obs, instead of dropping them, am doing a zero-inflated poisson regression to include all obs 

* in order to create clusters by source for the poisson regression, I need to encode the names 
encode source, gen(source_n)
xtset source_n

*to include the subscriber count, I need to drop the 0 values

drop if nld_subscriber_count==0
sum flow_nld
poisson flow_nld av_dist, exposure (nld_subscriber_count)

*separately, I want to pair up the urb-urb, rur-rur, urb-rur, rur-urb to see if it makes any difference to the direction of the relationships 

hist s_urb
gen urb_urb = 0
replace urb_urb =1 if s_urban >.308 & t_urban >.308
gen urb_rur = 0
replace urb_rur =1 if s_urban >.308 & t_urban <.308
gen rur_urb = 0
replace rur_urb =1 if s_urban <.308 & t_urban >.308
gen rur_rur = 0
replace rur_rur = 1 if s_urban <.308 & t_urban <.308

*rename a few variables and create some of the *10 ones 
gen t_occ4_trans_sector_10 = t_occ4_transport_sector_761*10
gen t_occ4_ag_estates_10 = t_occ4_ag_estates_761*10
gen t_occ4_manu_mining_trades_10 =t_occ4_manu_mining_trades_761*10
******************************************************************
*QUESTION 3: When considering ward pairs, what socio-economic characteristics are associated with a higher degree of connectivity between locations? 
******************************************************************
** nld 
**version with urbanity only 
zip flow_nld av_dist_km s_occ4_transport_sector_761_10 t_occ4_trans_sector_10 s_occ4_ag_estates_761_10 t_occ4_ag_estates_10 s_occ4_manu_mining_trades_761_10 t_occ4_manu_mining_trades_10 s_urban t_urban s_young_adult_19_34_10 t_young_adult_19_34_10 s_yrschool, inflate(av_dist_km) vce(cluster source_n) irr

* output
est store ward_pairs_urb, title(WardPairsUrbZip)
esttab ward_pairs_urb using mobility/ward_level/tables/WardPairsUrbZip.csv, eform cells("b(fmt(2)) ci_l(fmt(2)) ci_u(fmt(2))  _star") title("Characteristics Associated with Trips between Ward Pairs Non-lockdown - no poverty") label replace


**do the zero-inflated version (poverty only here)
zip flow_nld av_dist_km s_occ4_transport_sector_761_10 t_occ4_trans_sector_10 s_occ4_ag_estates_761_10 t_occ4_ag_estates_10 s_occ4_manu_mining_trades_761_10 t_occ4_manu_mining_trades_10 s_rwi_norm t_rwi_norm s_young_adult_19_34_10 t_young_adult_19_34_10 s_yrschool, inflate(av_dist_km) vce(cluster source_n) irr

* output
est store ward_pairs_pov, title(WardPairsPovZip)
esttab ward_pairs_pov using mobility/ward_level/tables/WardPairsPovZip.csv, eform cells("b(fmt(2)) ci_l(fmt(2)) ci_u(fmt(2))  _star") title("Characteristics Associated with Trips between Ward Pairs Non-lockdown - no urbanity") label replace

**do the zero-inflated version (urb and pov )
zip flow_nld av_dist_km s_occ4_transport_sector_761_10 t_occ4_trans_sector_10 s_occ4_ag_estates_761_10 t_occ4_ag_estates_10 s_occ4_manu_mining_trades_761_10 t_occ4_manu_mining_trades_10 s_urban t_urban  s_rwi_norm t_rwi_norm s_young_adult_19_34_10 t_young_adult_19_34_10 s_yrschool, inflate(av_dist_km) vce(cluster source_n) irr

* output
est store ward_pairs_pov, title(WardPairsPovZip)
esttab ward_pairs_pov using mobility/ward_level/tables/WardPairsUrbPovZip.csv, eform cells("b(fmt(2)) ci_l(fmt(2)) ci_u(fmt(2))  _star") title("Characteristics Associated with Trips between Ward Pairs Non-lockdown - urbanity & poverty") label replace

***out of curiosity what about for early lockdown 
zip flow_eld av_dist_km s_occ4_transport_sector_761_10 t_occ4_trans_sector_10 s_occ4_ag_estates_761_10 t_occ4_ag_estates_10 s_occ4_manu_mining_trades_761_10 t_occ4_manu_mining_trades_10 s_urban t_urban  s_rwi_norm t_rwi_norm s_young_adult_19_34_10 t_young_adult_19_34_10 s_yrschool, inflate(av_dist_km) vce(cluster source_n) irr

e

******************************************************************
* try with the rur_urb categories 
******************************************************************

*try with interaction term which Guy said makes more sense 
zip flow_nld av_dist_km c.s_urban#c.t_urban s_occ_transport_sector_10 t_occ_transport_sector_10 s_occ_ag_estates_10 t_occ_ag_estates_10 s_occ_manu_mining_trades_10 t_occ_manu_mining_trades_10 s_young_adult_19_34_10 t_young_adult_19_34_10 s_yrschool, inflate (av_dist_km) exposure(nld_subscriber_count) vce(cluster source_n) irr
// urbanity not significant

*try with population density 
zip flow_nld av_dist_km s_pop_count_761 s_occ_transport_sector_10 t_occ_transport_sector_10 s_occ_ag_estates_10 t_occ_ag_estates_10 s_occ_manu_mining_trades_10 t_occ_manu_mining_trades_10 s_young_adult_19_34_10 t_young_adult_19_34_10 s_yrschool, inflate (av_dist_km) exposure(nld_subscriber_count) vce(cluster source_n) irr


e
*urb > urb 
zip flow_nld av_dist_km  s_occ_transport_sector_10 t_occ_transport_sector_10 s_occ_ag_estates_10 t_occ_ag_estates_10 s_occ_manu_mining_trades_10 t_occ_manu_mining_trades_10 s_urban t_urban s_young_adult_19_34_10 t_young_adult_19_34_10 s_yrschool if urb_urb ==1, inflate (av_dist_km) exposure(nld_subscriber_count) vce(cluster source_n) irr

// urban to urban, the urbanity of the source and the destination are negatively correlated with flow.

* output
est store ward_pairs_urb_urb, title(WardPairsUrbToUrbZip)
esttab ward_pairs_urb_urb using mobility/ward_level/tables/WardPairsUrbToUrbZip.csv, eform cells("b(fmt(2)) ci_l(fmt(2)) ci_u(fmt(2))  _star") title("Characteristics Associated with Trips between Urban-Urban Ward Pairs Non-lockdown") label replace

* rur > rur 
zip flow_nld av_dist_km  s_occ_transport_sector_10 t_occ_transport_sector_10 s_occ_ag_estates_10 t_occ_ag_estates_10 s_occ_manu_mining_trades_10 t_occ_manu_mining_trades_10 s_urban t_urban s_young_adult_19_34_10 t_young_adult_19_34_10 s_yrschool if rur_rur ==1, inflate (av_dist_km) exposure(nld_subscriber_count) vce(cluster source_n) irr

// rural to rural, the urbanity is not correlated at source or destination

est store ward_pairs_rur_rur, title(WardPairsRurToRurZip)
esttab ward_pairs_rur_rur using mobility/ward_level/tables/WardPairsRurToRurZip.csv, eform cells("b(fmt(2)) ci_l(fmt(2)) ci_u(fmt(2))  _star") title("Characteristics Associated with Trips between Rural-Rural Ward Pairs Non-lockdown") label replace


*urb > rur 
zip flow_nld av_dist_km  s_occ_transport_sector_10 t_occ_transport_sector_10 s_occ_ag_estates_10 t_occ_ag_estates_10 s_occ_manu_mining_trades_10 t_occ_manu_mining_trades_10 s_urban t_urban s_young_adult_19_34_10 t_young_adult_19_34_10 s_yrschool if urb_rur ==1, inflate (av_dist_km) exposure(nld_subscriber_count) vce(cluster source_n) irr


// urban to rural the more urban the destination the greater the flow 

est store ward_pairs_urb_rur, title(WardPairsUrbToRurZip)
esttab ward_pairs_urb_rur using mobility/ward_level/tables/WardPairsUrbToRurZip.csv, eform cells("b(fmt(2)) ci_l(fmt(2)) ci_u(fmt(2))  _star") title("Characteristics Associated with Trips between Urban-Rural Ward Pairs Non-lockdown") label replace


* rural > urban
zip flow_nld av_dist_km  s_occ_transport_sector_10 t_occ_transport_sector_10 s_occ_ag_estates_10 t_occ_ag_estates_10 s_occ_manu_mining_trades_10 t_occ_manu_mining_trades_10 s_urban t_urban s_young_adult_19_34_10 t_young_adult_19_34_10 s_yrschool if rur_urb ==1, inflate (av_dist_km) exposure(nld_subscriber_count) vce(cluster source_n) irr


// rural to urban flow - the more urban the source AMONG rural places, the greater the flow. The less urban the destination AMONG urban destinations, the lower the flow. 

est store ward_pairs_rur_urb, title(WardPairsRurToUrbZip)
esttab ward_pairs_rur_urb using mobility/ward_level/tables/WardPairsRurToUrbZip.csv, eform cells("b(fmt(2)) ci_l(fmt(2)) ci_u(fmt(2))  _star") title("Characteristics Associated with Trips between Rural-Urban Ward Pairs Non-lockdown") label replace


e
******************************************************************
* with flow per subscriber counts 
******************************************************************

poisson flow_nld_per_subscribers av_dist_km s_urban t_urban

*poisson 

poisson flow_nld_per_subscribers av_dist_km  t_occ_transport_sector_10 t_occ_ag_estates_10 t_occ_manu_mining_trades_10 s_rwi_norm t_rwi_norm s_urban t_urban s_young_adult_19_34 t_young_adult_19_34 s_yrschool, irr vce(cluster source_n)

*poisson no distance 
poisson flow_nld_per_subscribers  t_occ_transport_sector_10 t_occ_ag_estates_10 t_occ_manu_mining_trades_10 s_rwi_norm t_rwi_norm s_urban t_urban s_young_adult_19_34 t_young_adult_19_34 s_yrschool, exposure (nld_subscriber_count) vce(cluster source_n)

******************************************************************
* urban/rural for flow per subscribers 
******************************************************************

*urb > urb 
poisson flow_nld av_dist_km t_occ_transport_sector_10 t_occ_ag_estates_10 t_occ_manu_mining_trades_10 s_rwi_norm t_rwi_norm s_urban t_urban s_young_adult_19_34 t_young_adult_19_34 s_yrschool if urb_urb ==1, exposure (nld_subscriber_count) vce(cluster source_n) 

// among urban - urban, urbanity is not correlated with flow per subscribers

* rur > rur 
poisson flow_nld_per_subscribers av_dist_km  t_occ_transport_sector_10 t_occ_ag_estates_10 t_occ_manu_mining_trades_10 s_rwi_norm t_rwi_norm s_urban t_urban s_young_adult_19_34 t_young_adult_19_34 s_yrschool if rur_rur ==1, exposure (nld_subscriber_count) vce(cluster source_n) 

// rural to rural, the urbanity is not correlated with flow per subscribers

*urb > rur 
poisson flow_nld  av_dist_km  t_occ_transport_sector_10 t_occ_ag_estates_10 t_occ_manu_mining_trades_10 s_rwi_norm t_rwi_norm s_urban t_urban s_young_adult_19_34 t_young_adult_19_34 s_yrschool if urb_rur==1 , exposure (nld_subscriber_count) vce(cluster source_n) 

// for urban to rural, the more urban the target (among rural), the much greter the trips per subscriber 

* rural > urban
poisson flow_nld av_dist_km  t_occ_transport_sector_10 t_occ_ag_estates_10 t_occ_manu_mining_trades_10 s_rwi_norm t_rwi_norm s_urban t_urban s_young_adult_19_34 t_young_adult_19_34 s_yrschool if rur_urb ==1, exposure (nld_subscriber_count) vce(cluster source_n)

// for rural to urban, the more urban the target (among rural), the greater the trips per subscriber 


******************************************************************
**do the zero-inflated version 
******************************************************************

zip flow_nld_per_subscribers av_dist_km  t_occ_transport_sector_10 t_occ_ag_estates_10 t_occ_manu_mining_trades_10 s_rwi_norm t_rwi_norm s_ghsl_urb t_ghsl_urb s_young_adult_19_34 t_young_adult_19_34 s_yrschool, inflate(av_dist_km) irr

*version with census urbanity
zip flow_nld_per_subscribers av_dist_km  t_occ_transport_sector_10 t_occ_ag_estates_10 t_occ_manu_mining_trades_10 s_rwi_norm t_rwi_norm s_urban t_urban s_young_adult_19_34 t_young_adult_19_34 s_yrschool, inflate(av_dist_km) irr

// when accounting for distance, wards with more young adults at source have less trips between them

**one without a distance metric
zip flow_nld_per_subscribers  t_occ_transport_sector_10 t_occ_ag_estates_10 t_occ_manu_mining_trades_10 s_rwi_norm t_rwi_norm s_ghsl_urb t_ghsl_urb s_young_adult_19_34 t_young_adult_19_34 s_yrschool, inflate(av_dist_km) irr

// I think what these are both saying is that wards with more urbanity have less movement between them (push or pull), poorer areas will have less trips between them, but those which have a higher proportion of young adults at either source or destination will have more movement between them. 


*consider just urbanity 
zip flow_nld_per_subscribers s_ghsl_urb t_ghsl_urb, inflate(av_dist_km) irr

zip flow_nld_per_subscribers av_dist_km s_ghsl_urb t_ghsl_urb, inflate(av_dist_km) irr
// so the point is, that when distance is taken into account, being urban doesn't mean more flows between those wards, in fact, the relationship is negative, being an urban ward makes it less likely to see flows outbound 


** try a version with the number of trips per subscriber and with both target and destination variables for each 
poisson flow_nld_per_subscribers av_dist_km  t_occ_transport_sector_10 t_occ_ag_estates_10 t_occ_manu_mining_trades_10 s_rwi_norm t_rwi_norm s_ghsl_urb t_ghsl_urb s_young_adult_19_34 t_young_adult_19_34 s_yrschool, exposure (nld_subscriber_count) vce(cluster source_n) irr

** version with subscriber count as exposure term 
poisson flow_nld av_dist_km  t_occ_transport_sector_10 t_occ_ag_estates_10 t_occ_manu_mining_trades_10 s_rwi_norm t_rwi_norm s_ghsl_urb t_ghsl_urb s_young_adult_19_34 t_young_adult_19_34 s_yrschool, irr exposure (nld_subscriber_count) vce(cluster source_n)

// check t_young_adult_19_34 *** CHECK - but use count with offset 

*with all source and target vars 

poisson flow_nld_per_subscribers av_dist_km s_occ_transport_sector_10 s_occ_ag_estates_10 s_occ_manu_mining_trades_10 t_occ_transport_sector_10 t_occ_ag_estates_10 t_occ_manu_mining_trades_10 s_rwi_norm t_rwi_norm s_ghsl_urb t_ghsl_urb s_young_adult_19_34 t_young_adult_19_34 s_yrschool, exposure (nld_subscriber_count) vce(cluster source_n) irr

// TO DO: convert all the source variables in the regression to diff between source and target 

gen dif_urb = t_urban_761 - s_urban_761
gen dif_occ_trans_10 = t_occ_transport_sector_10 - s_occ_transport_sector_10 
gen dif_occ_ag_estates_10 = t_occ_ag_estates_10 - s_occ_ag_estates_10
gen dif_occ_manu_mining_10 = t_occ_manu_mining_trades_10 - s_occ_manu_mining_trades_10
gen dif_rwi = t_rwi_norm - s_rwi_norm  


** check all diffs 
poisson flow_nld av_dist  dif_urb dif_occ_trans_10  dif_occ_ag_estates_10 dif_occ_manu_mining_10  dif_rwi , exposure (nld_subscriber_count) vce(cluster source_n)

poisson flow_nld  dif_urb dif_occ_trans_10  dif_occ_ag_estates_10 dif_occ_manu_mining_10  dif_rwi , exposure (nld_subscriber_count) vce(cluster source_n)


codebook source if flow_nld !=. // 750 wards, but 14,723  move pairs

// * remove euclideandistance
// poisson flow_nld   t_occ_transport_sector t_occ_ag_estates t_occ_manu_mining_trades s_rwi_norm t_ghsl_urb s_young_adult_19_34 s_yrschool, exposure (excl_moves_from_source_nld)




// Note on ward counts: The original mobility data contained 761 aggregated wards which were aggregated from 1966 by Sveta's team. Wiki says there were 1,970 wards in 2023, and 1,200 wards in the earlier 2008 division. Either way, have now matched the larger number of wards to the smaller number of wards so everything in this analysis is at the 761 ward level. There are 750 unique wards in the analysis because of the reasons given in the mobility_chapter_ward_file_creation_761.do 
