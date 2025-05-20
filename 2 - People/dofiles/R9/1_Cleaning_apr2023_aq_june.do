********************************************************************
* Manicaland Centre Project - Human contact data. 
* Do-file: Processing and cleaning
* Autor: Alejandra Quevedo (al.quevedo0420@gmail.com)
* Fecha: 11/04/2023
********************************************************************

clear all
set more off

*Directory
cap cd "C:\Users\alque\OneDrive - ibei.org\World Bank\1. Sophie PHD\June 1"
cap cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/08_Fieldwork/08_Data/R9_data/"

*Cleaning and labelling
use "raw/r9_ivqselect_feb2023_v3.dta", clear


*iecodebook template using "cleaning_1_R9.xlsx"
iecodebook apply using "excel/cleaning_1_R9.xlsx"


drop Q643not Q646not Q648_Q643not Q648_Q643week Q649note_b Q648_Q646not Q649note Q652 Q653_Q643not Q653_Q646not Q656_Q643not Q656_Q646not Q659_Q643not Q659_Q646not Q662_Q643not Q662_Q646not    

*clean ages
tab age

*label project sites

la define sites 2 "Eastern Highlands" 3 "Bonda" 5 "Selborne" 7 "Nyazura" 8 "Nyanga" 9 "Watsomba" 14 " Sakubva" 15 "Hobhouse"
la values site sites 

tab site

*make site type variable 
gen site_type = .
replace site_type = 1 if site==3
replace site_type = 2 if site==9
replace site_type = 3 if inlist(site, 2, 5 )
replace site_type = 4 if inlist(site,7,8 )
replace site_type = 5 if inlist(site, 14,15)
tab site_type,m

la define site_type 1 "subsistence farming" 2 "roadside trading settlement" 3 "agri estate" 4 "commercial centre within rural" 5 "urban"

label values site_type site_type
tab site_type
tab site_type, nol


*Checking for missing

replace comm_out_dist=. if comm_out_dist==99

replace school_yest_u12=. if school_yest_u12==99
replace school_yest_35_64=. if school_yest_35_64==99
replace school_yest_65plus=. if school_yest_65plus==99

*clean individual values and establish cut offs 
foreach x in u12 13_18 19_34 35_64 65plus{
	tab home_yest_`x'
	sum home_yest_`x', d
	//a couple of 100 and one 600
	replace home_yest_`x' =. if home_yest_`x' >=100
}

foreach x in u12 13_18 19_34 35_64 65plus{
	tab home_sat_`x'
	sum home_sat_`x', d
	// look fine 
}

*work yesterday
foreach x in u12 13_18 19_34 35_64 65plus{
	tab work_yest_`x'
	sum work_yest_`x', d
	tab occupation if work_yest_`x' >100 & work_yest_`x' !=.
	replace work_yest_`x' =. if work_yest_`x' >100
	// a small number over 100
}

* work saturday 
foreach x in u12 13_18 19_34 35_64 65plus{
	tab work_sat_`x'
	sum work_sat_`x', d
	tab occupation if work_sat_`x' >100 & work_sat_`x' !=.
	replace work_sat_`x' =. if work_sat_`x' >100
	// a small number over 100
}

*school yesterday 
foreach x in u12 13_18 19_34 35_64 65plus{
	tab school_yest_`x'
	sum school_yest_`x', d	
	tab occupation if school_yest_`x' >100 & school_yest_`x' !=.
	// very few over 100
	replace school_yest_`x' =. if school_yest_`x' >100
}

*school saturday 
foreach x in u12 13_18 19_34 35_64 65plus{
	tab school_sat_`x'
	sum school_sat_`x', d	
	tab occupation if school_sat_`x' >100 & school_sat_`x' !=.
	// very few over 100 but keep them, 150, 400, 500, 700
	replace school_sat_`x' =. if school_sat_`x' >100
}

*transit 
foreach x in u12 13_18 19_34 35_64 65plus{
	tab transit_yest_`x'
	sum transit_yest_`x', d
	tab occupation if transit_yest_`x' >100 & transit_yest_`x' !=.
	// a small number over 100
	replace transit_yest_`x' =. if transit_yest_`x' >100
}

foreach x in u12 13_18 19_34 35_64 65plus{
	tab transit_sat_`x'
	sum transit_sat_`x', d
	// none over 100
}

*community

foreach x in u12 13_18 19_34 35_64 65plus{
	tab comm_yest_`x'
	sum comm_yest_`x', d
	tab occupation if comm_yest_`x' >100 & comm_yest_`x' !=.
	// a small number over 100, keeping them 
}

