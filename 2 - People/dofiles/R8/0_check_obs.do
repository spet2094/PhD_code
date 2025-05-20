
clear all
cd "/Volumes/GoogleDrive-116265284851139195184/My Drive/PhD/08_Fieldwork/08_Data/R8_data/"

*Purpose: answer Q1 and Q2 of data analysis on social contacts 

use "IVQ_R8_renamed.dta", clear



**************************************************************
	/*checks on the obs drops changes*/
**************************************************************

foreach x in ld_work_wku15 ld_work_wk15_44 ld_work_wk45_64 ld_work_wk65plus ld_work_weu15 ld_work_we15_44 ld_work_we45_64 ld_work_we65plus ld_school_wku15 ld_school_wk15_44 ld_school_wk45_64 ld_school_wk65plus ld_school_weu15 ld_school_we15_44 ld_school_we45_64 ld_school_we65plus ld_trans_wku15 ld_trans_wk15_44 ld_trans_wk45_64 ld_trans_wk65plus ld_trans_weu15 ld_trans_we15_44 ld_trans_we45_64 ld_trans_we65plus ld_home_wku15 ld_home_wk15_44 ld_home_wk45_64 ld_home_wk65plus ld_home_weu15 ld_home_we15_44 ld_home_we45_64 ld_home_we65plus ld_ent_wku15 ld_ent_wk15_44 ld_ent_wk45_64 ld_ent_wk65plus ld_ent_weu15 ld_ent_we15_44 ld_ent_we45_64 ld_ent_we65plus ld_other_wku15 ld_other_wk15_44 ld_other_wk45_64 ld_other_wk65plus ld_other_weu15 ld_other_we15_44 ld_other_we45_64 ld_other_we65plus  ///
nld_work_wku15 nld_work_wk15_44 nld_work_wk45_64 nld_work_wk65plus nld_work_weu15 nld_work_we15_44 nld_work_we45_64 nld_work_we65plus nld_school_wku15 nld_school_wk15_44 nld_school_wk45_64 nld_school_wk65plus nld_school_weu15 nld_school_we15_44 nld_school_we45_64 nld_school_we65plus nld_trans_wku15 nld_trans_wk15_44 nld_trans_wk45_64 nld_trans_wk65plus nld_trans_weu15 nld_trans_we15_44 nld_trans_we45_64 nld_trans_we65plus nld_home_wku15 nld_home_wk15_44 nld_home_wk45_64 nld_home_wk65plus nld_home_weu15 nld_home_we15_44 nld_home_we45_64 nld_home_we65plus nld_ent_wku15 nld_ent_wk15_44 nld_ent_wk45_64 nld_ent_wk65plus nld_ent_weu15 nld_ent_we15_44 nld_ent_we45_64 nld_ent_we65plus nld_other_wku15 nld_other_wk15_44 nld_other_wk45_64 nld_other_wk65plus nld_other_weu15 nld_other_we15_44 nld_other_we45_64 nld_other_we65plus {
	replace `x' = . if inlist(`x',98, 99, 998, 999, 990, 9999 ) 
	// 98 don't know, 99 doesn't apply just replacing with missing for my purposes
	
}




