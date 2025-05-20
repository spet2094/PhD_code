
clear all

cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/08_Fieldwork/08_Data/R8_data/"
tempfile temp1

tempfile temp1

*Purpose: answer Q1 and Q2 of data analysis on social contacts 

use "raw/IVQ_R8_renamed.dta", clear

**super helpful command that adds the numbers to the value labels
label dir
numlabel `r(names)', add

**merge in weights 
sort hhmem_key 

merge 1:1 hhmem_key using "stata_input/IVQ_HHQ_R8_weighted.dta"
drop _merge

save `temp1'


*rename gender 
rename q202 gender 
* label male female
la def gender 1 "male" 2 "female"
la val gender gender
* generate more disaggregated age categories
gen age_5 = .
replace age_5 = 1 if age <15 & age !=.
replace age_5 = 1 if age >=15 & age <=29 & age !=. 
replace age_5 = 2 if age >=30 & age <=44 & age !=. 
replace age_5 = 3 if age >=45 & age <=64 & age !=.
replace age_5 = 4 if age >=65 & age !=. 
tab age_5, m

label define age_5 1"15-29 yrs" 2 "30-44 yrs" 3 "45-64 yrs" 4 "65+ yrs"

label values age_5 age_5

tab occupation

*generate more grouped occupations
gen occ_2 = 1 if inlist(occupation, 1,2)
replace occ_2 = 2 if inlist(occupation, 4,10)
replace occ_2 = 3 if inlist(occupation,11,18)
replace occ_2 = 4 if inlist(occupation,3,6,7,16)
replace occ_2 = 5 if inlist(occupation, 15)
replace occ_2 = 6 if inlist(occupation, 8)
replace occ_2 = 7 if inlist(occupation, 9, 17)
la define oc2 1 "manual labor" 2 "students or teachers" 3 "not employed or homemakers" 4 "workers - retail or public service" 5 "office workers" 6 "informal trading" 7 "other informal"

la values occ_2 oc2 

****Mutare, Mutasa, Nyanga, Makoni, Chimanimani, Buhera and Chipinge are the districts 

*********************************************************************************
******************************Generating Locals and Globals **********************
*********************************************************************************


*Lockdown contacts cleaning contact variables 

global ld_work_week ld_work_wku15 ld_work_wk15_44 ld_work_wk45_64 ld_work_wk65plus
local ld_work_we ld_work_weu15 ld_work_we15_44 ld_work_we45_64 ld_work_we65plus

global ld_school_week ld_school_wku15 ld_school_wk15_44 ld_school_wk45_64 ld_school_wk65plus
local ld_school_we ld_school_weu15 ld_school_we15_44 ld_school_we45_64 ld_school_we65plus

global ld_trans_week ld_trans_wku15 ld_trans_wk15_44 ld_trans_wk45_64 ld_trans_wk65plus
global ld_trans_we ld_trans_weu15 ld_trans_we15_44 ld_trans_we45_64 ld_trans_we65plus

global ld_ent_week ld_ent_wku15 ld_ent_wk15_44 ld_ent_wk45_64 ld_ent_wk65plus
global ld_ent_we ld_ent_weu15 ld_ent_we15_44 ld_ent_we45_64 ld_ent_we65plus

global ld_other_week ld_other_wku15 ld_other_wk15_44 ld_other_wk45_64 ld_other_wk65plus
global ld_other_we ld_other_weu15 ld_other_we15_44 ld_other_we45_64 ld_other_we65plus

global ld_home_week ld_home_wku15 ld_home_wk15_44 ld_home_wk45_64 ld_home_wk65plus
global ld_home_we ld_home_weu15 ld_home_we15_44 ld_home_we45_64 ld_home_we65plus


local ld_contact_vars ld_work_wku15 ld_work_wk15_44 ld_work_wk45_64 ld_work_wk65plus ld_work_weu15 ld_work_we15_44 ld_work_we45_64 ld_work_we65plus ld_school_wku15 ld_school_wk15_44 ld_school_wk45_64 ld_school_wk65plus ld_school_weu15 ld_school_we15_44 ld_school_we45_64 ld_school_we65plus ld_trans_wku15 ld_trans_wk15_44 ld_trans_wk45_64 ld_trans_wk65plus ld_trans_weu15 ld_trans_we15_44 ld_trans_we45_64 ld_trans_we65plus ld_home_wku15 ld_home_wk15_44 ld_home_wk45_64 ld_home_wk65plus ld_home_weu15 ld_home_we15_44 ld_home_we45_64 ld_home_we65plus ld_ent_wku15 ld_ent_wk15_44 ld_ent_wk45_64 ld_ent_wk65plus ld_ent_weu15 ld_ent_we15_44 ld_ent_we45_64 ld_ent_we65plus ld_other_wku15 ld_other_wk15_44 ld_other_wk45_64 ld_other_wk65plus ld_other_weu15 ld_other_we15_44 ld_other_we45_64 ld_other_we65plus

