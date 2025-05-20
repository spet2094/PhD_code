
* PURPOSE: Look at the correlates of mobility and changes in mobility between the OD matrix and census characteristics at the ward level


* USE THE COMBINED DATASET CREATED BEFORE 

tempfile temp1 temp2 temp3 temp4 temp5 temp6
cap cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/06_Data and Modelling/thesis_data/"

import delimited "combined_estimates/comb_761_wards_indiv_nld_ld.csv", clear

******************************************************************
** QUESTION 1: At the individual ward level, what socio-economic characteristics are associated with a higher number of outbound trips relative to its population? 
******************************************************************
//a.  prior to considering pandemic movement restrictions
******************************************************************

*clean off the wards with no movements 
drop if excl_moves_from_source_nld==0 
codebook source
hist excl_moves_from_source_nld // strong right skew means poisson
// 748 with nld movement data 

*some descriptives on high vs low mobility wards 
xtile count_leave_5_nld = excl_moves_from_source_nld, nq(5)
xtile count_leave_5_eld = excl_moves_from_source_eld, nq(5)
xtile count_leave_5_lld = excl_moves_from_source_lld, nq(5)

**nld
tabstat excl_moves_from_source_nld, by(count_leave_5_nld)
sum excl_moves_from_source_nld s_male_761 s_young_adult_19_34_10 s_urban s_rwi_norm s_occ4_ag_estates_761 s_occ4_manu_mining_trades_761  s_emp_emp s_emp_in_sch if count_leave_5_nld ==1

sum excl_moves_from_source_nld s_male_761 s_young_adult_19_34_10 s_urban s_rwi_norm s_occ4_ag_estates_761 s_occ4_manu_mining_trades_761  s_emp_emp s_emp_in_sch if count_leave_5_nld ==5

**eld 
tabstat excl_moves_from_source_eld, by(count_leave_5_nld)
sum excl_moves_from_source_eld s_male_761 s_young_adult_19_34_10 s_urban s_rwi_norm s_occ4_ag_estates_761 s_occ4_manu_mining_trades_761 s_emp_emp s_emp_in_sch if count_leave_5_eld ==1

sum excl_moves_from_source_eld s_male_761 s_young_adult_19_34_10 s_urban s_rwi_norm s_occ4_ag_estates_761 s_occ4_manu_mining_trades_761  s_emp_emp s_emp_in_sch if count_leave_5_eld ==5

***lld
tabstat excl_moves_from_source_lld, by(count_leave_5_nld)
sum excl_moves_from_source_lld s_male_761 s_young_adult_19_34_10 s_urban s_rwi_norm s_occ4_ag_estates_761 s_occ4_manu_mining_trades_761 s_emp_emp s_emp_in_sch if count_leave_5_lld ==1

sum excl_moves_from_source_lld s_male_761 s_young_adult_19_34_10 s_urban s_rwi_norm s_occ4_ag_estates_761 s_occ4_manu_mining_trades_761  s_emp_emp s_emp_in_sch if count_leave_5_lld ==5

codebook source if excl_moves_from_source_nld !=0 // We went from 761 --> minus 9 wards without cell towers to 752 --> minus 2 wards without pop data --> 750 --> minus 2 more with no nld counts 
codebook source if s_rwi_norm !=. 
codebook source if s_male_761 !=.


// BIVARIATE REG : is urbanity associated with more outbound movement?   

preserve

drop if nld_subscriber_count==0 

*census urban
poisson excl_moves_from_source_nld s_urban, robust exposure(nld_subscriber_count) irr 

*ghsl urban
poisson excl_moves_from_source_nld s_ghsl_urb, robust exposure(nld_subscriber_count) irr

*how about when we add poverty 
poisson excl_moves_from_source_nld s_urban s_rwi_norm, robust exposure(nld_subscriber_count) irr 
// it drops out

*because these are too highly correlated 

pwcorr s_urban s_rwi_norm

// ...in a bivariate reg, yes it is but then what happens when we add in other variables? 
******************************************************************
*poisson regressions 
******************************************************************

