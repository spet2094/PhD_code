
clear all

cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/08_Fieldwork/08_Data/R8_data/"

tempfile temp1

*Purpose: answer Q1 and Q2 of data analysis on social contacts 

use "stata_input/IVQ_R8_wide_contacts_only.dta", replace

save `temp1'

**merge in enumerator codes so I can also 
import excel using "raw/r8_hhmemkey_ennum.xlsx", first clear

codebook hhmem_key

merge 1:1 hhmem_key using `temp1'

keep if _merge==3

// just keeping the obs I can check 

codebook ennum // there are 35 enumerators

*let's have a look at the breakdown of contacts by enumerators 

tabstat nld_all_ages_contacts_week ld_all_ages_contacts_week tot_contacts_*, stat(mean p25 p50 p75 min max sd N) columns(s) varwidth(30)  by(ennum)

tab  ennum if nld_all_ages_contacts_week >720
// RAs 27 (41), 32 and 42(15), 4(20), 48(12) and 2(10)
// total 220 obs
tab  ennum if nld_all_ages_contacts_week >200
// RAs 4(60), 20 (68), 26(45), 27(41), 32(50), 33(38), 34(61),40(60), 46(39) 
// total 692 obs

// not convinced that this is the main problem (see excel table with graphs output)

