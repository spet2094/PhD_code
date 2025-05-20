* Select the sample for occupation

********************************************************************
* Manicaland Centre Project - Human contact data. 
* Do-file: Processing and cleaning
* Autor: Sophie
* Fecha: 31/05/2023
********************************************************************

clear all
set more off

*Directory
cap cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/08_Fieldwork/08_Data/R9_data/"


use "stata_input/r9_ivqselect_feb2023_v3_newVars.dta", replace
format hhmem_key 
tab occupation
* two areas to keep for sample selection are Selborne and Sakubva 
tab site
tab site, nol
e
*5=selborne (rural) , 9 = watsomba (if i don't want the ag estate), 14 = Sakubva 
keep if inlist(site, 5,14)
keep if inlist(site, 5,14)

* identify the mean and median number of contacts by occupational category in the data

tabstat tot_contacts_yest, by(occ_2) stat(mean min max q sd) 
tabstat tot_contacts_yest, by(occupation) stat(mean min max q sd)
*generate the 4 larger categories based on contact distributions
** look at mv test - multivariate test of means
mvtest means tot_contacts_yest, by(occupation) 

// means are statistically different from one another - this is good for me. 

** look at a K-S test for the ones I would think of grouping together
*e.g. blue collar = ag estate, manufacturing, 


*within each site (selborne - rur, hobhouse -urb), choose total 40 people from which the sample of 20 can be drawn. 


** within RUR - Selbourne (estate)
 
mvtest means tot_contacts_yest if occ_2 == 2, by(occupation) 
mvtest means tot_contacts_yest if occ_2 == 3, by(occupation) 
mvtest means tot_contacts_yest if occ_2 == 4, by(occupation) 
// Great - now new occ categories are not sig different within eachother

*** 1. blue collar category - use 4 typical and 1 deviant, 2 male 2 female, 1 whichever

tabstat tot_contacts_yest if occ_2 == 1, by(occupation) stat(mean min max q)
tabstat age if occ_2 == 1, by(occupation) stat(mean min max q) // tmean over 25 under 41 


tab occupation gender, row nofreq // more female on ag estates, industy typically male, service/retail male, informal even split, more male. So 1 from ag (female), 1 from industry (male) 1 from service (male), 1 from informal (female). Then one wildcard outlier (who have p75 to max number of contacts)
tab occupation site, row nofreq
tab occ_2 site, row nofreq
tab site
tab occupation gender if occ_2==1, row nofreq

* pick 1 female ag workers from Selbourne (rural)
tabstat tot_contacts_yest, by(occupation) stat(mean min max q sd)
tabstat age, by(occupation) stat(mean q)

br hhmem_key age gender site occupation tot_contacts_yest all_work_yest ///
	if 	site ==5 ///
	& occupation ==1 & gender == 2 ///
	& tot_contacts_yest >=4 & tot_contacts_yest <=20 ///
	& age >=33 & age <=49


* pick 1 male ind worker from Selbourne (rural)
br hhmem_key age gender site occupation tot_contacts_yest all_work_yest ///
	if site ==5 ///
	& occupation ==2 & gender == 1 ///
	& tot_contacts_yest >=5 & tot_contacts_yest <=23.5 ///
	& age >=28 & age <=48.5 

* pick 1 male service worker Sakubva (urban)
br hhmem_key age gender site occupation tot_contacts_yest all_work_yest ///
	if site ==5 ///
	& occupation ==7 & gender == 1 ///
	& tot_contacts_yest >=5 & tot_contacts_yest <=22 ///
	& age >=25 & age <=48

* pick 1 male informal worker Sakubva (urban) 
br hhmem_key age gender site occupation tot_contacts_yest all_work_yest ///
	if site ==5 ///
	& occupation ==8 & gender == 1 ///
	& tot_contacts_yest >=4 & tot_contacts_yest <=20.5 ///
	& age >=29 & age <=48
	
* pick 1 female informal worker Sakubva (urban) 
br hhmem_key age gender site occupation tot_contacts_yest all_work_yest ///
	if site ==5 ///
	& occupation ==8 & gender == 2 ///
	& tot_contacts_yest >=4 & tot_contacts_yest <=20.5 ///
	& age >=29 & age <=48

* pick 1 wildcard - max contacts from any occupation in this category, either site
br hhmem_key age gender site occupation tot_contacts_yest all_work_yest ///
	if /// no site type specified
	occ_2==1  ///
	& tot_contacts_yest >100 & tot_contacts_yest !=.  /// over 100 contacts
	& age >=29 & age <=48.5


*** 2. public service category - use 4 typical and 1 deviant again, 2 male 2 female, 1 whichever 

tabstat tot_contacts_yest if occ_2 == 2, by(occupation) stat(mean min max q)
tabstat age if occ_2 == 2, by(occupation) stat(mean min max q)
tab occupation site if occ_2 == 2, row nofreq
tab occupation gender if occ_2 == 2, row nofreq

*pick 1 male doctor/nurse from Selbourne

br hhmem_key age gender site occupation tot_contacts_yest all_work_yest ///
	if site ==5 ///
	& occupation ==6 & gender == 1 ///
	& tot_contacts_yest >=11 & tot_contacts_yest <=24 ///
	& age >=50 & age <=58

*pick 1 male transport worker from Sakubva

br hhmem_key age gender site occupation tot_contacts_yest all_work_yest ///
	if site ==14 ///
	& occupation ==14 & gender == 1 ///
	& tot_contacts_yest >=7 & tot_contacts_yest <=55 ///
	& age >=27 & age <=45

*pick 1 male office worker from Sakubva
br hhmem_key age gender site occupation tot_contacts_yest all_work_yest ///
	if site ==14 ///
	& occupation ==15 & gender == 1 ///
	& tot_contacts_yest >=7 & tot_contacts_yest <=27.5 ///
	& age >=26.5 & age <=51.5
	
*pick a replacement office worker from Sakubva (unspecify male for bigger sample)
br hhmem_key age gender site occupation tot_contacts_yest all_work_yest ///
	if site ==14 ///
	& occupation ==15  ///
	


*pick 1 female healthcare worker from Sakubva
br hhmem_key age gender site occupation tot_contacts_yest all_work_yest ///
	if site ==14 ///
	& inlist(occupation,16,17) & gender == 2 ///
	& tot_contacts_yest >=2 & tot_contacts_yest <=14.5 ///
	& age >=33 & age <=49

*pick 1 wildcard - max contacts from any occupation in this category either site
br hhmem_key age gender site occupation tot_contacts_yest all_work_yest ///
	if occ_2==2 ///
	& tot_contacts_yest >100 & tot_contacts_yest !=. ///
	& age >=33 & age <=50

*pick 1 more wildcard - we don't have enough participants if we just choose >50 contacts so we go for those with contacts over the 75th percentile in this occ group
sum tot_contacts_yest if occ_2==2, d // >26 contacts == 75perc

br hhmem_key age gender site occupation tot_contacts_yest all_work_yest ///
	if occ_2==2 ///
	& site ==14 ///
	& tot_contacts_yest >26 & tot_contacts_yest !=. ///
// v3 removed upper limit in contacts

*** 3. students or teachers

tabstat tot_contacts_yest if occ_2 == 3, by(occupation) stat(mean min max q)
tab occupation site if occ_2 == 3, row nofreq
tab occupation gender if occ_2 == 3, row nofreq

* choose 1 male and one female student from Selborne
br hhmem_key age gender site occupation tot_contacts_yest all_work_yest if site ==5 ///
	& occupation ==10 & gender == 1 ///
	& tot_contacts_yest >=5 & tot_contacts_yest <=22

br hhmem_key age gender site occupation tot_contacts_yest all_work_yest if site ==5 ///
	& occupation ==10 & gender == 2 ///
	& tot_contacts_yest >22 & tot_contacts_yest !=.

* choose 1 male and one female student from Sakubva
br hhmem_key age gender site occupation tot_contacts_yest all_work_yest if site ==14 ///
	& occupation ==10 & gender == 2 ///
	& tot_contacts_yest >=5 & tot_contacts_yest <=22

br hhmem_key age gender site occupation tot_contacts_yest all_work_yest if site ==14 ///
	& occupation ==10 & gender == 1 ///
	& tot_contacts_yest >22 & tot_contacts_yest !=.


* choose 1 female teacher from Sakubva
tab occupation gender if occ_2 == 3, row nofreq

br hhmem_key age gender site occupation tot_contacts_yest all_work_yest if site ==14 ///
	& occupation ==4 & gender == 2 ///
	& tot_contacts_yest >4 & tot_contacts_yest <41

*** 4. Home makers, subsistence ag and not employed
 
tabstat tot_contacts_yest if occ_2 == 4, by(occupation) stat(mean min max q)
tab occupation site if occ_2 == 4, row nofreq
tab occupation gender if occ_2 == 4, row nofreq
tabstat age  if occ_2 == 4, by(occupation) stat(mean min max q)

* choose 1 female working in subsistence agriculture from Selbourne
br hhmem_key age gender site occupation tot_contacts_yest all_work_yest if site ==5 ///
	& occupation ==9 & gender == 2 ///
	& tot_contacts_yest >=3 & tot_contacts_yest <=8 ///
	& age >=34 & age <=51
	
* choose 1 unemployed female from Sakubva with IQR contacts 
br hhmem_key age gender site occupation tot_contacts_yest all_work_yest if site ==14 ///
	& occupation ==11 & gender == 2 ///
	& tot_contacts_yest >=3 & tot_contacts_yest <=8 ///
	& age >=23 & age <=52
	
* choose 1 unemployed male from Sakubva with IQR contacts 
br hhmem_key age gender site occupation tot_contacts_yest all_work_yest if site ==14 ///
	& occupation ==11 & gender == 1 ///
	& tot_contacts_yest >=3 & tot_contacts_yest <=8 ///
	& age >=23 & age <=52

* choose 1 unemployed female from Selborne with high end contacts
br hhmem_key age gender site occupation tot_contacts_yest all_work_yest if site ==5 ///
	& occupation ==11 & gender == 2 ///
	& tot_contacts_yest >20 & tot_contacts_yest!=. ///
	& age >=23 & age <=52
	
* choose 1 female homemaker from Selbourne
br hhmem_key age gender site occupation tot_contacts_yest all_work_yest if site ==5 ///
	& occupation ==19 & gender == 2 ///
	& tot_contacts_yest >=3 & tot_contacts_yest <=7 ///
	& age >=21 & age <=44

	
***** Check number of contacts in different locations for each of the ppts selected

preserve
destring hhmem_key, replace
format %13.0g hhmem_key
 
sort hhmem_key

keep if inlist(hhmem_key,500183101, 503242501, 503362202, 503468501, 503479905, 508342703, 508573701, 508573702, 508580702, 509180701, 510699801)

keep hhmem_key occupation occ_2 all_* tot_* 

export delimited using "../../05_sampling design/final_selection/selbourne_final_ppts.csv", replace