*let's make a local of the summary variables 
global summary_vars_ld ld_all_ages_contacts_week ld_all_ages_contacts_we ld_all_ages_contacts_7days nld_all_ages_contacts_week nld_all_ages_contacts_we nld_all_ages_contacts_7days

*locals of the cbo variables 
local contacts_av_by_occ ld_av_cbo_overall nld_av_cbo_overall ld_av_cbo_wk nld_av_cbo_wk ld_av_cbo_we nld_av_cbo_we ld_av_cbo_work_wk nld_av_cbo_work_wk ld_av_cbo_sch_wk nld_av_cbo_sch_wk ld_av_cbo_home_wk nld_av_cbo_home_wk ld_av_cbo_trans_wk nld_av_cbo_trans_wk  ld_av_cbo_ent_wk nld_av_cbo_ent_wk

local contacts_med_by_occ ld_med_cbo_overall nld_med_cbo_overall ld_med_cbo_wk nld_med_cbo_wk ld_med_cbo_we nld_med_cbo_we ld_med_cbo_work_wk nld_med_cbo_work_wk ld_med_cbo_sch_wk nld_med_cbo_sch_wk ld_med_cbo_home_wk nld_med_cbo_home_wk ld_med_cbo_trans_wk nld_med_cbo_trans_wk ld_med_cbo_ent_wk nld_med_cbo_ent_wk


**week all ages of contacts by place 

local ld_all_ages_wk tot_contacts_work_wk_ld tot_contacts_school_wk_ld tot_contacts_home_wk_ld tot_contacts_trans_wk_ld tot_contacts_ent_wk_ld ld_all_ages_contacts_week

local nld_all_ages_wk tot_contacts_work_wk_nld tot_contacts_school_wk_nld tot_contacts_home_wk_nld tot_contacts_trans_wk_nld tot_contacts_ent_wk_nld nld_all_ages_contacts_week

** weekend all ages of contacts by place

local ld_all_ages_we tot_contacts_work_we_ld tot_contacts_school_we_ld tot_contacts_home_we_ld tot_contacts_trans_we_ld tot_contacts_ent_we_ld ld_all_ages_contacts_we

local nld_all_ages_we tot_contacts_work_we_nld tot_contacts_school_we_nld tot_contacts_home_we_nld tot_contacts_trans_we_nld tot_contacts_ent_we_nld nld_all_ages_contacts_we

*local of relevant vars (mixed from week and weekend for ent)
local all_ages_mix tot_contacts_work_wk_ld tot_contacts_work_wk_nld tot_contacts_school_wk_ld tot_contacts_school_wk_nld tot_contacts_home_wk_ld  tot_contacts_home_wk_nld tot_contacts_trans_wk_ld tot_contacts_trans_wk_nld tot_contacts_ent_we_ld tot_contacts_ent_we_nld

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


**************************************************************
	/*Last bit of cleaning*/
**************************************************************
*check school age population vs. contacts
gen enrolled_school = .
replace enrolled_school = 1 if q205=="1"
replace enrolled_school = 0 if q205=="2"


*treat school missing separately
qui ds ld_school_*  
foreach var in `r(varlist)' {
	
	tab `var' 
	*PLACE level
	gen place_`var' = `var'
	replace place_`var' = . if occ_2 !=2
	// first of all, making sure to limit the population to just school goers
	replace place_`var' = . if inlist(`var',99, 990, 98,988, 998,  9699, 9999, 994, 984)
	// 98=don't know , 99 and variants = don't go to school i.e. NA
	replace place_`var' = 0 if inlist(`var', 998, 988) & enrolled_school==1
	// 998= normally go to school but schools are closed (Shouldn't apply for nld)
	
	*POPULATION level version i.e. they are enrolled in school, but they choose not to go, so they have zero contacts, because they are still in the school population 
	gen pop_`var'=`var'
	replace pop_`var' = 0 if inlist(`var',99, 990, 98,988, 998, 9699, 9999, 994, 984)
	// in the population level you would count these 998 variants as zeros, because they would reduce the contact numbers for anyone who did go to school 
	replace pop_`var' = 0 if inlist(`var', 998, 988) & enrolled_school==1
	// 998= normally go to school but schools are closed (here it's population level so zero)
}

*ent, trans,home, work and other missings 

qui ds ld_work_*
foreach var in `r(varlist)' {
	tab `var' if inlist(`var', 999,990,9999,998,98)
	*generate a place level version (i.e. numbers among only those who went to work)
	gen m_`var' = `var'
	replace m_`var' = . if inlist(`var', 98, 998, 99, 999, 9999, 990, 992)
	
	*create the zeros version (population level)
	replace `var' = . if inlist(`var', 98, 998) // don't know the number of contacts
	replace `var' = 0 if inlist(`var', 99, 999, 9999, 990, 992) 
	// don't go to work - population level zero
}