foreach x in u12 13_18 19_34 35_64 65plus{
	tab comm_sat_`x'
	sum comm_sat_`x', d
	tab occupation if comm_sat_`x' >100 & comm_sat_`x' !=.
	// a small number over 100, keeping them 
}

*bars 
foreach x in u12 13_18 19_34 35_64 65plus{
	tab bar_yest_`x'
	sum bar_yest_`x', d
	tab occupation if bar_yest_`x' >100 & bar_yest_`x' !=.
	// a small number over 100
	replace bar_yest_`x' =. if bar_yest_`x' >100
}

foreach x in u12 13_18 19_34 35_64 65plus{
	tab bar_sat_`x'
	sum bar_sat_`x', d
	tab occupation if bar_sat_`x' >100 & bar_sat_`x' !=.
	// a small number over 100
	replace bar_sat_`x' =. if bar_sat_`x' >100
}

** for the purpose of sampling removed the 99th percentile values, but have put them back 

**get rid of the outliers in the bubbles
replace work_bubble=. if work_bubble >2000
replace comm_bubble=. if comm_bubble >3000

****Code for sum of contacts. 
*Rowtotal:  It creates the (row) sum of the variables in varlist, treating missing as 0.  If missing is specified and all values in varlist are missing for an observation, newvar is set to missing.

// NOTE: it IS possible that if people 

tab home_overall_yest

*drop previous sum variables as not confident that always reliable
drop home_yest_sum home_overall_yest home_overall_sat work_overall_yest work_overall_sat school_overall_yest school_overall_sat comm_overall_yest comm_overall_sat transit_overall_yest transit_overall_sat bar_overall_yest bar_overall_sat q648_q643sum q648_q646sum q653_q643sum q653_q646sum q656_q643sum q656_q646sum q659_q643sum q659_q646sum q662_q643sum q662_q646sum

*Sum of contacts across ages (need to reattach/generate labels)
egen all_home_yest=rowtotal(home_yest_u12 home_yest_13_18 home_yest_19_34 home_yest_35_64 home_yest_65plus), missing
egen all_home_sat=rowtotal(home_sat_u12 home_sat_13_18 home_sat_19_34 home_sat_35_64 home_sat_65plus), missing

egen all_work_yest=rowtotal(work_yest_u12 work_yest_13_18 work_yest_19_34 work_yest_35_64 work_yest_65plus), missing
egen all_work_sat=rowtotal(work_sat_u12 work_sat_13_18 work_sat_19_34 work_sat_35_64 work_sat_65plus), missing

egen all_school_yest=rowtotal(school_yest_u12 school_yest_13_18 school_yest_19_34 school_yest_35_64 school_yest_65plus), missing
egen all_school_sat=rowtotal(school_sat_u12 school_sat_13_18 school_sat_19_34 school_sat_35_64 school_sat_65plus), missing

egen all_com_yest=rowtotal(comm_yest_u12 comm_yest_13_18 comm_yest_19_34 comm_yest_35_64 comm_yest_65plus), missing
egen all_com_sat=rowtotal(comm_sat_u12 comm_sat_13_18 comm_sat_19_34 comm_sat_35_64 comm_sat_65plus), missing

drop if all_com_yest ==3000

egen all_trans_yest=rowtotal(transit_yest_u12 transit_yest_13_18 transit_yest_19_34 transit_yest_35_64 transit_yest_65plus), missing
egen all_trans_sat=rowtotal(transit_sat_u12 transit_sat_13_18 transit_sat_19_34 transit_sat_35_64 transit_sat_65plus), missing

egen all_ent_yest=rowtotal(bar_yest_u12 bar_yest_13_18 bar_yest_19_34 bar_yest_35_64 bar_yest_65plus), missing
egen all_ent_sat=rowtotal(bar_sat_u12 bar_sat_13_18 bar_sat_19_34 bar_sat_35_64 bar_sat_65plus), missing

*Sum of contacts for all locations yest and sat. 

egen tot_contacts_yest=rowtotal(all_*_yest), missing
egen tot_contacts_sat=rowtotal(all_*_sat), missing

*set the top value of the contacts yest to 200 like in r8

replace tot_contacts_yest = 200 if tot_contacts_yest >200 & tot_contacts_yest !=.

replace tot_contacts_sat = 200 if tot_contacts_yest >200 & tot_contacts_yest !=.

