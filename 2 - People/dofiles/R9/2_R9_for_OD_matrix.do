clear all
cap cd "C:\Users\alque\OneDrive - ibei.org\World Bank\Sophie PHD\"
cap cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/08_Fieldwork/08_Data/R9_data/"
import excel "raw/r9_ivqselect_feb2023_v1.xlsx", first clear 

// 9,648 obs 178 variables 

**Keeping the main variables of interest for further processing

format hhmem_key %12.0f
rename Q101 consent_given
//rename Q201 start_time - i want this variable and the end time, so i can calculate the length of the survey and the section
rename Q202 gender
rename Q204 age_9
rename Q205 in_school
la var Q219a "Q219a how many districts visited in the last seven days"
la var Q219b "Q219b names of districts visited in the last seven days"
rename Q219ci school_out_home_dist 
la var school_out_home_dist "Q219ci school outside home dist"
rename Q219cii work_out_home_dist
la var work_out_home_dist "Q219cii work outside home dist"
rename Q219ciii com_out_home_dist
la var com_out_home_dist "Q219ciii community/leisure outside home dist"

rename Q221 occupation
la var occupation "Q221 - occupation"

*attach district numbers from shapefile
gen dist_id = .
replace dist_id = 6 if district == "Makoni"
replace dist_id = 7 if district == "Mutare"
replace dist_id = 8 if district == "Mutasa"
replace dist_id = 9 if district == "Nyanga"

*check out the most frequently visited other districts
tab dist_id Q219a, col nofreq // 
tab Q219b

*split 219b into individual districts to be counted
split(Q219b), p(" ")
e
tab district,nol
foreach x in Makoni Mutare Mutasa Nyanga {
	tabout Q219b1 if district == "`x'" ///
	using "tables/`x''s_districts visited.txt", replace
	tabout Q219b2 if district == "`x'" ///
	using "tables/`x''s_districts visited.txt", append
}

*for some reason this third one isn't working. 
// removing Makoni because no obs and it stops it from working
foreach x in Mutare Mutasa Nyanga {
	tabout Q219b3 if district == "`x'" ///
	using "tables/`x''s_districts visited.txt", append
}

*tabout respondents from this district
tabout district using "tables/district_respondents.txt", replace

** make a separate interaction matrix

rename Q219b1 dist_1
rename Q219b2 dist_2
rename Q219b3 dist_3

keep hhmem_key district dist_1 dist_2 dist_3 Q219b 

gen Harare_02 = 1 if strpos(Q219b, "Harare") > 0
gen Beitbridge_46=1 if strpos(Q219b,"Beitbridge")>0
gen Bikita_32=1 if strpos(Q219b,"Bikita")>0
gen Bindura_10=1 if strpos(Q219b,"Bindura")>0
gen Buhera_3=1 if strpos(Q219b,"Buhera")>0
gen Bulawayo_1=1 if strpos(Q219b,"Bulawayo")>0
gen Muzarabani_11=1 if strpos(Q219b,"Centenary")>0
// this is called Muzarabani district in Mashondaland province in district relation
gen Chimanimani_4=1 if strpos(Q219b,"Chimanimani")>0
gen Chipinge_5=1 if strpos(Q219b,"Chipinge")>0
gen Chiredzi_33=1 if strpos(Q219b,"Chiredzi")>0
gen Chirumhanzu_53=1 if strpos(Q219b,"Chirumhanzu")>0
gen Chivi_34=1 if strpos(Q219b,"Chivi")>0
gen Gokwe_South_55=1 if strpos(Q219b,"Gokwe_South")>0
gen Goromonzi_18=1 if strpos(Q219b,"Goromonzi")>0
gen Guruve_12=1 if strpos(Q219b,"Guruve")>0
gen Gutu_35=1 if strpos(Q219b,"Gutu")>0
gen Gweru_56=1 if strpos(Q219b,"Gweru")>0

gen Hurungwe_27=1 if strpos(Q219b,"Hurungwe")>0
gen Kariba_29=1 if strpos(Q219b,"Kariba")>0
gen Kwekwe_57=1 if strpos(Q219b,"Kwekwe")>0
gen Lupane_42=1 if strpos(Q219b,"Lupane")>0
gen Makonde_30=1 if strpos(Q219b,"Makonde")>0
gen Makoni_6=1 if strpos(Q219b,"Makoni")>0
gen Marondera_19=1 if strpos(Q219b,"Marondera")>0
gen Masvingo_36=1 if strpos(Q219b,"Masvingo")>0
gen Mazowe_13=1 if strpos(Q219b,"Mazowe")>0
gen Mberengwa_58=1 if strpos(Q219b,"Mberengwa")>0
gen Mount_Darwin_14=1 if strpos(Q219b,"Mount_Darwin")>0
gen Mudzi_20=1 if strpos(Q219b,"Mudzi")>0
gen Murehwa_21=1 if strpos(Q219b,"Murehwa")>0
gen Mutare_7=1 if strpos(Q219b,"Mutare")>0
gen Mutasa_8=1 if strpos(Q219b,"Mutasa")>0
gen Mutoko_22=1 if strpos(Q219b,"Mutoko")>0
gen Nkayi_43=1 if strpos(Q219b,"Nkayi")>0
gen Nyanga_9=1 if strpos(Q219b,"Nyanga")>0
gen Shamva_16=1 if strpos(Q219b,"Shamva")>0
gen Tsholotsho_44=1 if strpos(Q219b,"Tsholotsho")>0
gen Wedza_25=1 if strpos(Q219b,"Wedza")>0
gen Zvimba_31=1 if strpos(Q219b,"Zvimba")>0
gen Zvishavane_60=1 if strpos(Q219b,"Zvishavane")>0

