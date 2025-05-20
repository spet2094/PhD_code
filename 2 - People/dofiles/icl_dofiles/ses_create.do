//R7 Create SES variable

global dsn "Database"
global user "DB_A1EF79_yzuhp_admin"
global pass "S3v3rP@ssW0rd"


odbc load, table("hhindent_7") dsn("$dsn") user("$user") password("$pass")


*SES R7

*PROJECT - HIV/Covid 
*AIM - create SES groups
*DATE - September 2021
**	This do-file creates a wealth index variable based on data from the household survey of YZ-UHP 
*   It uses a methodology adapted from previous Manicaland Cohort survey rounds. 
*   This was originally developed by Nadine Schur. 
*-----------------------------------

**Input data from R7_hhindent

destring hhid, force replace
destring hhkey, force replace
destring site, force replace

* Water source (from best to worst)
rename watersource_r7 water
destring water, force replace
recode water 99 = 7

* Toilet type (from best to worst)
destring toilet_r7 toiletshared_r7, force replace
rename toilet_r7 toilet_type
recode toilet_type 5 99 = 4
rename toiletshared_r7 talone
gen toilet = .
replace toilet=1 if (toilet_type==1 | toilet_type==2) & talone==1 
replace toilet=2 if (toilet_type==1 | toilet_type==2) & (talone==2 | talone==3 | talone==.)
replace toilet=3 if (toilet_type==3 | toilet_type==4) & (talone==1)
replace toilet=4 if (toilet_type==3 | toilet_type==4) & (talone==2 | talone==3 | talone==.)
replace toilet=. if mi(toilet_type)

* Electricity
destring electricity_r7, force replace
rename electricity_r7 electr

* Fridge
destring fridge_r7, force replace
rename fridge_r7 fridge

* Radio
destring radio_r7, force replace
rename radio_r7 radio

* TV
destring tv_r7, force replace
rename tv_r7 tv

* House type (from best to worst)
destring hsetype_r7, force replace
rename hsetype_r7 house
recode house 3=1 8=2 2=3 1=4

* Floor type (from best to worst)
destring hsefloor_r7, force replace
rename hsefloor_r7 floor
recode floor 1=3 3=1

* Bike
destring bicycle_r7, force replace
rename bicycle_r7 bike

* Motorcycle
destring motorcycle_r7, force replace
rename motorcycle_r7 mbike

* Car
destring car_r7, force replace 
rename car_r7 car

* Tractor
destring tractor_r7, force replace
rename tractor_r7 tractor

*** Calculate continuous index
* For each variable, the response is subtracted from the number of response possibilities
* and divided by the number of response possibilities minus 1. 
* What this does is to create values between 0 and 1 for each variable.
* The overall number is divided by the number of variables. 

gen ses=((7-water)/6 /// Water source
+(4-toilet)/3 /// Toilet type
+(2-electr)+(2-fridge)+(2-radio)+(2-tv) /// Household owns
+(4-house)/3+(3-floor)/2 /// Type of house and floor
+(2-bike)+(2-mbike)+(2-car)+(2-tractor)) /// Any member of household owns 
/12 // Number of variables


***Generate ses_grp*** ***ALTERED FOR R7 data - approx 20% in each SES_grp
centile (ses), centile(20 40 60 80)

gen ses_quint=.
replace ses_quint = 0 if ses<=0.25
replace ses_quint = 1 if ses>0.25  & ses<=0.3055556 
replace ses_quint = 2 if ses>0.3055556   & ses<=0.4583333 
replace ses_quint = 3 if ses>0.4583333  & ses<=0.6111111
replace ses_quint = 4 if ses>0.6111111

replace ses_quint=. if ses==.

label variable ses_quint "SES index quintile"
label define ses_quint 0 "Poorest" 1 "2nd poorest" 2 "3rd poorest" 3 "4th poorest" 4 "Least poor"
label value ses_quint ses_quint