* also top out the subcategories otherwise it looks weird
foreach x in all_home_yest all_work_yest all_school_yest all_com_yest all_trans_yest all_ent_yest all_home_sat all_work_sat all_school_sat all_com_sat all_trans_sat all_ent_sat {
	replace `x' = 200 if `x' >200 & `x' !=.
}

* generate also a variable which has a broader community averages
gen broad_com_yest = all_com_yest + all_trans_yest + all_ent_yest 
gen broad_com_sat = all_com_sat + all_trans_sat + all_ent_sat 

 *To generate the day of the week, 0=sunday, 1=monday, ...; 6=saturday
// gen double date = clock(SubmissionDate, "YMD hms")
// format date %tc

gen date = daily(substr(SubmissionDate, 1, 10), "YMD" )
format date %td

gen day=dow(date)

gen yest=.
replace yest=6 if day==0
replace yest=0 if day==1
replace yest=1 if day==2
replace yest=2 if day==3
replace yest=3 if day==4
replace yest=4 if day==5
replace yest=5 if day==6


la define weekdays 0 "Sunday" 1 "Monday" 2 "Tuesday" 3 "Wednesday" 4 "Thursday" 5 "Friday" 6 "Saturday"

la values yest weekdays 
la values day weekdays 


*add back in the code for individual districts 

*attach district numbers from shapefile
gen dist_id = .
replace dist_id = 6 if district == "Makoni"
replace dist_id = 7 if district == "Mutare"
replace dist_id = 8 if district == "Mutasa"
replace dist_id = 9 if district == "Nyanga"

 *check out the most frequently visited other districts
 tab dist_id dist_visit_name, col nofreq  

 tab dist_visit_name
 
 *split 219b into individual districts to be counted
 split(dist_visit_name), p(" ")
 ** make a separate interaction matrix

 rename dist_visit_name1 dist_1
 rename dist_visit_name2 dist_2
 rename dist_visit_name3 dist_3
//
//  tab district,nol
//  foreach x in Makoni Mutare Mutasa Nyanga {
//  	tabout dist_1 if district == "`x'" /
//  	using "tables/`x''s_districts visited.txt", replace
//  	tabout dist_2 if district == "`x'" /
//  	using "tables/`x''s_districts visited.txt", append
//  }
//
//  *for some reason this third one isn't working. 
//   //removing Makoni because no obs and it stops it from working
//  foreach x in Mutare Mutasa Nyanga {
//  	tabout dist_3 if district == "`x'" /
//  	using "tables/`x''s_districts visited.txt", append
//  }
//
//  *tabout respondents from this district
//  tabout district using "tables/district_respondents.txt", replace


 gen Harare_02 = 1 if strpos(dist_visit_name, "Harare") > 0
 gen Beitbridge_46=1 if strpos(dist_visit_name,"Beitbridge")>0
 gen Bikita_32=1 if strpos(dist_visit_name,"Bikita")>0
 gen Bindura_10=1 if strpos(dist_visit_name,"Bindura")>0
 gen Buhera_3=1 if strpos(dist_visit_name,"Buhera")>0
 gen Bulawayo_1=1 if strpos(dist_visit_name,"Bulawayo")>0
 gen Muzarabani_11=1 if strpos(dist_visit_name,"Centenary")>0
 // this is called Muzarabani district in Mashondaland province in district relation
 gen Chimanimani_4=1 if strpos(dist_visit_name,"Chimanimani")>0
 gen Chipinge_5=1 if strpos(dist_visit_name,"Chipinge")>0
 gen Chiredzi_33=1 if strpos(dist_visit_name,"Chiredzi")>0
 gen Chirumhanzu_53=1 if strpos(dist_visit_name,"Chirumhanzu")>0
 gen Chivi_34=1 if strpos(dist_visit_name,"Chivi")>0
 gen Gokwe_South_55=1 if strpos(dist_visit_name,"Gokwe_South")>0
 gen Goromonzi_18=1 if strpos(dist_visit_name,"Goromonzi")>0
 gen Guruve_12=1 if strpos(dist_visit_name,"Guruve")>0
 gen Gutu_35=1 if strpos(dist_visit_name,"Gutu")>0
 gen Gweru_56=1 if strpos(dist_visit_name,"Gweru")>0

 gen Hurungwe_27=1 if strpos(dist_visit_name,"Hurungwe")>0
 gen Kariba_29=1 if strpos(dist_visit_name,"Kariba")>0
 gen Kwekwe_57=1 if strpos(dist_visit_name,"Kwekwe")>0
 gen Lupane_42=1 if strpos(dist_visit_name,"Lupane")>0
 gen Makonde_30=1 if strpos(dist_visit_name,"Makonde")>0
 gen Makoni_6=1 if strpos(dist_visit_name,"Makoni")>0
 gen Marondera_19=1 if strpos(dist_visit_name,"Marondera")>0
 gen Masvingo_36=1 if strpos(dist_visit_name,"Masvingo")>0
 gen Mazowe_13=1 if strpos(dist_visit_name,"Mazowe")>0
 gen Mberengwa_58=1 if strpos(dist_visit_name,"Mberengwa")>0
 gen Mount_Darwin_14=1 if strpos(dist_visit_name,"Mount_Darwin")>0
 gen Mudzi_20=1 if strpos(dist_visit_name,"Mudzi")>0
 gen Murehwa_21=1 if strpos(dist_visit_name,"Murehwa")>0
 gen Mutare_7=1 if strpos(dist_visit_name,"Mutare")>0
 gen Mutasa_8=1 if strpos(dist_visit_name,"Mutasa")>0
 gen Mutoko_22=1 if strpos(dist_visit_name,"Mutoko")>0
 gen Nkayi_43=1 if strpos(dist_visit_name,"Nkayi")>0
 gen Nyanga_9=1 if strpos(dist_visit_name,"Nyanga")>0
 gen Shamva_16=1 if strpos(dist_visit_name,"Shamva")>0
 gen Tsholotsho_44=1 if strpos(dist_visit_name,"Tsholotsho")>0
 gen Wedza_25=1 if strpos(dist_visit_name,"Wedza")>0
 gen Zvimba_31=1 if strpos(dist_visit_name,"Zvimba")>0
 gen Zvishavane_60=1 if strpos(dist_visit_name,"Zvishavane")>0

 *add in districts that don't have any travel

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

 drop dist_visit_name dist_1 dist_2 dist_3
 drop if district ==""
 drop if district =="2"

 *first step of cleaning districts 
 replace Makoni_6=1 if district == "Makoni"
 replace Mutare_7=1 if district == "Mutare"
 replace Mutasa_8=1 if district == "Mutasa"
 replace Nyanga_9=1 if district == "Nyanga"

 *generate it as an od matrix on probabilities 
 egen all_dists = rowtotal(Harare_02 - Mangwe_50)