qui ds ld_trans_*
foreach var in `r(varlist)' {
	tab `var' if inlist(`var', 999,990,9999,998,98)
	*generate a place level version (i.e. numbers among only those who used transport)
	gen m_`var' = `var'
	replace m_`var' = . if inlist(`var', 98, 998, 99, 999, 9999, 990)
	
	*create the zeros version (population level)
	replace `var' = . if inlist(`var', 98, 998) // don't know the number of contacts
	replace `var' = 0 if inlist(`var', 99, 999, 9999, 990) 
	// don't go to work - population level zero
}

qui ds ld_ent_* ld_other_*
foreach var in `r(varlist)' {
	tab `var' if `var' >=99
	*generate a place level version (i.e. numbers among only those who go to bars)
	gen m_`var' = `var'
	replace m_`var' = . if inlist(`var', 98, 998, 99, 999, 9999, 990)
	
	*create the zeros version (population level)
	replace `var' = . if inlist(`var', 98, 998, 899) // don't know the number of contacts
	replace `var' = 0 if inlist(`var', 99, 999, 9999, 990) 
	// don't go to entertainment venues - population level zero
}

qui ds ld_home_* // 
foreach var in `r(varlist)' {
	tab `var' if `var'>=99
	*generate a place level version (i.e. we assume that 99 meant they didn't specify a response to contacts at home)
	gen m_`var' = `var'
	replace m_`var' = . if inlist(`var', 99,999,9999) 

	*create the zeros version (population level)
	replace `var' = 0 if inlist(`var', 99,999,9999) 
	// we assume that the 99 here means they are living alone - population level zero
}



**************************************************************
	** Non-Lockdown contacts (before)
**************************************************************

*Discussed multiple times about counting the zeros in contacts by place. For the model, we can use the version with all zeros as missings (PLACE level, those starting m_). For the paper,  we will keep the zeros as zeros because it will bring down the average number of contacts in each place i.e. it will be at the POPULATION level, not the place level. 

*treat school missing separately
qui ds nld_school_*  
foreach var in `r(varlist)' {
	
	tab `var' 
	*PLACE level
	gen place_`var' = `var'
	replace place_`var' = . if occ_2 !=2
	// first of all, making sure to limit the population to just school goers
	replace place_`var' = . if inlist(`var',99, 990, 98,988, 998,  9699, 9999, 994, 984)
	// 98=don't know , 99 and variants = don't go to school i.e. NA
	replace place_`var' = 0 if inlist(`var', 998, 988) & enrolled_school==1
	// 998= normally go to school but schools are closed (Shouldn't apply for nld)
	
	*POPULATION level version i.e. they are enrolled in school, but they choose not to go, so they have zero contacts, because they are still in the school population 
	gen pop_`var'=`var'
	replace pop_`var' = 0 if inlist(`var',99, 990, 98,988, 998, 9699, 9999, 994, 984)
	// in the population level you would count these 998 variants as zeros, because they would reduce the contact numbers for anyone who did go to school 
	replace pop_`var' = 0 if inlist(`var', 998, 988) & enrolled_school==1
	// 998= normally go to school but schools are closed (Shouldn't apply for nld)
}

fsum place_nld_school* pop_nld_school*
// now they are different, seems better
fsum place_ld_school* pop_ld_school* place_nld_school* pop_ld_school*

*ent, trans,home, work and other missings 

qui ds nld_work_*
foreach var in `r(varlist)' {
	tab `var' if inlist(`var', 99,999,990,9999,998,98)
	
	*generate a place level version (i.e. numbers among only those who went to work)
	gen m_`var' = `var'
	replace m_`var' = . if inlist(`var', 98, 998, 99, 999, 9999, 990, 9960, 969)
	
	*create the zeros version (population level)
	replace `var' = . if inlist(`var', 98, 998) // don't know the number of contacts
	replace `var' = 0 if inlist(`var', 99, 999, 9999, 990, 9960, 969) 
	replace `var' = 0 if `var' == . & inlist(occupations, 11, 77)
	// don't go to work - population level zero
}

qui ds nld_trans_*
foreach var in `r(varlist)' {
	tab `var' if inlist(`var', 999,990,9999,998,98)
	
	*generate a place level version (i.e. numbers among only those who used transport)
	gen m_`var' = `var'
	replace m_`var' = . if inlist(`var', 98, 998, 99, 999, 9999, 990, 9898, 995)
	
	*create the zeros version (population level)
	replace `var' = . if inlist(`var', 98, 998) // don't know the number of contacts
	replace `var' = 0 if inlist(`var', 99, 999, 9999, 990, 9898, 995) 
	// don't go to work - population level zero
}