***Generate ses exact - ses_quintforce
	sort ses
	gen ses_quintforce=ses_quint

	//1. Move 187 from ses_quint 0  to ses_quint 1
	browse ses if ses_quintforce==0
	sort ses
	
	*Highest SES score in ses_quintforce 0 is 0.25
	*Generate random number for obs with this SES score
	generate rannum = uniform() if ses==0.25
	*Pick the lowest 2 random values with this SES score and replace SES_quint
	browse rannum if ses==0.25
	sort rannum
	generate grp = .
	replace grp = 1 in 1/187
	replace ses_quintforce=1 if grp==1
	
	drop rannum
	drop grp
	
	//2. Next move 89 from ses_quintforce 1 to ses_quintforce 2
	browse ses if ses_quintforce==1
	sort ses
	*Highest SES score in ses_quintforce 2 = 0.30555555
	*Generate random number for obs with this SES score
	generate rannum = uniform() if ses<=0.30555556  & ses>=0.30555554
	*Pick the smallest 112 random values with this SES score and replace SES_quintforce
	browse rannum if ses<=0.30555556  & ses>=0.30555554
	sort rannum
	gen grp=.
	replace grp = 2 in 1/89
	replace ses_quintforce=2 if grp==2
	tab ses_quintforce
	
	drop rannum
	drop grp

	//3. Next move 3 from ses_quint 3 to ses_quint 2
	browse ses if ses_quintforce==3
	sort ses
	*Lowest SES score in ses_quintforcce 3 = 0.45833334
	*Generate random number for obs with this SES score
	generate rannum = uniform() if ses<=0.45833335 & ses>=0.45833333
	*Pick smallest 111 random values with this SES score and replace SES_quintforce
	browse rannum ses ses_quint ses_quintforce if ses<=0.45833335 & ses>=0.45833333
	sort rannum
	gen grp=.
	replace grp = 1 in 1/3
	replace ses_quintforce=2 if grp==1
	tab ses_quintforce	
	
	drop rannum
	drop grp
	
	//4. Next move 234 from ses_quint 4 to ses_quint 3
	browse ses if ses_quintforce==4
	sort ses
	*Lowest SES score in ses_quintforcce 4 = 0.6111111
	*Generate random number for obs with this SES score
	generate rannum = uniform() if ses<=0.6111112 & ses>=0.6111110
	*Pick smallest 111 random values with this SES score and replace SES_quintforce
	browse rannum ses ses_quint ses_quintforce if ses<=0.6111112 & ses>=0.6111110
	sort rannum
	gen grp=.
	replace grp = 1 in 1/234
	replace ses_quintforce=3 if grp==1
	drop rannum
	drop grp

	tab ses_quintforce


**SES_grp

gen ses_grp=.
replace ses_grp = 0 if ses<0.2
replace ses_grp = 1 if ses>=0.2  & ses<=0.4
replace ses_grp = 2 if ses>0.4  & ses<=0.6
replace ses_grp = 3 if ses>0.6 & ses<=0.8
replace ses_grp = 4 if ses>0.8
replace ses_grp = . if mi(ses)

label variable ses_grp "SES index group"
label define ses_grp 0 "Poorest" 1 "2nd poorest" 2 "3rd poorest" 3 "4th poorest" 4 "Least poor"
label value ses_grp ses_grp


keep hhkey hhid yeshh_7 ses ses_grp ses_quint ses_quintforce

save "C:\Users\remorris\Documents\SRB and Prevention Methods Paper\SRB cross sectional\R8_create\ses variable\R7_SES.dta", replace


clear


odbc load, table("R8_hhindent") dsn("$dsn") user("$user") password("$pass")


*SES R8

*PROJECT - HIV/Covid 
*AIM - create SES groups
*DATE - September 2021
**	This do-file creates a wealth index variable based on data from the household survey of YZ-UHP 
*   It uses a methodology adapted from previous Manicaland Cohort survey rounds. 
*   This was originally developed by Nadine Schur. 
*-----------------------------------

**Input data from R8_hhindent

destring hhid, force replace
destring hhkey, force replace
destring site, force replace

* Water source (from best to worst)
rename watersource_r8 water
destring water, force replace
recode water 99 = 7

* Toilet type (from best to worst)
destring toilet_r8 toiletshared_r8, force replace
rename toilet_r8 toilet_type
recode toilet_type 5 99 = 4
rename toiletshared_r8 talone
gen toilet = .
replace toilet=1 if (toilet_type==1 | toilet_type==2) & talone==1 
replace toilet=2 if (toilet_type==1 | toilet_type==2) & (talone==2 | talone==3 | talone==.)
replace toilet=3 if (toilet_type==3 | toilet_type==4) & (talone==1)
replace toilet=4 if (toilet_type==3 | toilet_type==4) & (talone==2 | talone==3 | talone==.)
replace toilet=. if mi(toilet_type)

* Electricity
destring electricity_r8, force replace
rename electricity_r8 electr

* Fridge
destring fridge_r8, force replace
rename fridge_r8 fridge

* Radio
destring radio_r8, force replace
rename radio_r8 radio

* TV
destring tv_r8, force replace
rename tv_r8 tv

* House type (from best to worst)
destring hsetype_r8, force replace
rename hsetype_r8 house
recode house 3=1 8=2 2=3 1=4

* Floor type (from best to worst)
destring hsefloor_r8, force replace
rename hsefloor_r8 floor
recode floor 1=3 3=1

* Bike
destring bicycle_r8, force replace
rename bicycle_r8 bike

* Motorcycle
destring motorcycle_r8, force replace
rename motorcycle_r8 mbike

* Car
destring car_r8, force replace 
rename car_r8 car

* Tractor
destring tractor_r8, force replace
rename tractor_r8 tractor

*** Calculate continuous index
* For each variable, the response is subtracted from the number of response possibilities
* and divided by the number of response possibilities minus 1. 
* What this does is to create values between 0 and 1 for each variable.
* The overall number is divided by the number of variables. 