* add quintiles of age

gen age_5 = .
replace age_5 = 1 if age_9 <15 & age_9 !=.
replace age_5 = 1 if age_9 >=15 & age_9 <=29 & age_9 !=. 
replace age_5 = 2 if age_9 >=30 & age_9 <=44 & age_9 !=. 
replace age_5 = 3 if age_9 >=45 & age_9 <=64 & age_9 !=.
replace age_5 = 4 if age_9 >=65 & age_9 !=. 
tab age_5, m

label define age_5 1"15-29 yrs" 2 "30-44 yrs" 3 "45-64 yrs" 4 "65+ yrs"

label values age_5 age_5




*Other for 1= agricltual estates
replace occupation = 1 if strpos(occupation_other, "Cattle") >0
replace occupation_other="" if strpos(occupation_other, "Cattle") >0

replace occupation = 1 if strpos(occupation_other, "Farm") >0
replace occupation_other="" if strpos(occupation_other, "Farm") >0

replace occupation = 1 if strpos(occupation_other, "Miller") >0
replace occupation_other="" if strpos(occupation_other, "Miller") >0

replace occupation = 1 if strpos(occupation_other, "Tea") >0
replace occupation_other="" if strpos(occupation_other, "Tea") >0

replace occupation = 1 if strpos(occupation_other, "Pig") >0
replace occupation_other="" if strpos(occupation_other, "Pig") >0

replace occupation = 1 if strpos(occupation_other, "Poultry") >0
replace occupation_other="" if strpos(occupation_other, "Poultry") >0

replace occupation = 1 if strpos(occupation_other, "Rice") >0
replace occupation_other="" if strpos(occupation_other, "Rice") >0

replace occupation = 1 if strpos(occupation_other, "Timber") >0
replace occupation_other="" if strpos(occupation_other, "Timber") >0

replace occupation = 1 if strpos(occupation_other, "Estate") >0
replace occupation_other="" if strpos(occupation_other, "Estate") >0

replace occupation = 1 if strpos(occupation_other, "Sawing") >0
replace occupation_other="" if strpos(occupation_other, "Sawing") >0