*add in districts that don't have any travell

gen Rushinga_15=0
gen Chegutu_26=0
gen Sanyati_28=0
gen Mwenezi_37=0
gen Zaka_38=0
gen Gwanda_48=0
gen Insiza_49=0
gen Matobo_51=0
gen Umzingwane_52=0
gen Shurugwi_59=0
gen Gokwe_North_54=0
gen Binga_39=0
gen Bubi_40=0
gen Umguza_45=0
gen Hwange_41=0
gen Seke_23=0
gen Uzumba_Maramba_Pfungwe_24=0
gen Chikomba_17=0
gen Bulilima_47=0
gen Mangwe_50=0

*collapse the counts by district 

drop Q219b dist_1 dist_2 dist_3
drop if district ==""
drop if district =="2"
collapse (count) hhmem_key (sum)  Harare_02 - Mangwe_50 , by (district)

//first step of cleaning districts 
replace Makoni_6=0 if district == "Makoni"
replace Mutare_7=0 if district == "Mutare"
replace Mutasa_8=0 if district == "Mutasa"
replace Nyanga_9=0 if district == "Nyanga"

*generate it as an od matrix on probabilities 
egen all_dists = rowtotal(Harare_02 - Mangwe_50)

*change travelled to 1 if district is same as home district
replace Makoni_6=hhmem_key - all_dists if district == "Makoni"
replace Mutare_7=hhmem_key - all_dists if district == "Mutare"
replace Mutasa_8=hhmem_key - all_dists if district == "Mutasa"
replace Nyanga_9=hhmem_key - all_dists if district == "Nyanga"

*generate probabilities 
foreach var of varlist Harare_02 - Mangwe_50 {
	gen p_`var' = `var'/hhmem_key
	drop `var'
}
drop hhmem_key all_dists
*transpose data
xpose, clear varname

rename v1 d_6
rename v2 d_7
rename v3 d_8
rename v4 d_9
rename _varname district
order district 
drop if district == "district"

*rename as per the od matrix for ease of comparison
replace district ="d_2" if district == "p_Harare_02"
replace district ="d_46" if district == "p_Beitbridge_46"
replace district ="d_32" if district == "p_Bikita_32"
replace district ="d_10" if district == "p_Bindura_10"
replace district ="d_3" if district == "p_Buhera_3"
replace district ="d_1" if district == "p_Bulawayo_1"
replace district ="d_11" if district == "p_Muzarabani_11" 

replace district ="d_4" if district == "p_Chimanimani_4"
replace district ="d_5" if district == "p_Chipinge_5"
replace district ="d_33" if district == "p_Chiredzi_33"
replace district ="d_53" if district == "p_Chirumhanzu_53"
replace district ="d_34" if district == "p_Chivi_34"
replace district ="d_55" if district == "p_Gokwe_South_55"
replace district ="d_18" if district == "p_Goromonzi_18"
replace district ="d_12" if district == "p_Guruve_12"
replace district ="d_35" if district == "p_Gutu_35"
replace district ="d_56" if district == "p_Gweru_56"
replace district ="d_27" if district == "p_Hurungwe_27"
replace district ="d_29" if district == "p_Kariba_29"
replace district ="d_57" if district == "p_Kwekwe_57"
replace district ="d_42" if district == "p_Lupane_42"
replace district ="d_30" if district == "p_Makonde_30"
replace district ="d_6" if district == "p_Makoni_6"
replace district ="d_19" if district == "p_Marondera_19"
replace district ="d_36" if district == "p_Masvingo_36"
replace district ="d_13" if district == "p_Mazowe_13"
replace district ="d_58" if district == "p_Mberengwa_58"
replace district ="d_14" if district == "p_Mount_Darwin_14"
replace district ="d_20" if district == "p_Mudzi_20"
replace district ="d_21" if district == "p_Murehwa_21"
replace district ="d_7" if district == "p_Mutare_7"
replace district ="d_8" if district == "p_Mutasa_8"
replace district ="d_22" if district == "p_Mutoko_22"
replace district ="d_43" if district == "p_Nkayi_43"
replace district ="d_9" if district == "p_Nyanga_9"
replace district ="d_16" if district == "p_Shamva_16"
replace district ="d_44" if district == "p_Tsholotsho_44"
replace district ="d_25" if district == "p_Wedza_25"
replace district ="d_31" if district == "p_Zvimba_31"
replace district ="d_60" if district == "p_Zvishavane_60"

*add districts w no travel
replace district = "d_15" if district == "p_Rushinga_15"
replace district = "d_26" if district == "p_Chegutu_26"
replace district = "d_28" if district == "p_Sanyati_28"
replace district = "d_37" if district == "p_Mwenezi_37"
replace district = "d_38" if district == "p_Zaka_38"
replace district = "d_48" if district == "p_Gwanda_48"
replace district = "d_49" if district == "p_Insiza_49"
replace district = "d_51" if district == "p_Matobo_51"
replace district = "d_52" if district == "p_Umzingwane_52"
replace district = "d_59" if district == "p_Shurugwi_59"
replace district = "d_54" if district == "p_Gokwe_North_54"
replace district = "d_39" if district == "p_Binga_39"
replace district = "d_40" if district == "p_Bubi_40"
replace district = "d_45" if district == "p_Umguza_45"
replace district = "d_41" if district == "p_Hwange_41"
replace district = "d_23" if district == "p_Seke_23"
replace district = "d_24" if district == "p_Uzumba_Maramba_Pfungwe_24"
replace district = "d_17" if district == "p_Chikomba_17"
replace district = "d_47" if district == "p_Bulilima_47"
replace district = "d_50" if district == "p_Mangwe_50"

sort district
export delimited "excel/od_matrix.csv", replace