qui ds nld_ent_* nld_other_*
foreach var in `r(varlist)' {
	tab `var' if `var' >=99
	*generate a place level version (i.e. numbers among only those who go to bars)
	gen m_`var' = `var'
	replace m_`var' = . if inlist(`var', 98, 998, 99, 999, 9999, 990, 993)
	
	*create the zeros version (population level)
	replace `var' = . if inlist(`var', 98, 998) // don't know the number of contacts
	replace `var' = 0 if inlist(`var', 99, 999, 9999, 990, 993) 
	// don't go to entertainment venues - population level zero
}

qui ds nld_home_* // 
foreach var in `r(varlist)' {
	tab `var' if `var'>=99
	*generate a place level version (i.e. we assume that 99 meant they didn't specify a response to contacts at home)
	gen m_`var' = `var'
	replace m_`var' = . if `var'== 99

	*create the zeros version (population level)
	replace `var' = 0 if `var'== 99 
	// we assume that the 99 here means they are living alone - population level zero
}

*just check the missings after cleaning, for those that are legit missing across places
qui ds nld_home_wk* nld_work_wk* nld_trans_wk* nld_ent_we* nld_school_wk* 
foreach var in `r(varlist)' {
	misstable summarize `var' 
}

*check the outliers after cleaning 


qui ds ld_home* ld_school* ld_work_* ld_trans_* ld_ent*
foreach var in `r(varlist)'{
	tab `var' if `var' >200
}

qui ds nld_home* nld_school* nld_work_* nld_trans_* nld_ent*
foreach var in `r(varlist)'{
	tab `var' if `var' >200
}

**************************************************************
* CONTACTS by Age group of contacts *

**************************************************************
*generate the TOTAL number of contacts by INDIVIDUAL in each age group of contacts during the week and at weekends