*Other for 2= Manufacturing, mining, and building trade
replace occupation = 2 if strpos(occupation_other, "Carpent") >0
replace occupation_other="" if strpos(occupation_other, "Carpent") >0

replace occupation = 2 if strpos(occupation_other, "Construction") >0
replace occupation_other="" if strpos(occupation_other, "Construction") >0

replace occupation = 2 if strpos(occupation_other, "Builder") >0
replace occupation_other="" if strpos(occupation_other, "Builder") >0

replace occupation = 2 if strpos(occupation_other, "Brick") >0
replace occupation_other="" if strpos(occupation_other, "Brick") >0

replace occupation = 2 if strpos(occupation_other, "Mechanic") >0
replace occupation_other="" if strpos(occupation_other, "Mechanic") >0

replace occupation = 2 if strpos(occupation_other, "Electric") >0
replace occupation_other="" if strpos(occupation_other, "Electric") >0

replace occupation = 2 if strpos(occupation_other, "Boiler") >0
replace occupation_other="" if strpos(occupation_other, "Boiler") >0

replace occupation = 2 if strpos(occupation_other, "Gold") >0
replace occupation_other="" if strpos(occupation_other, "Gold") >0

replace occupation = 2 if strpos(occupation_other, "Line") >0
replace occupation_other="" if strpos(occupation_other, "Line") >0

replace occupation = 2 if strpos(occupation_other, "Weld") >0
replace occupation_other="" if strpos(occupation_other, "Weld") >0

*Other for 4=Education 
replace occupation = 4 if strpos(occupation_other, "Teacher") >0
replace occupation_other="" if strpos(occupation_other, "Teacher") >0

replace occupation = 4 if strpos(occupation_other, "coach") >0
replace occupation_other="" if strpos(occupation_other, "coach") >0

*Other for 7=Services or retail shops
replace occupation = 7 if strpos(occupation_other, "Hai") >0
replace occupation_other="" if strpos(occupation_other, "Hai") >0

replace occupation = 7 if strpos(occupation_other, "Till") >0
replace occupation_other="" if strpos(occupation_other, "Till") >0

replace occupation = 7 if strpos(occupation_other, "Chef") >0
replace occupation_other="" if strpos(occupation_other, "Chef") >0

replace occupation = 7 if strpos(occupation_other, "Tailor") >0
replace occupation_other="" if strpos(occupation_other, "Tailor") >0

replace occupation = 7 if strpos(occupation_other, "Security") >0
replace occupation_other="" if strpos(occupation_other, "Security") >0

replace occupation = 7 if strpos(occupation_other, "Canteen") >0
replace occupation_other="" if strpos(occupation_other, "Canteen") >0

replace occupation = 7 if strpos(occupation_other, "Car") >0
replace occupation_other="" if strpos(occupation_other, "Car") >0

replace occupation = 7 if strpos(occupation_other, "Facilitator") >0
replace occupation_other="" if strpos(occupation_other, "Facilitator") >0

replace occupation = 7 if strpos(occupation_other, "Flourist") >0
replace occupation_other="" if strpos(occupation_other, "Flourist") >0

replace occupation = 7 if strpos(occupation_other, "Garbage") >0
replace occupation_other="" if strpos(occupation_other, "Garbage") >0

replace occupation = 7 if strpos(occupation_other, "General hand") >0
replace occupation_other="" if strpos(occupation_other, "General hand") >0

replace occupation = 7 if strpos(occupation_other, "General Hand") >0
replace occupation_other="" if strpos(occupation_other, "General Hand") >0

replace occupation = 7 if strpos(occupation_other, "Holiday") >0
replace occupation_other="" if strpos(occupation_other, "Holiday") >0

replace occupation = 7 if strpos(occupation_other, "Interior") >0
replace occupation_other="" if strpos(occupation_other, "Interior") >0

replace occupation = 7 if strpos(occupation_other, "Waste") >0
replace occupation_other="" if strpos(occupation_other, "Waste") >0

replace occupation = 7 if strpos(occupation_other, "Painter") >0
replace occupation_other="" if strpos(occupation_other, "Painter") >0

replace occupation = 7 if strpos(occupation_other, "Panel") >0
replace occupation_other="" if strpos(occupation_other, "Panel") >0

replace occupation = 7 if strpos(occupation_other, "Tv") >0
replace occupation_other="" if strpos(occupation_other, "Tv") >0

replace occupation = 7 if strpos(occupation_other, "Plumb") >0
replace occupation_other="" if strpos(occupation_other, "Plumb") >0