gen ses=((7-water)/6 /// Water source
+(4-toilet)/3 /// Toilet type
+(2-electr)+(2-fridge)+(2-radio)+(2-tv) /// Household owns
+(4-house)/3+(3-floor)/2 /// Type of house and floor
+(2-bike)+(2-mbike)+(2-car)+(2-tractor)) /// Any member of household owns 
/12 // Number of variables


***Generate ses_quint*** ***Groups ALTERED FOR R8 data - approx 20% in each SES_grp ---> not exact
centile (ses), centile(20 40 60 80)

gen ses_quint=.
replace ses_quint = 0 if ses<=0.2638889  
replace ses_quint = 1 if ses>0.2638889  & ses<=0.3333335 
replace ses_quint = 2 if ses>0.3333335    & ses<=0.4444444 
replace ses_quint = 3 if ses>0.4444444  & ses<=0.5833333 
replace ses_quint = 4 if ses>0.5833333 

replace ses_quint=. if ses==.
label variable ses_quint "SES index quintile"
label define ses_quint 0 "Poorest" 1 "2nd poorest" 2 "3rd poorest" 3 "4th poorest" 4 "Least poor"
label value ses_quint ses_quint

***Generate ses exact - ses_quintforce

	sort ses
	gen ses_quintforce=ses_quint

	//1. Move 228 from ses_quint 0  to ses_quint 1
	browse ses if ses_quintforce==0
	sort ses
	*Highest SES score in ses_quintforce 1 is .2638889
	*Generate random number for obs with this SES score
	generate rannum = uniform() if ses<=0.2638890 & ses>=0.2638888
	*Pick the lowest 2 random values with this SES score and replace SES_quint
	browse rannum if ses<=0.2638890 & ses>=0.2638888
	sort rannum
	generate grp = .
	replace grp = 1 in 1/228
	replace ses_quintforce=1 if grp==1
	
	drop rannum
	drop grp
	
	//2. Next move 112 from ses_quintforce 1 to ses_quintforce 2
	browse ses if ses_quintforce==1
	sort ses
	*Highest SES score in ses_quintforce 2 = 0.33333334 
	*Generate random number for obs with this SES score
	generate rannum = uniform() if ses<=0.33333335  & ses>=0.33333333
	*Pick the smallest 112 random values with this SES score and replace SES_quintforce
	browse rannum if ses<=0.33333335  & ses>=0.33333333
	sort rannum
	gen grp=.
	replace grp = 2 in 1/112
	replace ses_quintforce=2 if grp==2
	
	drop rannum
	drop grp
	tab ses_quintforce

	//3. Next move 115 from ses_quint 3 to ses_quint 2
	browse ses if ses_quintforce==3
	sort ses
	*Lowest SES score in ses_quintforcce 3 = .44444445
	*Generate random number for obs with this SES score
	generate rannum = uniform() if ses<=0.44444446 & ses>=0.44444444
	*Pick smallest 111 random values with this SES score and replace SES_quintforce
	browse rannum ses ses_quint ses_quintforce if ses<=0.44444446 & ses>=0.44444444
	sort rannum
	gen grp=.
	replace grp = 1 in 1/115
	replace ses_quintforce=2 if grp==1
	drop rannum
	drop grp

	tab ses_quintforce
	
	//4. Next move 54 from ses_quint 4 to ses_quint 3
	browse ses if ses_quintforce==4
	sort ses
	*Lowest SES score in ses_quintforcce 4 = .58333331
	*Generate random number for obs with this SES score
	generate rannum = uniform() if ses<=0.58333332 & ses>=0.58333330
	*Pick smallest 111 random values with this SES score and replace SES_quintforce
	browse rannum ses ses_quint ses_quintforce if ses<=0.58333332 & ses>=0.58333330
	sort rannum
	gen grp=.
	replace grp = 1 in 1/54
	replace ses_quintforce=3 if grp==1
	drop rannum
	drop grp

	tab ses_quintforce

	
***Generate SES group
	gen ses_grp=.
	replace ses_grp = 0 if ses<0.2
	replace ses_grp = 1 if ses>=0.2  & ses<=0.4
	replace ses_grp = 2 if ses>0.4  & ses<=0.6
	replace ses_grp = 3 if ses>0.6 & ses<=0.8
	replace ses_grp = 4 if ses>0.8
	replace ses_grp = . if mi(ses)

	label variable ses_grp "SES index group"
	label define ses_grp 0 "Poorest" 1 "2nd poorest" 2 "3rd poorest" 3 "4th poorest" 4 "Least poor"
	label value ses_grp ses_grp
	
	
keep hhkey hhid yeshh_8 ses ses_grp ses_quint ses_quintforce

save "C:\Users\remorris\Documents\SRB and Prevention Methods Paper\SRB cross sectional\R8_create\ses variable\R8_SES.dta", replace

keep hhkey ses 

save "C:\Users\remorris\Documents\R8_SES.dta", replace