*census urban, no poverty
poisson excl_moves_from_source_nld s_male_10 s_young_adult_19_34_10 s_urban s_occ4_ag_estates_761_10 s_occ4_manu_mining_trades_761_10 s_emp_emp s_emp_in_sch, robust exposure (nld_subscriber_count) irr

est store ind_ward_reg, title(IndWardPoisson)
esttab ind_ward_reg using mobility/ward_level/tables/poissonIndWardUrb.csv, eform cells("b(fmt(2)) ci_l(fmt(2)) ci_u(fmt(2))  _star") title("Characteristics Associated with Ward Outbound Movement Non-lockdown -no poverty") label replace


*with poverty, no urban 
poisson excl_moves_from_source_nld s_male_10 s_young_adult_19_34_10 s_rwi_norm s_occ4_ag_estates_761_10 s_occ4_manu_mining_trades_761_10 s_emp_emp s_emp_in_sch, robust exposure (nld_subscriber_count) irr

est store ind_ward_reg, title(IndWardPoisson)
esttab ind_ward_reg using mobility/ward_level/tables/poissonIndWardPov.csv, eform cells("b(fmt(2)) ci_l(fmt(2)) ci_u(fmt(2)) _star") title("Characteristics Associated with Ward Outbound Movement Non-lockdown - no urbanity") label replace

*with both 
poisson excl_moves_from_source_nld s_male_10 s_young_adult_19_34_10 s_rwi_norm s_urban s_occ4_ag_estates_761_10 s_occ4_manu_mining_trades_761_10 s_emp_emp s_emp_in_sch, robust exposure (nld_subscriber_count) irr

est store ind_ward_reg, title(IndWardPoisson)
esttab ind_ward_reg using mobility/ward_level/tables/poissonIndWardAll.csv, eform cells("b(fmt(2)) ci_l(fmt(2)) ci_u(fmt(2)) _star") title("Characteristics Associated with Ward Outbound Movement Non-lockdown -urbanity & poverty") label replace


*ghsl urban 
poisson excl_moves_from_source_nld  s_male_10 s_young_adult_19_34_10 s_urban s_rwi_norm s_occ4_ag_estates_761_10 s_occ4_manu_mining_trades_761_10 s_emp_emp s_emp_in_sch, robust exposure (nld_subscriber_count) irr

// ...for both models, urbanity falls out of significance when considering the proportion of young adults (key factor), as well as poverty, proportion of agricultural workers and proportion of males. Those wards with a greater proportion of manufacturing working are also important 

*let's try a version which is trip counts per subscriber (no need for exposure term in this context)

poisson excl_trips_per_subscriber_nld  s_male_10 s_young_adult_19_34_10 s_urban s_rwi_norm s_occ4_ag_estates_761_10 s_occ4_manu_mining_trades_761_10 s_emp_emp s_emp_in_sch, robust irr

restore

******************************************************************
** QUESTION 2: What socio-economic characteristics were associated with a reduction in ward population outflow during the pandemic movement restrictions? 
******************************************************************

import delimited "combined_estimates/comb_761_wards_indiv_nld_ld.csv", clear


// subquestion is are the factors associated with leaving in early ld same as non lockdown? 
preserve 

******************************************************************
**early lockdown
******************************************************************
drop if eld_subscriber_count==0
*excluding urban
poisson excl_moves_from_source_eld   s_male_10 s_young_adult_19_34_10 s_rwi_norm s_occ4_ag_estates_761_10 s_occ4_manu_mining_trades_761_10 s_emp_emp s_emp_in_sch, robust exposure (eld_subscriber_count) irr

est store ind_ward_reg_eld, title(IndWardPoissoneLd)
esttab ind_ward_reg_eld using mobility/ward_level/tables/poissonIndWardPoveLd.csv, eform cells("b(fmt(2)) ci_l(fmt(2)) ci_u(fmt(2)) _star") title("Characteristics Associated with Ward Outbound Movement early lockdown - no urbanity") label replace