replace occupation = 7 if strpos(occupation_other, "Radio") >0
replace occupation_other="" if strpos(occupation_other, "Radio") >0

replace occupation = 8 if strpos(occupation_other, "Printing") >0
replace occupation_other="" if strpos(occupation_other, "Printing") >0

replace occupation = 8 if strpos(occupation_other, "Sewing") >0
replace occupation_other="" if strpos(occupation_other, "Sewing") >0

*Other for 8=Informal petty trading
replace occupation = 8 if strpos(occupation_other, "Self") >0
replace occupation_other="" if strpos(occupation_other, "Self") >0

replace occupation = 8 if strpos(occupation_other, "Part") >0
replace occupation_other="" if strpos(occupation_other, "Part") >0

replace occupation = 8 if strpos(occupation_other, "Selling") >0
replace occupation_other="" if strpos(occupation_other, "Selling") >0

replace occupation = 8 if strpos(occupation_other, "Vendor") >0
replace occupation_other="" if strpos(occupation_other, "Vendor") >0

replace occupation = 8 if strpos(occupation_other, "selling") >0
replace occupation_other="" if strpos(occupation_other, "selling") >0

replace occupation = 8 if strpos(occupation_other, "Piece") >0
replace occupation_other="" if strpos(occupation_other, "Piece") >0

replace occupation = 8 if strpos(occupation_other, "Sell") >0
replace occupation_other="" if strpos(occupation_other, "Sell") >0

replace occupation = 8 if strpos(occupation_other, "Peace") >0
replace occupation_other="" if strpos(occupation_other, "Peace") >0

replace occupation = 8 if strpos(occupation_other, "photocopying") >0
replace occupation_other="" if strpos(occupation_other, "photocopying") >0

*Other for 10: Student

replace occupation = 10 if strpos(occupation_other, "Student") >0
replace occupation_other="" if strpos(occupation_other, "Student") >0

*Other for 11= Unemployed: excl agriculture
replace occupation = 11 if strpos(occupation_other, "Unemployed") >0
replace occupation_other="" if strpos(occupation_other, "Unemployed") >0

replace occupation = 11 if strpos(occupation_other, "Unemploymed") >0
replace occupation_other="" if strpos(occupation_other, "Unemploymed") >0

replace occupation = 11 if strpos(occupation_other, "Umployed") >0
replace occupation_other="" if strpos(occupation_other, "Umployed") >0

replace occupation = 11 if strpos(occupation_other, "Unmployed") >0
replace occupation_other="" if strpos(occupation_other, "Unmployed") >0

replace occupation = 11 if strpos(occupation_other, "unemployed") >0
replace occupation_other="" if strpos(occupation_other, "unemployed") >0

replace occupation = 11  if inlist(occupation_other, "Pensinor", "Pensioner", "Retired")
replace occupation_other= "" if inlist(occupation_other, "Pensinor", "Pensioner", "Retired")

replace occupation = 11 if strpos(occupation_other, "Retired") >0
replace occupation_other="" if strpos(occupation_other, "Retired") >0

replace occupation = 11 if strpos(occupation_other, "Do not") >0
replace occupation_other="" if strpos(occupation_other, "Do not") >0

replace occupation = 11 if strpos(occupation_other, "No job") >0
replace occupation_other="" if strpos(occupation_other, "No job") >0

replace occupation = 11 if strpos(occupation_other, "None") >0
replace occupation_other="" if strpos(occupation_other, "None") >0

replace occupation = 11 if strpos(occupation_other, "Not") >0
replace occupation_other="" if strpos(occupation_other, "Not") >0

replace occupation = 11 if strpos(occupation_other, "Begging") >0
replace occupation_other="" if strpos(occupation_other, "Begging") >0

replace occupation = 11 if strpos(occupation_other, "Just") >0
replace occupation_other="" if strpos(occupation_other, "Just") >0

*Other for 14=Transport (transport was 16 in round 8)
replace occupation = 14 if strpos(occupation_other, "Drive") >0
replace occupation_other="" if strpos(occupation_other, "Drive") >0

replace occupation = 14 if strpos(occupation_other, "Driver") >0
replace occupation_other="" if strpos(occupation_other, "Driver") >0

replace occupation = 14 if strpos(occupation_other, "Driving") >0
replace occupation_other="" if strpos(occupation_other, "Driving") >0

replace occupation = 14 if strpos(occupation_other, "Bus Conductor") >0
replace occupation_other="" if strpos(occupation_other, "Bus Conductor") >0

