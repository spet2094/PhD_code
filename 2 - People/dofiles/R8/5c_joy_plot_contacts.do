clear all
cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/08_Fieldwork/08_Data/R8_data"

*Purpose: preprocess occupational contact data for joy plot

*********Compare occupational category distributions *****************

use "stata_output/ind_contacts_by_place.dta", clear

gen o_manual_labor = 1 if 
