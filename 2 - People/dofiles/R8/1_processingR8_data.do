clear all
cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/08_Fieldwork/08_Data/R8_data"

use "raw/IVQ_R8_SA_cleaned_by_ICL.dta", clear

format hhmem_key %13.0f 

label dir
numlabel `r(names)', add
******************************************************************************************************************************************************

***VARIABLE RENAMING 

******************************************************************************************************************************************************


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

*make district variable 

*remove non-consenting participants 
// have already been removed 

*label occupations // note have put mining from other in with 2

la define occupations 1 "Estates: tea, coffee, forestry" 2 "Manufacturing, mining or building trade" 3 "Police or army" 4 "Teacher :  primary school or secondary school" 6 "Nurse or doctor" 7 "Services or retail shops" 8 "Informal: petty trading (veg etc)" 9 "Informal: subsistence agriculture" 10 "Student" 11 "Unemployed: exl. agriculture" 15 "Office worker" 12 "Other (specify)"

la values q221 occupations

rename q221 occupations
tab occupations site, col nofreq

*clean occupational categories in 'other' 
tab q221other
tab occupations

**others for 1=  estates: tea, coffee, forestry 
replace occupations = 1  if strpos(q221other, "Dairy") >0
replace q221other= "" if strpos(q221other, "Dairy") >0

replace occupations = 1  if strpos(q221other, "farm") >0
replace q221other= "" if strpos(q221other, "farm") >0

replace occupations = 1  if strpos(q221other, "Cattle") >0
replace q221other= "" if strpos(q221other, "Cattle") >0

replace occupations = 1  if strpos(q221other, "mill") >0
replace q221other= "" if strpos(q221other, "mill") >0

replace occupations = 1  if strpos(q221other, "tea") >0
replace q221other= "" if strpos(q221other, "tea") >0


*others for 2=  manufacturing, mining and building trade
replace occupations = 2  if inlist(q221other, "Miner", "miner", "Mining") 
replace q221other= ""  if inlist(q221other, "Miner", "miner", "Mining") 

replace occupations = 2  if inlist(q221other, "Capenter", "Carpentry", "Carpetry", "Builder", "Bulder") 

replace occupations = 2  if inlist(q221other,"Bukabuka construction", "Concrete crusher", "Stone crusher", "Welder", "Sawing", "Blaster") 

replace q221other= "" if inlist(q221other, "Capenter", "Carpentry", "Carpetry", "Builder", "Bulder") 
replace q221other= "" if inlist(q221other, "Bukabuka construction", "Concrete crusher", "Stone crusher", "Welder", "Sawing","Blaster")

replace occupations = 2  if strpos(q221other, "Brick") >0
replace q221other= "" if strpos(q221other, "Brick") >0

replace occupations = 2  if strpos(q221other, "Construct") >0
replace q221other= "" if strpos(q221other, "Construct") >0

replace occupations = 2  if strpos(q221other, "Gold") >0
replace q221other= "" if strpos(q221other, "Gold") >0

replace occupations = 2  if strpos(q221other, "Mechanic") >0
replace q221other= "" if strpos(q221other, "Mechanic") >0

replace occupations = 2  if strpos(q221other, "building") >0
replace q221other= "" if strpos(q221other, "building") >0

replace occupations = 2  if strpos(q221other, "Electric") >0
replace q221other= "" if strpos(q221other, "Electric") >0

replace occupations = 2  if strpos(q221other, "electric") >0
replace q221other= "" if strpos(q221other, "electric") >0

replace occupations = 2  if strpos(q221other, "miner") >0
replace q221other= "" if strpos(q221other, "miner") >0

replace occupations = 2  if strpos(q221other, "Miner") >0
replace q221other= "" if strpos(q221other, "Miner") >0


**others for 3=  Police or army 
replace occupations = 3  if strpos(q221other, "Soldier") >0
replace q221other= "" if strpos(q221other, "Soldier") >0


**others for 4=  Teacher
replace occupations = 4  if strpos(q221other, "teacher") >0
replace q221other= "" if strpos(q221other, "teacher") >0

replace occupations = 4  if strpos(q221other, "Teacher") >0
replace q221other= "" if strpos(q221other, "Teacher") >0


*others for 6 = for nurse or doctor (healthcare)
replace occupations = 6  if strpos(q221other, "Nurse") >0
replace q221other= "" if strpos(q221other, "Nurse") >0

replace occupations = 6  if strpos(q221other, "health") >0
replace q221other= "" if strpos(q221other, "health") >0

replace occupations = 6  if strpos(q221other, "Health") >0
replace q221other= "" if strpos(q221other, "Health") >0

replace occupations = 6  if strpos(q221other, "care") >0
replace q221other= "" if strpos(q221other, "care") >0

replace occupations = 6  if strpos(q221other, "Care") >0
replace q221other= "" if strpos(q221other, "Care") >0

replace occupations = 6  if strpos(q221other, "Social") >0
replace q221other= "" if strpos(q221other, "Social") >0



*others for 7 = Services or retail shops
replace occupations = 7  if inlist(q221other, "Tiler", "Till operator",  "Shop assistant", "Shoe retailer", "Shoe maker", "Sales lady", "Food outlet")

replace occupations = 7  if inlist(q221other, "Proffessional Chef", "Hotel chef", "Shop assistant", "Retailing")


replace q221other= "" if inlist(q221other, "Tiler", "Till operator", " Shop assistant", "Shoe retailer", "Shoe maker", "Sales lady", "Food outlet")

replace q221other= "" if inlist(q221other, "Proffessional Chef", "Hotel chef", "Shop assistant", "Retailing", "Chef") 

replace occupations = 7  if strpos(q221other, "Hair") >0
replace q221other= "" if strpos(q221other, "Hair") >0

replace occupations = 7  if strpos(q221other, "hair") >0
replace q221other= "" if strpos(q221other, "hair") >0

replace occupations = 7  if strpos(q221other, "cook") >0
replace q221other= "" if strpos(q221other, "cook") >0

replace occupations = 7  if strpos(q221other, "Cook") >0
replace q221other= "" if strpos(q221other, "Cook") >0

replace occupations = 7  if strpos(q221other, "Grooming") >0
replace q221other= "" if strpos(q221other, "Grooming") >0


*others for 8 = informal: petty trading 
replace occupations = 8  if strpos(q221other, "Selling") >0
replace q221other= "" if strpos(q221other, "Selling") >0

replace occupations = 8  if strpos(q221other, "Vend") >0
replace q221other= "" if strpos(q221other, "Vend") >0

replace occupations = 8  if strpos(q221other, "market") >0
replace q221other= "" if strpos(q221other, "market") >0

replace occupations = 8  if strpos(q221other, "Market") >0
replace q221other= "" if strpos(q221other, "Market") >0

replace occupations = 8  if strpos(q221other, "trade") >0
replace q221other= "" if strpos(q221other, "trade") >0

replace occupations = 8  if strpos(q221other, "Piece") >0
replace q221other= "" if strpos(q221other, "Piece") >0

replace occupations = 8  if strpos(q221other, "Part time jobs") >0
replace q221other= "" if strpos(q221other, "Part time jobs") >0

replace occupations = 8  if inlist(q221other, "Peace jobs", "Self employed", "Self employment", "Self job", "Own business") >0
replace q221other= "" if inlist(q221other, "Peace jobs", "Self employed", "Self employment", "Self job", "Own business") >0


*others for 9 informal subsistence agriculture 
replace occupations = 9  if inlist(q221other, "Broiler Rearing", "Broiler rearing") 
replace q221other= "" if inlist(q221other, "Broiler Rearing", "Broiler rearing")
replace occupations = 9  if strpos(q221other, "plot") >0
replace q221other= "" if strpos(q221other, "plot") >0


*others for 10- student

*others for 11- unemployed excl ag or not working
replace occupations = 11  if strpos(q221other, "Unemployed") >0
replace q221other= "" if strpos(q221other, "Unemployed") >0

replace occupations = 11  if inlist(q221other, "Unemplyed", "Unenmployed", "Unemployed", "Not employed", "Not working", "Not working because of age", "None")

replace occupations = 11  if inlist(q221other, "PENSIONER", "Pension", "Pensioneer", "Pensioner", "Retired")

replace q221other= "" if inlist(q221other, "Unemplyed", "Unenmployed", "Unemployed", "Not employed", "Not working", "Not working because of age",  "None") 

replace q221other= "" if inlist(q221other,"PENSIONER", "Pension", "Pensioneer", "Pensioner", "Retired") 

*others for 15- office worker
replace occupations = 15  if inlist(q221other, "School secretary", "Secertary", "Transport ministry", "ZINWA", "ZESA")
replace occupations = 15  if inlist(q221other, "Department of Agriculture", "Development Officer", "Council worker", "Register assistant", "Office assistant")
replace q221other= "" if inlist(q221other, "School secretary", "Secertary", "Transport ministry", "ZINWA", "ZESA")
replace q221other= "" if inlist(q221other, "Department of Agriculture", "Development Officer", "Council worker", "Register assistant", "Office assistant") 

replace occupations = 15  if strpos(q221other, "Ministry" ) >0
replace q221other= "" if strpos(q221other, "Ministry" ) >0

replace occupations = 15  if strpos(q221other, "office" ) >0
replace q221other= "" if strpos(q221other, "office" ) >0

replace occupations = 15  if strpos(q221other, "council" ) >0
replace q221other= "" if strpos(q221other, "council" ) >0


*create some new categories 
//16 - transport services
replace occupations = 16  if strpos(q221other, "Bus") >0
replace occupations = 16  if strpos(q221other, "driver") >0
replace occupations = 16  if strpos(q221other, "Driver") >0

replace q221other= "" if strpos(q221other, "Bus") 
replace q221other= ""  if strpos(q221other, "driver")
replace q221other= "" if strpos(q221other, "Driver")

replace occupations = 16  if inlist(q221other, "Transporter")
replace q221other= ""  if inlist(q221other, "Transporter")


//17 - sex workers
replace occupations = 17 if strpos(q221other, "sex") >0
replace q221other= "" if strpos(q221other, "sex") 

replace occupations = 17 if strpos(q221other, "Sex") >0
replace q221other= "" if strpos(q221other, "Sex") 


//18 - homemakers/housework or general hand
replace occupations = 18 if strpos(q221other, "Home") >0
replace occupations = 18 if strpos(q221other, "House") >0
replace occupations = 18 if strpos(q221other, "Hpuse") >0
replace occupations = 18 if strpos(q221other, "Maid") >0
replace occupations = 18 if strpos(q221other, "Domestic") >0
replace occupations = 18 if strpos(q221other, "Garden") >0
replace occupations = 18 if strpos(q221other, "Gardn") >0
replace occupations = 18 if strpos(q221other, "General") >0
replace occupations = 18 if strpos(q221other, "Land") >0


replace q221other= "" if strpos(q221other, "Home") >0 
replace q221other= ""  if strpos(q221other, "House") >0 
replace q221other= "" if strpos(q221other, "Hpuse") >0  
replace q221other= ""  if strpos(q221other, "Maid")  >0 
replace q221other= ""  if strpos(q221other, "Domestic") >0
replace q221other= ""  if strpos(q221other, "Garden") >0
replace q221other= ""  if strpos(q221other, "Gardn") >0
replace q221other= ""  if strpos(q221other, "General") >0
replace q221other= ""  if strpos(q221other, "Land") >0

replace occupation = 99 if occupations ==.
tab q221other
tab occupation

label define occupations 1 "Estates: tea, coffee, forestry" 2 "Manufacturing, mining or building" 3 "Police or army" 4 "Teacher :  primary school or seconda" 6 "Nurse or doctor" 7 "Services or retail" 8 "Informal: petty trading (veg etc)" 9 "Informal: subsistence ag" 10 "Student" 11 "Unemployed excl. ag" 12 "Other (specify)" 15 "Office worker" 16 "Transport worker" 17 "Sex worker" 18 "Homemaker, housework or general hand"99 "missing", replace 

label values occupations occupations 

tab occupations,m

*age variables
rename q204 age 
tab age
// clean a little - assuming this survey was taken in 2021, 2003 is year of birth so age is person is 18 years old
replace age = 18 if age == 2003



*rename first

rename q641weeka ld_work_wku15
rename q641weekb ld_work_wk15_44
rename q641weekc ld_work_wk45_64
rename q641weekd ld_work_wk65plus
rename q641weekendsa ld_work_weu15
rename q641weekendsb ld_work_we15_44
rename q641weekendsc ld_work_we45_64
rename q641weekendsd ld_work_we65plus
rename q642weeka ld_school_wku15
rename q642weekb ld_school_wk15_44
rename q642weekc ld_school_wk45_64
rename q642weekd ld_school_wk65plus
rename q642weekendsa ld_school_weu15
rename q642weekendsb ld_school_we15_44
rename q642weekendsc ld_school_we45_64
rename q642weekendsd ld_school_we65plus
rename q643weeka ld_trans_wku15
rename q643weekb ld_trans_wk15_44
rename q643weekc ld_trans_wk45_64
rename q643weekd ld_trans_wk65plus
rename q643weekendsa ld_trans_weu15
rename q643weekendsb ld_trans_we15_44
rename q643weekendsc ld_trans_we45_64
rename q643weekendsd ld_trans_we65plus
rename q644weeka ld_home_wku15
rename q644weekb ld_home_wk15_44
rename q644weekc ld_home_wk45_64
rename q644weekd ld_home_wk65plus
rename q644weekendsa ld_home_weu15
rename q644weekendsb ld_home_we15_44
rename q644weekendsc ld_home_we45_64
rename q644weekendsd ld_home_we65plus
rename q645weeka ld_ent_wku15
rename q645weekb ld_ent_wk15_44
rename q645weekc ld_ent_wk45_64
rename q645weekd ld_ent_wk65plus
rename q645weekendsa ld_ent_weu15
rename q645weekendsb ld_ent_we15_44
rename q645weekendsc ld_ent_we45_64
rename q645weekendsd ld_ent_we65plus

rename q646weeka ld_other_wku15
rename q646weekb ld_other_wk15_44
rename q646weekc ld_other_wk45_64
rename q646weekd ld_other_wk65plus
rename q646weekendsa ld_other_weu15
rename q646weekendsb ld_other_we15_44
rename q646weekendsc ld_other_we45_64
rename q646weekendsd ld_other_we65plus

rename beforeq641weeka  nld_work_wku15
rename beforeq641weekb  nld_work_wk15_44
rename beforeq641weekc  nld_work_wk45_64
rename beforeq641weekd  nld_work_wk65plus
rename beforeq641weekendsa nld_work_weu15
rename beforeq641weekendsb nld_work_we15_44
rename beforeq641weekendsc nld_work_we45_64
rename beforeq641weekendsd nld_work_we65plus
rename beforeq642weeka  nld_school_wku15
rename beforeq642weekb  nld_school_wk15_44
rename beforeq642weekc  nld_school_wk45_64
rename beforeq642weekd  nld_school_wk65plus
rename beforeq642weekendsa nld_school_weu15
rename beforeq642weekendsb nld_school_we15_44
rename beforeq642weekendsc nld_school_we45_64
rename beforeq642weekendsd nld_school_we65plus
rename beforeq643weeka  nld_trans_wku15
rename beforeq643weekb  nld_trans_wk15_44
rename beforeq643weekc  nld_trans_wk45_64
rename beforeq643weekd  nld_trans_wk65plus
rename beforeq643weekendsa nld_trans_weu15
rename beforeq643weekendsb nld_trans_we15_44
rename beforeq643weekendsc nld_trans_we45_64
rename beforeq643weekendsd nld_trans_we65plus
rename beforeq644weeka  nld_home_wku15
rename beforeq644weekb  nld_home_wk15_44
rename beforeq644weekc  nld_home_wk45_64
rename beforeq644weekd  nld_home_wk65plus
rename beforeq644weekendsa nld_home_weu15
rename beforeq644weekendsb nld_home_we15_44
rename beforeq644weekendsc nld_home_we45_64
rename beforeq644weekendsd nld_home_we65plus
rename beforeq645weeka  nld_ent_wku15
rename beforeq645weekb  nld_ent_wk15_44
rename beforeq645weekc  nld_ent_wk45_64
rename beforeq645weekd  nld_ent_wk65plus
rename beforeq645weekendsa nld_ent_weu15
rename beforeq645weekendsb nld_ent_we15_44
rename beforeq645weekendsc nld_ent_we45_64
rename beforeq645weekendsd nld_ent_we65plus
rename beforeq646weeka  nld_other_wku15
rename beforeq646weekb  nld_other_wk15_44
rename beforeq646weekc  nld_other_wk45_64
rename beforeq646weekd  nld_other_wk65plus
rename beforeq646weekendsa nld_other_weu15
rename beforeq646weekendsb nld_other_we15_44
rename beforeq646weekendsc nld_other_we45_64
rename beforeq646weekendsd nld_other_we65plus

*then label 
label variable ld_work_wku15 "ld work   u15yrs - wk"
label variable ld_work_wk15_44 "ld work   15_44yrs - wk"
label variable ld_work_wk45_64 "ld work   45_64yrs - wk"
label variable ld_work_wk65plus "ld work   65plusyrs - wk"
label variable ld_work_weu15 "ld work   u15yrs - we"
label variable ld_work_we15_44 "ld work   15_44yrs - we"
label variable ld_work_we45_64 "ld work   45_64yrs - we"
label variable ld_work_we65plus "ld work   65plusyrs - we"
label variable ld_school_wku15 "ld school  u15yrs - wk"
label variable ld_school_wk15_44 "ld school  15_44yrs - wk"
label variable ld_school_wk45_64 "ld school  45_64yrs - wk"
label variable ld_school_wk65plus "ld school  65plusyrs - wk"
label variable ld_school_weu15 "ld school  u15yrs - we"
label variable ld_school_we15_44 "ld school  15_44yrs - we"
label variable ld_school_we45_64 "ld school  45_64yrs - we"
label variable ld_school_we65plus "ld school  65plusyrs - we"
label variable ld_trans_wku15 "ld transport  u15yrs - wk"
label variable ld_trans_wk15_44 "ld transport  15_44yrs - wk"
label variable ld_trans_wk45_64 "ld transport  45_64yrs - wk"
label variable ld_trans_wk65plus "ld transport  65plusyrs - wk"
label variable ld_trans_weu15 "ld transport  u15yrs - we"
label variable ld_trans_we15_44 "ld transport  15_44yrs - we"
label variable ld_trans_we45_64 "ld transport  45_64yrs - we"
label variable ld_trans_we65plus "ld transport  65plusyrs - we"
label variable ld_home_wku15 "ld home  u15yrs - wk"
label variable ld_home_wk15_44 "ld home  15_44yrs - wk"
label variable ld_home_wk45_64 "ld home  45_64yrs - wk"
label variable ld_home_wk65plus "ld home  65plusyrs - wk"
label variable ld_home_weu15 "ld home  u15yrs - we"
label variable ld_home_we15_44 "ld home  15_44yrs - we"
label variable ld_home_we45_64 "ld home  45_64yrs - we"
label variable ld_home_we65plus "ld home  65plusyrs - we"
label variable ld_ent_wku15 "ld ent  u15yrs - wk"
label variable ld_ent_wk15_44 "ld ent  15_44yrs - wk"
label variable ld_ent_wk45_64 "ld ent  45_64yrs - wk"
label variable ld_ent_wk65plus "ld ent  65plusyrs - wk"
label variable ld_ent_weu15 "ld ent  u15yrs - we"
label variable ld_ent_we15_44 "ld ent  15_44yrs - we"
label variable ld_ent_we45_64 "ld ent  45_64yrs - we"
label variable ld_ent_we65plus "ld ent  65plusyrs - we"
label variable nld_work_wku15 "nldwork   u15yrs - wk"
label variable nld_work_wk15_44 "nldwork   15_44yrs - wk"
label variable nld_work_wk45_64 "nldwork   45_64yrs - wk"
label variable nld_work_wk65plus "nldwork   65plusyrs - wk"
label variable nld_work_weu15 "nldwork   u15yrs - we"
label variable nld_work_we15_44 "nldwork   15_44yrs - we"
label variable nld_work_we45_64 "nldwork   45_64yrs - we"
label variable nld_work_we65plus "nldwork   65plusyrs - we"
label variable nld_school_wku15 "nldschool  u15yrs - wk"
label variable nld_school_wk15_44 "nldschool  15_44yrs - wk"
label variable nld_school_wk45_64 "nldschool  45_64yrs - wk"
label variable nld_school_wk65plus "nldschool  65plusyrs - wk"
label variable nld_school_weu15 "nldschool  u15yrs - we"
label variable nld_school_we15_44 "nldschool  15_44yrs - we"
label variable nld_school_we45_64 "nldschool  45_64yrs - we"
label variable nld_school_we65plus "nldschool  65plusyrs - we"
label variable nld_trans_wku15 "nldtransport  u15yrs - wk"
label variable nld_trans_wk15_44 "nldtransport  15_44yrs - wk"
label variable nld_trans_wk45_64 "nldtransport  45_64yrs - wk"
label variable nld_trans_wk65plus "nldtransport  65plusyrs - wk"
label variable nld_trans_weu15 "nldtransport  u15yrs - we"
label variable nld_trans_we15_44 "nldtransport  15_44yrs - we"
label variable nld_trans_we45_64 "nldtransport  45_64yrs - we"
label variable nld_trans_we65plus "nldtransport  65plusyrs - we"
label variable nld_home_wku15 "nldhome  u15yrs - wk"
label variable nld_home_wk15_44 "nldhome  15_44yrs - wk"
label variable nld_home_wk45_64 "nldhome  45_64yrs - wk"
label variable nld_home_wk65plus "nldhome  65plusyrs - wk"
label variable nld_home_weu15 "nldhome  u15yrs - we"
label variable nld_home_we15_44 "nldhome  15_44yrs - we"
label variable nld_home_we45_64 "nldhome  45_64yrs - we"
label variable nld_home_we65plus "nldhome  65plusyrs - we"
label variable nld_ent_wku15 "nldent  u15yrs - wk"
label variable nld_ent_wk15_44 "nldent  15_44yrs - wk"
label variable nld_ent_wk45_64 "nldent  45_64yrs - wk"
label variable nld_ent_wk65plus "nldent  65plusyrs - wk"
label variable nld_ent_weu15 "nldent  u15yrs - we"
label variable nld_ent_we15_44 "nldent  15_44yrs - we"
label variable nld_ent_we45_64 "nldent  45_64yrs - we"
label variable nld_ent_we65plus "nldent  65plusyrs - we"
label variable nld_other_wku15 "nldother  u15yrs - wk"
label variable nld_other_wk15_44 "nldother  15_44yrs - wk"
label variable nld_other_wk45_64 "nldother  45_64yrs - wk"
label variable nld_other_wk65plus "nldother  65plusyrs - wk"
label variable nld_other_weu15 "nldother  u15yrs - we"
label variable nld_other_we15_44 "nldother  15_44yrs - we"
label variable nld_other_we45_64 "nldother  45_64yrs - we"
label variable nld_other_we65plus "nldother  65plusyrs - we"

label variable ld_other_wku15 "ld other  u15yrs - wk"
label variable ld_other_wk15_44 "ld other  15_44yrs - wk"
label variable ld_other_wk45_64 "ld other  45_64yrs - wk"
label variable ld_other_wk65plus "ld other  65plusyrs - wk"
label variable ld_other_weu15 "ld other  u15yrs - we"
label variable ld_other_we15_44 "ld other  15_44yrs - we"
label variable ld_other_we45_64 "ld other  45_64yrs - we"
label variable ld_other_we65plus "ld other  65plusyrs - we"

label dir
numlabel `r(names)', add
e
save "raw/IVQ_R8_renamed.dta", replace