*weekdays
egen ld_all_u15_contacts_wk = rowtotal(`u15_contacts_wk_ld'), m
egen nld_all_u15_contacts_wk = rowtotal(`u15_contacts_wk_nld') , m
egen ld_all_15_44_contacts_wk = rowtotal(`a15_44_contacts_wk_ld'), m
egen nld_all_15_44_contacts_wk = rowtotal(`a15_44_contacts_wk_nld'), m
egen ld_all_45_64_contacts_wk = rowtotal(`a45_64_contacts_wk_ld'), m
egen nld_all_45_64_contacts_wk = rowtotal(`a45_64_contacts_wk_nld'), m
egen ld_all_65_plus_contacts_wk = rowtotal(`a65_plus_contacts_wk_ld'), m
egen nld_all_65_plus_contacts_wk = rowtotal(`a65_plus_contacts_wk_nld'), m


// making sure to always specify ',m' because this gives missing if all contacts are missing on that group 

*do weekends later 

**************************************************************
* CONTACTS BY ALL AGES PER INDIVIDUAL*

**************************************************************


*** GENERATE THE 200 CUT OFFS FOR EACH PLACE otherwise it doesn't make sense we have a 200 cut off only on the aggregate

qui ds ld_work_wk* pop_ld_school_wk* place_ld_school* ld_trans_wk* ld_home_wk* ld_ent_we* ld_other_wk* 
foreach var in `r(varlist)'{
	replace `var' = . if `var' >200
}

****** LOCKDOWN NUMBERS 
*generate the TOTAL number of contacts by INDIVIDUAL during the week and at weekends

* for weekdays, including all places, during lockdown 
egen ld_all_ages_contacts_week = rowtotal(ld_work_wk* pop_ld_school_wk* ld_trans_wk* ld_home_wk* ld_ent_wk* ld_other_wk*), m

// missings version
egen m_ld_all_ages_contacts_week = rowtotal(m_ld_work_wk* place_ld_school_wk* m_ld_trans_wk* m_ld_home_wk* m_ld_ent_wk* m_ld_other_wk*), m

* for weekends, including all places, during lockdown 
egen ld_all_ages_contacts_we = rowtotal(ld_work_we* pop_ld_school_we* ld_trans_we* ld_home_we* ld_ent_we* ld_other_we*), m

* for weekdays and weekends
egen ld_all_ages_contacts_7days = rowtotal(ld_all_ages_contacts_week ld_all_ages_contacts_we), m

***********************************************************************
**** have tested if it makes any difference for the row totals (all except home have z_) -- it doesn't, so the totals are the same and don't need to generate the z_ versions for them 
***********************************************************************

* generate the total number of contacts by SPACE in the week and at weekends ACROSS ALL AGES per INDIVIDUAL 

egen tot_contacts_work_wk_ld = rowtotal(ld_work_wk*), m
egen m_tot_contacts_work_wk_ld = rowtotal(m_ld_work_wk*), m

egen tot_contacts_work_we_ld = rowtotal(ld_work_we*), m

egen tot_contacts_home_wk_ld = rowtotal(ld_home_wk*), m
egen m_tot_contacts_home_wk_ld = rowtotal(m_ld_home_wk*), m

egen tot_contacts_home_we_ld = rowtotal(ld_home_we*), m

egen tot_contacts_trans_wk_ld = rowtotal(ld_trans_wk*), m
egen m_tot_contacts_trans_wk_ld = rowtotal(m_ld_trans_wk*), m

egen tot_contacts_trans_we_ld = rowtotal(ld_trans_we*), m

egen tot_contacts_ent_wk_ld = rowtotal(ld_ent_wk*), m

egen tot_contacts_ent_we_ld = rowtotal(ld_ent_we*),m
egen m_tot_contacts_ent_we_ld = rowtotal(m_ld_ent_we*),m

sum ld_work_wk* ld_school_wk* ld_trans_wk* ld_home_wk* ld_ent_wk* ld_other_wk* 
sum tot_contacts_*_wk_ld m_tot_contacts_*_wk_ld


*for school goers, they can also have a population level one this first one is place level
egen pop_tot_contacts_school_wk_ld = rowtotal(pop_ld_school_wk*), m
egen pop_tot_contacts_school_we_ld = rowtotal(pop_ld_school_we*), m

egen place_tot_contacts_school_wk_ld = rowtotal(place_ld_school_wk*), m
egen place_tot_contacts_school_we_ld = rowtotal(place_ld_school_we*), m


*if occupation is a teacher, their work is the same as school, so their contacts should only be listed for one not both (avoid double counting)
replace tot_contacts_work_wk_ld=pop_tot_contacts_school_wk_ld if inlist(tot_contacts_work_wk_ld,.,0) & occupation ==4
replace pop_tot_contacts_school_wk_ld = 0 if occupation ==4

***************************************************
*do the same for missings one 
replace m_tot_contacts_work_wk_ld=pop_tot_contacts_school_wk_ld if inlist(m_tot_contacts_work_wk_ld,.,0) & occupation ==4

*********************************************************************
****** NON- LOCKDOWN NUMBERS 
***********************************************************************

*** GENERATE THE 200 CUT OFFS FOR EACH PLACE otherwise it doesn't make sense we have a 200 cut off only on the aggregate
qui ds nld_work_wk* place_nld_school_wk* pop_nld_school_wk* nld_trans_wk* nld_home_wk* nld_ent_wk* nld_other_wk* 
foreach var in `r(varlist)'{
	replace `var' = . if `var' >200
}


*generate the TOTAL number of contacts by INDIVIDUAL during the week and at weekends

* for weekdays, including all places, before lockdown 
egen nld_all_ages_contacts_week = rowtotal(nld_work_wk* place_nld_school_wk* nld_trans_wk* nld_home_wk* nld_ent_wk* nld_other_wk*), m

// drop if nld_all_ages_contacts_week >720 // 55 obs at this point

*** version with missings 
egen m_nld_all_ages_contacts_week = rowtotal(m_nld_work_wk* nld_school_wk* m_nld_trans_wk* m_nld_home_wk* m_nld_ent_wk* m_nld_other_wk*), m

* for weekends, including all places, before lockdown 
egen nld_all_ages_contacts_we = rowtotal(nld_work_we* nld_school_we* nld_trans_we* nld_home_we* nld_ent_we* nld_other_we*), m

* for weekdays and weekends
gen nld_all_ages_contacts_7days = nld_all_ages_contacts_week + nld_all_ages_contacts_we

* generate the TOTAL number of contacts by SPACE in the week and at weekends ACROSS ALL AGES per INDIVIDUAL 

egen tot_contacts_work_wk_nld = rowtotal(nld_work_wk*), m 
egen m_tot_contacts_work_wk_nld = rowtotal(m_nld_work_wk*), m 

// have checked this encapsulates all ages and is the same as listing out each age category as per this code so the rest have been changed to shortened version
//egen tot_contacts_work_wk_nld_test = rowtotal(nld_work_wku15 nld_work_wk15_44 nld_work_wk45_64 nld_work_wk65plus)

egen tot_contacts_work_we_nld = rowtotal(nld_work_we*), m
egen m_tot_contacts_work_we_nld = rowtotal(m_nld_work_we*), m

egen place_tot_contacts_school_wk_nld = rowtotal(place_nld_school_wk*), m
egen pop_tot_contacts_school_wk_nld = rowtotal(pop_nld_school_wk*), m

*make sure that the non-school population gets 

sum place_tot_contacts_school_wk_nld pop_tot_contacts_school_wk_nld
sum place_tot_contacts_school_wk_ld pop_tot_contacts_school_wk_ld


// originally this generates 2136 obs
// when we limit it to just those registered as students it drops to 770 
// when we remove values over 720 and do additional cleaning it drops to 761 (L474), and to 200 it reduces to 691

egen tot_contacts_school_we_nld = rowtotal(nld_school_we*), m

egen tot_contacts_home_wk_nld = rowtotal(nld_home_wk*), m
egen m_tot_contacts_home_wk_nld = rowtotal(m_nld_home_wk*), m

egen tot_contacts_home_we_nld = rowtotal(nld_home_we*), m

egen tot_contacts_trans_wk_nld = rowtotal(nld_trans_wk*), m
egen m_tot_contacts_trans_wk_nld = rowtotal(m_nld_trans_wk*), m

egen tot_contacts_trans_we_nld = rowtotal(nld_trans_we*), m

egen tot_contacts_ent_wk_nld = rowtotal(nld_ent_wk*), m

egen tot_contacts_ent_we_nld = rowtotal(nld_ent_we*), m
egen m_tot_contacts_ent_we_nld = rowtotal(m_nld_ent_we*), m


******************************************************************************************
** again so that it makes sense on the table, I need to re-correct the tot_contact variables

qui ds m_tot_contacts_* tot_contacts_* pop_tot_contacts_* place_tot_contacts_*
foreach var in `r(varlist)'{
	replace `var' = . if `var' >200
	
} 
fsum m_tot_contacts_*_wk_* tot_contacts_*_wk_* pop_tot_contacts_*_wk_* place_tot_contacts_*_wk_*


**************************************************************
	*CONTACTS by PLACE - additional cleaning * - replace missing totals with zeros where the totals are missing for ld but not nld 
******************************************************************************


*generate loop but treat entertainment separately 
foreach x in home work trans {
	gen miss_`x' = 1 if tot_contacts_`x'_wk_ld==. & tot_contacts_`x'_wk_nld !=. 
	tab miss_`x' // h=931; work=348; school=496; trans=1077
	replace tot_contacts_`x'_wk_ld = 0 if miss_`x' ==1 
	codebook tot_contacts_`x'_wk_ld
}

* * For entertainment (weekend)
codebook  tot_contacts_ent_we_nld tot_contacts_ent_we_ld
gen miss_e = 1 if tot_contacts_ent_we_ld==. & tot_contacts_ent_we_nld !=. // 
tab miss_e // 364
replace tot_contacts_ent_we_ld= 0 if miss_e ==1 

** do the same for all contacts everywhere 
codebook ld_all_ages_contacts_week nld_all_ages_contacts_week
gen miss_all = 1 if ld_all_ages_contacts_week==. & nld_all_ages_contacts_week !=.
tab miss_all
replace ld_all_ages_contacts_week = 0 if miss_all ==1


 ************************Merge in socio-economic characteristics and lockdown dates ***********************
 
 sort hhmem_key
 
  *cleaning code from Rebekah
replace hhmem_key=1401295802 if hhmem_key==1400354802
replace hhmem_key=1401295801 if hhmem_key==1400354801
replace hhmem_key=709953803 if hhmem_key==709933803
replace hhmem_key=709950801 if hhmem_key==709901801
replace hhmem_key=709949802 if hhmem_key==709900802
 
 save `temp1', replace
 
 use "stata_input/submissiondates&ses.dta", clear 

 sort hhmem_key 
 
 merge 1:1 hhmem_key using `temp1'
 keep if _merge==3
 
 
**************************************************************
	/*generate pre lockdown and lockdown time variables*/
**************************************************************

gen double date = Clock(submissiondate, "MDYhms")
format date %tc

gen dmy = dofc(date)
format dmy %td

* pre march 2021 was strict lockdown 
gen strict_ld = cond(dmy < td(1mar2021),1,0)
// only 15 obs were before 1st march so not really worth analysing 

**************************************************************
	*Generate the differences between pre-post lockdown numbers*
******************************************************************

*first clean off the outliers <200

replace ld_all_ages_contacts_week = 200 if ld_all_ages_contacts_week  >200
replace nld_all_ages_contacts_week = 200 if nld_all_ages_contacts_week  >200
replace m_ld_all_ages_contacts_week = 200 if m_ld_all_ages_contacts_week  >200
replace m_nld_all_ages_contacts_week = 200 if m_nld_all_ages_contacts_week  >200


* ld - nld overall 
gen diff_all_places_wk_ld = ld_all_ages_contacts_week - nld_all_ages_contacts_week
la var diff_all_places_wk_ld "difference in sum of all contacts by place weekdays exc ent ld-nld"



* ld - nld home 
gen diff_home_wk_ld = tot_contacts_home_wk_ld - tot_contacts_home_wk_nld

* ld - nld school
gen diff_sch_wk_ld = pop_tot_contacts_school_wk_ld - pop_tot_contacts_school_wk_nld

* ld - nld work 
gen diff_work_wk_ld = tot_contacts_work_wk_ld - tot_contacts_work_wk_nld

* ld - nld entertainment 
gen diff_ent_we_ld = tot_contacts_ent_we_ld - tot_contacts_ent_we_nld

* ld - nld transport 
gen diff_trans_wk_ld = tot_contacts_trans_wk_ld - tot_contacts_trans_wk_nld

************** version by place

* ld - nld overall 
gen m_diff_all_places_wk_ld = m_ld_all_ages_contacts_week - m_nld_all_ages_contacts_week
la var m_diff_all_places_wk_ld "difference in sum of all contacts by place weekdays exc ent ld-nld"

replace m_diff_all_places_wk_ld = . if ld_all_ages_contacts_week ==.

sum m_diff_all_places_wk_ld diff_all_places_wk_ld

* ld - nld home 
gen m_diff_home_wk_ld = m_tot_contacts_home_wk_ld - m_tot_contacts_home_wk_nld

* ld - nld school
gen m_diff_sch_wk_ld = place_tot_contacts_school_wk_ld - place_tot_contacts_school_wk_nld


* ld - nld work 
gen m_diff_work_wk_ld = m_tot_contacts_work_wk_ld - m_tot_contacts_work_wk_nld

* ld - nld entertainment 
gen m_diff_ent_we_ld = m_tot_contacts_ent_we_ld - m_tot_contacts_ent_we_nld

* ld - nld transport 
gen m_diff_trans_wk_ld = m_tot_contacts_trans_wk_ld - m_tot_contacts_trans_wk_nld


*export a version with all the extra vars for the plots 

xtile ses_5 = ses, nq(5)


*just check the missings after cleaning, for those that are legit missing across places
 
foreach x in home work trans {
		misstable summarize tot_contacts_`x'_wk_nld if wgt_inv !=.
}

misstable summarize tot_contacts_ent_we_nld if wgt_inv !=.

format hhmem_key %13.0f 
save "stata_input/IVQ_R8_newVars_200cutoff.dta", replace


*generate dummy one for Robbie
sort hhmem_key
keep if hhmem_key <=200445705
save "stata_input/IVQ_R8_newVars_dummy_subset.dta", replace

******* Think about it before we make it long, what we already have

use "stata_input/IVQ_R8_newVars.dta", clear
 

keep hhmem_key gender occupation ses ses_5 site_type age age_5 tot_contacts_home_wk_ld tot_contacts_home_wk_nld tot_contacts_school_wk_ld tot_contacts_school_wk_nld tot_contacts_work_wk_ld tot_contacts_work_wk_nld tot_contacts_trans_wk_ld tot_contacts_trans_wk_nld tot_contacts_ent_we_ld tot_contacts_ent_we_nld nld_all_ages_contacts_week ld_all_ages_contacts_week  diff_home_wk_ld diff_sch_wk_ld diff_work_wk_ld diff_ent_we_ld diff_trans_wk_ld diff_all_places_wk_ld

save "stata_input/IVQ_R8_wide_contacts_only.dta", replace

* generate a dataset just by place (for lockdown) -- copy for non-lockdown
expand 10
sort hhmem_key
order hhmem_key gender age age_5 occupation site  tot_contacts_home_wk_ld tot_contacts_work_wk_ld tot_contacts_school_wk_ld tot_contacts_trans_wk_ld tot_contacts_ent_we_ld tot_contacts_home_wk_nld tot_contacts_work_wk_nld tot_contacts_school_wk_nld tot_contacts_trans_wk_nld tot_contacts_ent_we_nld

egen place_ld_stat = seq(), f(1) t(10)
la def place_ld_stat 1 "ld - home" 2 "ld - work" 3 "ld - school" 4 "ld - transport" 5 "ld - entertainment" 6 "nld - home" 7 "nld - work" 8 "nld - school" 9 "nld - transport" 10 "nld - entertainment"
label values place_ld_stat place_ld_stat

gen contacts_in_place_ld = .
replace contacts_in_place_ld = tot_contacts_home_wk_ld if place ==1
replace contacts_in_place_ld = tot_contacts_work_wk_ld if place ==2
replace contacts_in_place_ld = tot_contacts_school_wk_ld if place ==3
replace contacts_in_place_ld = tot_contacts_trans_wk_ld if place ==4
replace contacts_in_place_ld = tot_contacts_ent_we_ld if place ==5

gen contacts_in_place_nld = .
replace contacts_in_place_nld = tot_contacts_home_wk_nld if place ==6
replace contacts_in_place_nld = tot_contacts_work_wk_nld if place ==7
replace contacts_in_place_nld = tot_contacts_school_wk_nld if place ==8
replace contacts_in_place_nld = tot_contacts_trans_wk_nld if place ==9
replace contacts_in_place_nld = tot_contacts_ent_we_nld if place ==10


*gen the difference category
gen diff_contacts_ld = .
la var diff_contacts_ld "diff between ld-nld contact numbers in week, except ent at we"
replace diff_contacts_ld = diff_home_wk_ld if place ==1 
replace diff_contacts_ld = diff_work_wk_ld if place ==2 
replace diff_contacts_ld = diff_sch_wk_ld if place ==3 
replace diff_contacts_ld = diff_trans_wk_ld if place ==4 
replace diff_contacts_ld = diff_ent_we_ld if place ==5 
 
replace diff_contacts_ld = diff_home_wk_ld if place ==6 
replace diff_contacts_ld = diff_work_wk_ld if place ==7 
replace diff_contacts_ld = diff_sch_wk_ld if place ==8 
replace diff_contacts_ld = diff_trans_wk_ld if place ==9 
replace diff_contacts_ld = diff_ent_we_ld if place ==10 

//br hhmem_key tot_contacts* contacts_in_place tot_contacts_wk_nld
tab occupation 


*another occupation grouping that means more similar categories go together
gen occ_2 = 1 if inlist(occupation, 1,2)
replace occ_2 = 2 if inlist(occupation, 4,10)
replace occ_2 = 3 if inlist(occupation,11,18)
replace occ_2 = 4 if inlist(occupation,3,6,7,16,17)
replace occ_2 = 5 if inlist(occupation, 15)
replace occ_2 = 6 if inlist(occupation, 8)
replace occ_2 = 7 if inlist(occupation, 9, 17)
// la define oc2 1 "manual labor" 2 "students or teachers" 3 "not employed or homemakers" 4 "workers - retail or public service" 5 "office workers" 6 "informal trading" 7 "other informal"

la values occ_2 oc2 

keep hhmem_key gender age age_5 occupation occ_2 ses ses_5 site site_type contacts_in_place_nld contacts_in_place_ld place_ld_stat diff_contacts_ld

gen lockdown =.
replace lockdown = 1 if inlist(place_ld_stat, 1,2,3,4,5)
replace lockdown = 0 if inlist(place_ld_stat, 6,7,8,9,10)

*place (mergeable)
gen place_mergeable = .
replace place_mergeable = 1 if inlist(place_ld_stat, 1,6)
replace place_mergeable = 2 if inlist(place_ld_stat, 2,7) 
replace place_mergeable = 3 if inlist(place_ld_stat, 3,8)
replace place_mergeable = 4 if inlist(place_ld_stat, 4,9)
replace place_mergeable = 5 if inlist(place_ld_stat, 5,10)

la def place_gen 1 "home" 2 "work" 3 "school" 4 "transport" 5 "entertainment" 
label values place_mergeable place_gen
label values place_mergeable place_gen


*just keeping ld_contacts
preserve
//drop if contacts_in_place == .
keep if lockdown == 1
drop contacts_in_place_nld lockdown 
*calculate totals per individual 
by hhmem_key, sort: egen tot_contacts_wk_ld = total(contacts_in_place_ld), m
save "stata_input/ind_lockdown_contacts_by_place.dta", replace
restore

*just keeping nld_contacts
preserve
keep if lockdown == 0
drop contacts_in_place_ld lockdown
by hhmem_key, sort: egen tot_contacts_wk_nld  = total(contacts_in_place_nld), m
sort hhmem_key place_ld_stat 
order hhmem_key place_ld_stat contacts_in_place* diff_contacts_ld

save "stata_input/ind_nld_contacts_by_place.dta", replace
restore

* merge them back horizontally
use "stata_input/ind_nld_contacts_by_place.dta", clear
sort hhmem_key place_ld_stat 
order hhmem_key place_ld_stat contacts_in_place* diff_contacts_ld 
drop place_ld_stat

merge 1:1 hhmem_key place_mergeable using "stata_input/ind_lockdown_contacts_by_place.dta"
gen diff_all_places_ld = tot_contacts_wk_nld - tot_contacts_wk_ld

* so now we can see that if there was a total for the non-lockdown, but there is missing for lockdown, this means the person did answer the ld question, but we can't assume the numbers, so they are excluded from calculations on differences as left as missing 

order hhmem_key place_mergeable contacts_in_place_nld contacts_in_place_ld diff_contacts_ld tot_contacts_wk_nld tot_contacts_wk_ld diff_all_places_ld

save "stata_input/ind_contacts_by_place.dta", replace
drop _merge

// *for python 
// replace contacts_in_place_nld= . if contacts_in_place_nld > 720
// replace contacts_in_place_ld = . if contacts_in_place_ld > 720
// replace tot_contacts_wk_nld = . if tot_contacts_wk_nld > 720
// replace tot_contacts_wk_ld = . if tot_contacts_wk_ld > 720
// save "stata_input/ind_contacts_by_place_py.dta", replace

*for python with a max val of 200
replace contacts_in_place_nld= . if contacts_in_place_nld > 200
replace contacts_in_place_ld = . if contacts_in_place_ld > 200
replace tot_contacts_wk_nld = . if tot_contacts_wk_nld > 200
replace tot_contacts_wk_ld = . if tot_contacts_wk_ld > 200
replace diff_all_places_ld = . if tot_contacts_wk_nld ==.
replace diff_all_places_ld = . if tot_contacts_wk_ld ==.


* Guy suggested to generate a version at places but with population as the denominator (i.e. all missings become zeros).

gen pop_contacts_by_place_nld = contacts_in_place_nld
replace  pop_contacts_by_place_nld = 0 if contacts_in_place_nld ==. 

save "stata_input/ind_contacts_by_place_py_max200.dta", replace