*Other for 15= Office worker
replace occupation = 15 if strpos(occupation_other, "Office") >0
replace occupation_other="" if strpos(occupation_other, "Office") >0

replace occupation = 15 if strpos(occupation_other, "Journalist") >0
replace occupation_other="" if strpos(occupation_other, "Journalist") >0

replace occupation = 15 if strpos(occupation_other, "Receptionist") >0
replace occupation_other="" if strpos(occupation_other, "Receptionist") >0

replace occupation = 15 if strpos(occupation_other, "Marketing") >0
replace occupation_other="" if strpos(occupation_other, "Marketing") >0

replace occupation = 15 if strpos(occupation_other, "Director") >0
replace occupation_other="" if strpos(occupation_other, "Director") >0

replace occupation = 15 if strpos(occupation_other, "Councillor") >0
replace occupation_other="" if strpos(occupation_other, "Councillor") >0

replace occupation = 15 if strpos(occupation_other, "ZINWA") >0
replace occupation_other="" if strpos(occupation_other, "ZINWA") >0

replace occupation = 15 if strpos(occupation_other, "Zimpost") >0
replace occupation_other="" if strpos(occupation_other, "Zimpost") >0

replace occupation = 15 if strpos(occupation_other, "officer") >0
replace occupation_other="" if strpos(occupation_other, "officer") >0