*excluding poverty 
poisson excl_moves_from_source_eld   s_male_10 s_young_adult_19_34_10 s_urban s_occ4_ag_estates_761_10 s_occ4_manu_mining_trades_761_10 s_emp_emp s_emp_in_sch, robust exposure (eld_subscriber_count) irr

est store ind_ward_reg_ld, title(IndWardPoissoneLd)
esttab ind_ward_reg_ld using mobility/ward_level/tables/poissonIndWardUrbeLd.csv, eform cells("b(fmt(2)) ci_l(fmt(2)) ci_u(fmt(2))  _star") title("Characteristics Associated with Ward Outbound Movement early lockdown -no poverty") label replace

*including both 
poisson excl_moves_from_source_eld   s_male_10 s_young_adult_19_34_10 s_rwi_norm s_urban s_occ4_ag_estates_761_10 s_occ4_manu_mining_trades_761_10 s_emp_emp s_emp_in_sch, robust exposure (eld_subscriber_count) irr

est store ind_ward_reg, title(IndWardPoisson)
esttab ind_ward_reg using mobility/ward_level/tables/poissonIndWardAlleLd.csv, eform cells("b(fmt(2)) ci_l(fmt(2)) ci_u(fmt(2))  _star") title("Characteristics Associated with Ward Outbound Movement early lockdown -both pov & urb") label replace

restore

******************************************************************
** late lockdown - what are the factors associated with reductions in movement in late lockdown? 
******************************************************************
drop if lld_subscriber_count==0

*excl urban

poisson excl_moves_from_source_lld   s_male_10 s_young_adult_19_34_10 s_rwi_norm s_occ4_ag_estates_761_10 s_occ4_manu_mining_trades_761_10 s_emp_emp s_emp_in_sch, robust exposure (lld_subscriber_count) irr

est store ind_ward_reg_lld, title(IndWardPoissonlLd)
esttab ind_ward_reg_lld using mobility/ward_level/tables/poissonIndWardPovlLd.csv, eform cells("b(fmt(2)) ci_l(fmt(2)) ci_u(fmt(2)) _star") title("Characteristics Associated with Ward Outbound Movement Late lockdown - no urbanity") label replace

*excl poverty 

poisson excl_moves_from_source_lld  s_male_10 s_young_adult_19_34_10 s_urban s_occ4_ag_estates_761_10 s_occ4_manu_mining_trades_761_10 s_emp_emp s_emp_in_sch, robust exposure (lld_subscriber_count) irr

est store ind_ward_reg_lld, title(IndWardPoissonlLd)
esttab ind_ward_reg_lld using mobility/ward_level/tables/poissonIndWardUrblLd.csv, eform cells("b(fmt(2)) ci_l(fmt(2)) ci_u(fmt(2))  _star") title("Characteristics Associated with Ward Outbound Movement late lockdown -no poverty") label replace

* incl  both 
poisson excl_moves_from_source_lld   s_male_10 s_young_adult_19_34_10 s_rwi_norm s_urban s_occ4_ag_estates_761_10 s_occ4_manu_mining_trades_761_10 s_emp_emp s_emp_in_sch, robust exposure (lld_subscriber_count) irr

est store ind_ward_reg, title(IndWardPoisson)
esttab ind_ward_reg using mobility/ward_level/tables/poissonIndWardAlllLd.csv, eform cells("b(fmt(2)) ci_l(fmt(2)) ci_u(fmt(2))  _star") title("Characteristics Associated with Ward Outbound Movement Late lockdown -both pov & urb") label replace

// removing ghsl because adding noise

// only having a high % of agricultural workers retains high significant association with leaving the ward, or a manu/mining worker

******************************************************************
*first note the difference between overall count of moves and moves per subscriber is very different 
******************************************************************
// Table 12 in thesis 

tabstat excl_moves_from_source_eld excl_moves_from_source_nld excl_moves_from_source_lld, stat(mean median sd min max n) columns (statistics) varwidth(30)

tabstat excl_trips_per_subscriber_eld excl_trips_per_subscriber_nld excl_trips_per_subscriber_lld, stat(mean median sd min max n) columns (statistics) varwidth(30)