foreach x in ld_work_wku15 ld_work_wk15_44 ld_work_wk45_64 ld_work_wk65plus ld_work_weu15 ld_work_we15_44 ld_work_we45_64 ld_work_we65plus ld_school_wku15 ld_school_wk15_44 ld_school_wk45_64 ld_school_wk65plus ld_school_weu15 ld_school_we15_44 ld_school_we45_64 ld_school_we65plus ld_trans_wku15 ld_trans_wk15_44 ld_trans_wk45_64 ld_trans_wk65plus ld_trans_weu15 ld_trans_we15_44 ld_trans_we45_64 ld_trans_we65plus ld_home_wku15 ld_home_wk15_44 ld_home_wk45_64 ld_home_wk65plus ld_home_weu15 ld_home_we15_44 ld_home_we45_64 ld_home_we65plus ld_ent_wku15 ld_ent_wk15_44 ld_ent_wk45_64 ld_ent_wk65plus ld_ent_weu15 ld_ent_we15_44 ld_ent_we45_64 ld_ent_we65plus ld_other_wku15 ld_other_wk15_44 ld_other_wk45_64 ld_other_wk65plus ld_other_weu15 ld_other_we15_44 ld_other_we45_64 ld_other_we65plus ///
 nld_work_wku15 nld_work_wk15_44 nld_work_wk45_64 nld_work_wk65plus nld_work_weu15 nld_work_we15_44 nld_work_we45_64 nld_work_we65plus nld_school_wku15 nld_school_wk15_44 nld_school_wk45_64 nld_school_wk65plus nld_school_weu15 nld_school_we15_44 nld_school_we45_64 nld_school_we65plus nld_trans_wku15 nld_trans_wk15_44 nld_trans_wk45_64 nld_trans_wk65plus nld_trans_weu15 nld_trans_we15_44 nld_trans_we45_64 nld_trans_we65plus nld_home_wku15 nld_home_wk15_44 nld_home_wk45_64 nld_home_wk65plus nld_home_weu15 nld_home_we15_44 nld_home_we45_64 nld_home_we65plus nld_ent_wku15 nld_ent_wk15_44 nld_ent_wk45_64 nld_ent_wk65plus nld_ent_weu15 nld_ent_we15_44 nld_ent_we45_64 nld_ent_we65plus nld_other_wku15 nld_other_wk15_44 nld_other_wk45_64 nld_other_wk65plus nld_other_weu15 nld_other_we15_44 nld_other_we45_64 nld_other_we65plus {
	replace `x'=. if `x' > 50 // decide on the same cut off for both
	
}
e

foreach x in ld_work_wku15 ld_work_wk15_44 ld_work_wk45_64 ld_work_wk65plus ld_work_weu15 ld_work_we15_44 ld_work_we45_64 ld_work_we65plus ld_school_wku15 ld_school_wk15_44 ld_school_wk45_64 ld_school_wk65plus ld_school_weu15 ld_school_we15_44 ld_school_we45_64 ld_school_we65plus ld_trans_wku15 ld_trans_wk15_44 ld_trans_wk45_64 ld_trans_wk65plus ld_trans_weu15 ld_trans_we15_44 ld_trans_we45_64 ld_trans_we65plus ld_ent_wku15 ld_ent_wk15_44 ld_ent_wk45_64 ld_ent_wk65plus ld_ent_weu15 ld_ent_we15_44 ld_ent_we45_64 ld_ent_we65plus ld_other_wku15 ld_other_wk15_44 ld_other_wk45_64 ld_other_wk65plus ld_other_weu15 ld_other_we15_44 ld_other_we45_64 ld_other_we65plus ///
nld_work_wku15 nld_work_wk15_44 nld_work_wk45_64 nld_work_wk65plus nld_work_weu15 nld_work_we15_44 nld_work_we45_64 nld_work_we65plus nld_school_wku15 nld_school_wk15_44 nld_school_wk45_64 nld_school_wk65plus nld_school_weu15 nld_school_we15_44 nld_school_we45_64 nld_school_we65plus nld_trans_wku15 nld_trans_wk15_44 nld_trans_wk45_64 nld_trans_wk65plus nld_trans_weu15 nld_trans_we15_44 nld_trans_we45_64 nld_trans_we65plus  nld_ent_wku15 nld_ent_wk15_44 nld_ent_wk45_64 nld_ent_wk65plus nld_ent_weu15 nld_ent_we15_44 nld_ent_we45_64 nld_ent_we65plus nld_other_wku15 nld_other_wk15_44 nld_other_wk45_64 nld_other_wk65plus nld_other_weu15 nld_other_we15_44 nld_other_we45_64 nld_other_we65plus {
	replace `x' = . if `x' ==0 // decide on the same cut off for both
	
}