*Other for 17=Healthcare: other (healthcare didn't exist in round 8, nurse or doctor ws 6, in R8 17= sex worker)
replace occupation = 17 if strpos(occupation_other, "Medical") >0
replace occupation_other="" if strpos(occupation_other, "Medical") >0

replace occupation = 17 if strpos(occupation_other, "Health") >0
replace occupation_other="" if strpos(occupation_other, "Health") >0

replace occupation = 17 if strpos(occupation_other, "health") >0
replace occupation_other="" if strpos(occupation_other, "health") >0

replace occupation = 17 if strpos(occupation_other, "Wizroad") >0
replace occupation_other="" if strpos(occupation_other, "Wizroad") >0

*Other for 18= Social Work

replace occupation = 18 if strpos(occupation_other, "Research") >0
replace occupation_other="" if strpos(occupation_other, "Research") >0

*Other for 19=Homeworked/Housework (r8  18=homemaker)
replace occupation = 19 if strpos(occupation_other, "Care") >0
replace occupation_other="" if strpos(occupation_other, "Care") >0

replace occupation = 19 if strpos(occupation_other, "House") >0
replace occupation_other="" if strpos(occupation_other, "House") >0

replace occupation = 19 if strpos(occupation_other, "Garden") >0
replace occupation_other="" if strpos(occupation_other, "Garden") >0

replace occupation = 19 if strpos(occupation_other, "care") >0
replace occupation_other="" if strpos(occupation_other, "care") >0

replace occupation = 19 if strpos(occupation_other, "Maid") >0
replace occupation_other="" if strpos(occupation_other, "Maid") >0

replace occupation = 19 if strpos(occupation_other, "Clerk") >0
replace occupation_other="" if strpos(occupation_other, "Clerk")

**Other for 20= religious (didn't exist in r8)
replace occupation = 20 if strpos(occupation_other, "Church") >0
replace occupation_other="" if strpos(occupation_other, "Church")

replace occupation = 20 if strpos(occupation_other, "Priest") >0
replace occupation_other="" if strpos(occupation_other, "Priest")

replace occupation = 20 if strpos(occupation_other, "church") >0
replace occupation_other="" if strpos(occupation_other, "church")


la define occ_short 1 "ag estates" 2 "manufacturing, mining" 3 "police or army" 4 "education" 6 "doctor or nurse" 7 "service or retail" 8 "informal - petty trade" 9 "subsistence ag"  10 "student" 11 "unemployed excl. ag" 12 "other"  15 "office worker" 14 "transport sector" 19 "homemaker" 16 "healthcare VCW or nurse aide" 17 "healthcare - other" 18 "social work"  20 "religious"
 

la values occupation occ_short
tab occupation
numlabel occ_short, add

*create occ_2 categories to be comparable with R8 (adapt the categories )
tab occupation

gen occ_2 = 1 if inlist(occupation, 1,2) 
replace occ_2 = 2 if inlist(occupation, 4,10)
replace occ_2 = 3 if inlist(occupation,11,19)
replace occ_2 = 4 if inlist(occupation,3,6,7,14,16,17,18,20)
replace occ_2 = 5 if inlist(occupation, 15)
replace occ_2 = 6 if inlist(occupation, 8)
replace occ_2 = 7 if inlist(occupation, 9, 17, 12)
la define oc2 1 "manual labor" 2 "students or teachers" 3 "not employed or homemakers" 4 "workers - retail or public service" 5 "office workers" 6 "informal trading" 7 "other informal"

// create one that is specifically healthcare 

la values occ_2 oc2 
tab occ_2, missing
tab occupation if occ_2 ==.

*create occ_3 categories for qual sampling 

gen occ_3 = .
replace occ_3 = 1 if inlist(occupation, 1,2,8, 7)
replace occ_3 = 2 if inlist(occupation, 3,6, 14, 15,16, 17, 18, 20)
replace occ_3 = 3 if inlist(occupation, 10, 4)
replace occ_3 = 4 if inlist(occupation, 11,19, 9)

la def occ_3 1 "blue collar/informal trade" 2 "service workers" 3 "schools" 4 "homemakers or not working"
tab occ_3

la values occ_3 occ_3
*eyeball the means to see if the categories look right
tabstat tot_contacts_yest if occ_2==1, by(occupation) stat(mean min max q) 
tabstat tot_contacts_yest if occ_2==2, by(occupation) stat(mean min max q) 
tabstat tot_contacts_yest if occ_2==3, by(occupation) stat(mean min max q) 
tabstat tot_contacts_yest if occ_2==4, by(occupation) stat(mean min max q) 

*now do mv means test on the subselections i've created

mvtest means tot_contacts_yest if occ_2 == 1, by(occupation) 
mvtest means tot_contacts_yest if occ_2 == 2, by(occupation) 
mvtest means tot_contacts_yest if occ_2 == 3, by(occupation) 
mvtest means tot_contacts_yest if occ_2 == 4, by(occupation) 
// now none of the groups are significantly different within the occupations in occ_2 categories  

mvtest means tot_contacts_yest, by(occ_2)

*generate occ4 for bubbles 
label define occ4 1 "ag_estates" 2 "manu_mining_trades" 3 "police_army" 4 "education" 5 "healthcare_social_work" 7 "service_retail" 8 "informal_petty_trade" 9 "subsistence_ag" 10 "student" 11 "unemployed_not_ag" 12 "other" 14 "transport_sector" 15 "office_worker" 19 "homemaker" 20 "religious" 

*generate occ5 for bubbles 
label define occ5 1 "ag_estates" 2 "manu_mining_trades" 3 "police_army" 4 "students_teachers" 5 "healthcare_social_work" 7 "service_retail" 8 "informal_petty_trade" 9 "subsistence_ag" 11 "unemployed_not_ag" 12 "other" 14 "transport_sector" 15 "office_worker" 19 "homemaker" 20 "religious" 

// categories 10 and 4 are combined to be students and teachers in 4 

*create occ4 categories for bubbles
tab occupation

gen occ4 = occupation
replace occ4=5 if inlist(occupation,6,16,17,18 )
 
label values occ4 occ4
tab occ4

*create occ5 where we combine students and teachers

gen occ5=occ4
replace occ5=4 if occ5==10
label values occ5 occ5


*generate weekday vs. weekend contacts averages and individual groupings 

*remember that the 'day' refers to the day of the survey, not 'yesterday'
// therefore yesterday figures are day-1

gen day_contacts=day-1

label define weekdays -1 "Saturday", modify
label list weekdays

la values day_contacts weekdays 

*replace the saturday values with the saturday contacts in the saturday variables
//there are 16 values in saturday under 'tot_contacts_yesterday' because there were 16 surveys done on sunday. They seem more accurate than the one for 'tot_contacts_yest' for those people, so replacing in tot_cntacts_sat, and getting rid of it in the tot_contacts_yest
replace tot_contacts_sat =tot_contacts_yest if (day_contacts==-1 & tot_contacts_sat ==.)

replace tot_contacts_yest = . if day ==0
tab day_contacts 


gen weekday = 1 if inlist(day_contacts, 1,2,3,4,5)
replace weekday=0 if inlist(day_contacts,0,6, -1)

* clean the bubbles data 

*for when looking at occupations, I want to make sure work bubble numbers show up as school bubbles for students 
replace work_bubble = school_bubble if occupation==10
 

***super helpful command that adds the numbers to the value labels
//
// label dir
// numlabel `r(names)', add


tab day_contacts
tab day


save "stata_input/r9_ivqselect_feb2023_v3_newVars.dta", replace