tabstat diff_count_trips_nld_eld diff_count_trips_nld_lld diff_count_trips_eld_lld, stat(mean median sd min max n) columns (statistics) varwidth(30)

*all overlapping histograms are in python script Visualization of mobility data.ipynb

** factors associated with the difference in trips between early and non-lockdown (i.e. factors associated with the increase in moves). This has to be count, because the subscriber count fluctuates with each period and distorts the result, implying there were more trips per subscriber in late lockdown because less subscribers. However, when doing a regular poisson regression it needs to have non-negative values. Instead I can use negative binomial which will also handle overdispersion (sd greater than mean). But I cannot use negative values with nbreg in stata, so am transforming the diff counts with log

gen log_diff_counts_nld_eld = log(diff_count_trips_nld_eld +1)
sum log_diff_counts_nld_eld

nbreg log_diff_counts_nld_eld s_male_10 s_young_adult_19_34_10 s_urban s_rwi_norm s_occ4_ag_estates_761_10 s_occ4_manu_mining_trades_761_10 s_emp_emp s_emp_in_sch, robust irr

est store ind_ward_diff, title(IndWardDiff)
esttab ind_ward_diff using mobility/ward_level/tables/poissonIndWardDiffEldNldCounts.csv, cells("b(fmt(2)) ci_l(fmt(2)) ci_u(fmt(2)) _star") title("Characteristics Associated with Increases in Ward Outbound Trips from Non-lockdown to Early Lockdown - Counts") label replace


** factors associated with the drop between nld - ld 

gen log_diff_counts_nld_lld = log(diff_count_trips_nld_lld +1)
sum log_diff_counts_nld_lld 

nbreg log_diff_counts_nld_lld s_male_10 s_young_adult_19_34_10 s_urban s_rwi_norm s_occ4_ag_estates_761_10 s_occ4_manu_mining_trades_761_10 s_emp_emp s_emp_in_sch, robust irr


est store ind_ward_diff, title(IndWardDiff)
esttab ind_ward_diff using mobility/ward_level/tables/poissonIndWardDiffNldLldCounts.csv, cells("b(fmt(2)) ci_l(fmt(2)) ci_u(fmt(2)) _star") title("Characteristics Associated with Reductions in Ward Outbound Trips from Non-lockdown to Lockdown - Counts") label replace

*below not using, just included to remind me why I didn't use it
// reg diff_trips_nld_lld_per_sub  s_male_10 s_young_adult_19_34_10 s_urban s_rwi_norm s_occ4_ag_estates_761_10 s_occ4_manu_mining_trades_761_10 s_emp_emp s_emp_in_sch, robust 

// wards with a greater proportion of men are likely to see more people leaving
// shapley2, stat(r2)

// only able to do poissons because of log conversion, but loosing too many observations to be meaningful, so makes more sense to look at periods individually. Normal regression on per subscriber moves diff not good because of issues with diff var.

// asdoc margins , replace save(mobility/ward_level/tables/margins_diff) abb(.) 
// asdoc margins i.s_male_761, append save(mobility/ward_level/tables/margins_diff) abb(.) 
// asdoc margins i.s_young_adult_19_34_10, append save(mobility/ward_level/tables/margins_diff) abb(.)
// asdoc margins i.s_urban, append save(mobility/ward_level/tables/margins_diff) abb(.)
// asdoc margins i.s_rwi_norm, append save(mobility/ward_level/tables/margins_diff) abb(.)  
// asdoc margins i.s_occ4_ag_est, append save(mobility/ward_level/tables/margins_diff) abb(.)
// asdoc margins i.s_occ4_manu_m, append save(mobility/ward_level/tables/margins_diff) abb(.)
// asdoc margins i.s_emp_emp, append save(mobility/ward_level/tables/margins_diff) abb(.)
// asdoc margins i.s_emp_in_sch, append save(mobility/ward_level/tables/margins_diff) abb(.)

// this margins command doesn't work for some reason it says 'factor variables may not contain non-integer values' (this was with reg)

