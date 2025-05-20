* Select the sample for occupation

********************************************************************
* Manicaland Centre Project - Human contact data. 
* Do-file: Extract Model data on (a) number of contacts by occupation at work (b) bubble size by occupation 
* Autor: Sophie
* Fecha: 31/05/2023
*date of survey: July 2022 to March 2023

********************************************************************

*************************************************************************
**********SET UP & FINAL CLEANING (cleaning to be moved)****************
*************************************************************************

clear all
set more off
cap cd "/Users/sophieayling/Library/CloudStorage/GoogleDrive-sophie2ayling@gmail.com/My Drive/PhD/08_Fieldwork/08_Data/R9_data/"


use "stata_input/r9_ivqselect_feb2023_v3_newVars.dta", replace
format hhmem_key 
codebook hhmem_key

*socio-economic status breakdown 
tab ses_5 gender, col nofreq m
*gender vs occupation 

tab occ4 gender, col nofreq 

*remove outliers first 
replace tot_contacts_yest =. if tot_contacts_yest >1000
replace tot_contacts_sat =200 if tot_contacts_sat >200 & tot_contacts_sat !=.

*************************************************************************
*********SOCIAL CONTACTS YESTERDAY (CLOSEST EQUIV TO R8 ANALYSIS) ***
*************************************************************************

gen contacts_cat = tot_contacts_yest
replace contacts_cat =1 if tot_contacts_yest >=0 & tot_contacts_yest <=10
replace contacts_cat =2 if tot_contacts_yest >=11 & tot_contacts_yest <=20
replace contacts_cat =3 if tot_contacts_yest >=21 & tot_contacts_yest <=30
replace contacts_cat =4 if tot_contacts_yest >=31 & tot_contacts_yest <=40
replace contacts_cat =5 if tot_contacts_yest >=41 & tot_contacts_yest <=50
replace contacts_cat =6 if tot_contacts_yest >=51 & tot_contacts_yest !=.

la define contact_cat 1 "0-10" 2 "11-20" 3 "21-30" 4 "31-40" 5 "41-50" 6 "over 50"
 
la values contacts_cat contact_cat
 
tab contacts_cat 

tab contacts_cat gender, col freq m

* 1. Descriptive stats on contacts by subgroup yesterday (average)
*one over the whole week (excl saturday)

	tabstat tot_contacts_yest , stat(mean median p25 p75 max N) 
	tabstat tot_contacts_yest, stat(mean median p25 p75 max N) by(gender) 
	tabstat tot_contacts_yest, stat(mean median p25 p75 max N)  by(ses_5) 
	tabstat tot_contacts_yest, stat(mean median p25 p75 max N)  by(age_5) 
	tabstat tot_contacts_yest, stat(median p25 p75 max N)  by(site_type) 
	tabstat tot_contacts_yest, stat(median p25 p75 max N)  by(occ_2) 
	tabstat tot_contacts_yest, stat(median p25 p75 max N)  by(occupation) 
	tabstat all_work_yest, stat (median p25 p75 max N) by(occ4)
	//individual days of the week have been moved to the bottom as they aren't substantially different 

************************************************************************
*tables for non-lockdown
************************************************************************

table1_mc, vars(tot_contacts_yest  conts)

table1_mc, vars(gender cat \ ses_5 cat \ age_5 cat \ site_type cat \ occ_2 cat) saving("tables/people_chapter/baseline_chars_r9.xlsx", replace) 

*get the significance statistics (z for gender and chi for all others), then add them in manually to the tables produced above
foreach var in gender ses_5 age_5 site_type occ_2 {
table1_mc, by(`var') vars(tot_contacts_yest  conts %5.0f) stat
}

	
*************************************************************************
*****SOCIAL CONTACTS  - PLACE LEVEL QUESTION  *********
*************************************************************************

foreach var in all_home_yest all_home_sat all_work_yest all_work_sat all_school_yest all_school_sat all_com_yest all_com_sat all_trans_yest all_trans_sat all_ent_yest all_ent_sat { // nb this is missing home in this coding category 
tabstat `var', stat(median p25 p75 max) 
tabstat `var', stat(median p25 p75 max) by(gender) 
tabstat `var', stat(median p25 p75 max)  by(ses_5) 
tabstat `var', stat(median p25 p75 max)  by(age_5) 
tabstat `var', stat(median p25 p75 max)  by(site_type) 
tabstat `var', stat(median p25 p75 max)  by(occ_2) 

}

tabstat all_*_yest, stat(mean median p25 p75 max)
tabstat tot_contacts_yest, stat(mean median p25 p75 max)
tabstat broad_com_yest, stat(mean median p25 p75 max)


*are the patterns of association consistent with R8 data in terms of characteristics of those who have higher contacts? 

eststo clear
eststo: nbreg tot_contacts_yest   i.gender  i.ses_5 i.age_5 i.site_type ib3.occ_2 dist_visit_num  vaccine_take, irr 

estout using tables/people_chapter/nbreg_r9.txt, cells("b (fmt(%7.2f)) ci_l ci_u _star")  title ("Correlates of post-lockdown contacts - Negative binomial regression") label eform refcat()  replace

/*
Consistent as follows:
- Women have less than men
- Wealthier have more contacts than rest
- younger have more contacts than older than 44
- urban and commercial centres have more contacts than rest (one change: ag estates not sig different from subsistence farming)
- occupations: teachers, service/retail, transport, healthcareworkers have significantly more; subsistence ag, unemployed, homemakers have significantly less
*/

// problem identified is very low Rsquared of only  0.0669, adding districts visited only reduced to 0.068, adding vaccine take made no difference

*use the exact same regression as before for consistency
nbreg tot_contacts_yest  i.gender  i.ses_5 i.age_5 i.site_type i.occupation dist_visit_num vaccine_take, irr 
// yes, holds. But rsquared even worse 0.03

*are the patterns of association consistent with R8 data in terms of PLACES where people have higher contacts? 


*************************************************************************
*****************ANALYSIS OF BUBBLE SIZES********************************
*************************************************************************

*Descriptives (work, community, school, transit)
tabstat school_bubble, stat(mean median min p25 p75 max)
tabstat comm_bubble, stat(mean median min p25 p75 max)
tabstat transit_bubble, stat(mean median min p25 p75 max)
tabstat work_bubble, stat(median min p25 p75 max)
tabstat work_bubble, stat(median min p25 p75 max n) by(occ4)



*bubble school contacts
tabstat school_bubble, stat(mean median min p25 p75 max) by(gender)
tabstat school_bubble, stat(mean median min p25 p75 max) by(age_5)

*bubble community contacts by age
tabstat comm_bubble, stat(mean median min p25 p75 max) by(age_5) 
// quite similar
tabstat comm_bubble, stat(mean median min p25 p75 max) by(ses_5) 

*bubble trans contacts by site type
tabstat transit_bubble, stat(mean median min p25 p75 max) by(site_type)

*bubble work contacts by occupation (make sure to have replaced student numbers with school_bubble numbers in earlier dofile)

tabstat work_bubble, stat(mean median min p25 p75 max count) by(occ4)


* what are the characteristics of people who have big social bubbles at work, on transport and in communities? What are significant determinants of contacts in each place? 

* at work

eststo clear
eststo: nbreg work_bubble  dist_visit_num i.gender i.ses_5 i.age_5 i.site_type ib19.occ4 , irr // those in education, service or retail had significantly bigger work bubbles, those in subsistence agg, unemployed, homemakers had significantly smaller bubbles. 


estout using tables/people_chapter/nbreg_r9_workbubble.txt, cells("b (fmt(%7.2f)) ci_l ci_u _star")  title ("Correlates of bubble sizes at work - Negative binomial regression") label eform refcat()  replace

* in the community
eststo clear
eststo: nbreg comm_bubble  dist_visit_num i.gender i.ses_5 i.age_5 i.site_type ib19.occ4 , irr // females had bigger bubbles, those in urban, commercial and ag estates had smaller bubbles than subsistence farming


estout using tables/people_chapter/nbreg_r9_combubble.txt, cells("b (fmt(%7.2f)) ci_l ci_u _star")  title ("Correlates of bubble sizes in community - Negative binomial regression") label eform refcat()  replace

* on transport 
eststo clear
eststo: nbreg transit_bubble  dist_visit_num i.gender i.ses_5 i.age_5 i.site_type ib19.occ4 , irr // female and those that visit more districts. Gender and Site Type are significant


estout using tables/people_chapter/nbreg_r9_transbubble.txt, cells("b (fmt(%7.2f)) ci_l ci_u _star")  title ("Correlates of bubble sizes on transport - Negative binomial regression") label eform refcat()  replace

*at school 
eststo clear
eststo: nbreg school_bubble  i.gender i.ses_5 i.age_5 i.site_type dist_visit_num if occupation==10, irr 


estout using tables/people_chapter/nbreg_r9_schoolbubble.txt, cells("b (fmt(%7.2f)) ci_l ci_u _star")  title ("Correlates of bubble sizes at school - Negative binomial regression") label eform refcat()  replace

*************************************************************************
********WERE HIGH CONTACT INDIVIDUALS MORE MOBILE? ******************
*************************************************************************

**1. Were high contact individuals also more mobile? 
reg tot_contacts_yest dist_visit_num 
** controling for other factors (age, occupation, gender, ses)

reg tot_contacts_yest dist_visit_num  i.gender i.ses_5 i.age_5 i.site_type i.occ_2


reg tot_contacts_yest i.occ_2
// the relationship holds

*************************************************************************
*****WHAT WERE CHARACTERISTICS OF THE MORE MOBILE INDIVIDUALS?  *********
*************************************************************************

** 2. Who were the people who visited more districts?

*Checked the distribution of the outcome variable, if it is right skewed then poisson makes more sense because movement variables are conceptual counts 

tab dist_visit_num // they are, so will do poisson

*he also suggested to make tot_contacts_yest *10 to make it more interpretable 
gen tot_contacts_yest_10 = tot_contacts_yest/10

******** Note this result is displayed in Chapter 3.3.2 Table 6
zip dist_visit_num  tot_contacts_yest_10 i.gender i.ses_5 i.age_5 i.site_type ib3.occ_2, irr inflate(_cons) 

est store mobility_reg, title(Districts Visited)
estout mobility_reg using tables/reg_dist_visited.txt, eform cells("b ci_l ci_u _star")  title ("Characteristics of Individuals who visited more districts - R9, 2022") label  replace

esttab mobility_reg using tables/movement_chapter/reg_dist_visited.csv, eform cells("b ci_l ci_u _star") title("Characteristics of Individuals who visited more districts - R9, 2022") label replace


// this way around, those who visited more districts were more likely to be...
/// female (surprise), urban, work in manufacture or mining, education, service retail, informal/petty trade, transport, office, (marginally) healthcare 
// school variable needs cleaning 

*************************************************************************
*****MOBILE PEOPLE - PLACE LEVEL QUESTION  *********
*************************************************************************

** 3. In which PLACES were the more mobile people having more contacts?   

reg dist_visit_num all_home_yest all_work_yest all_school_yest all_com_yest all_trans_yest all_ent_yest // this doesn't run as there are many missing obs. Need to come back to this to figure out if missings were did not visit or zeros


* so another way to ask this question is to look at the bubble sizes of places 
reg dist_visit_num  work_bubble transit_bubble comm_bubble 
// more mobile people were also those who had bigger bubbles at work, on transit, and in the community

***COMMUNITY - is the number of districts visited related to the size of the community bubble
// in other words if you go to more places are you going to have a larger community bubble 
reg dist_visit_num comm_bubble i.gender i.ses_5 i.age_5 i.site_type i.occ_2 // answer is yes

** looking at the number of districts visited as a function of the size of the transit bubble (if you travel more will your transport bubble be bigger)
reg dist_visit_num transit_bubble i.gender i.ses_5 i.age_5 i.site_type i.occupation // answer is yes

*************************************************************************
***********************MOBILE PEOPLE - GRAPHS  ************************
*************************************************************************


*look at the relationship between the number of districts visited and individual factors
// just do this to get a clearer picture
tab dist_visit_num gender
twoway (histogram dist_visit_num if gender==1, width(1) color(blue%30)) ///
		(histogram dist_visit_num if gender==2, width(1) color(red%30)), ///
		legend(order(1= "Male", 2= "Female"))

*and socioeconomic status 
tab dist_visit_num ses_5
graph bar dist_visit_num, over(ses_5) // most mobile travelled most
graph bar, over(dist_visit_num) over(ses_5) stack asyvars

graph hbar, over(dist_visit_num) over(ses_5) stack asyvars percentage blabel(bar, pos(center) format(%3.0f)) ytitle(Percentage)
*by site type
tab dist_visit_num site_type
graph hbar, over(dist_visit_num) over(site_type) stack asyvars percentage blabel(bar, pos(center) format(%3.0f)) ytitle(Percentage)
*by occupation 
reg dist_visit_num i.gender i.ses_5 i.age_5 i.site_type i.occupation 

*************************************************************************
*************** DIFFERENCES BY DAYS OF THE WEEK ********************
*************************************************************************

**contacts by days of the week 

* individual monday - friday distributions
forvalues i = 1/5 {
tabstat tot_contacts_yest if day_contacts==`i', stat(mean, median, p25, p75, max, N) varwidth(30)
}

* individual sat and sunday distributions
tabstat tot_contacts_sat,  stat(mean, median, p25, p75, max, N) // 5
tabstat tot_contacts_yest if day_contacts==0, stat(mean, median, p25, p75, max, N)

* overall for weekdays vs weekend 
tabstat tot_contacts_yest if weekday==1,  stat(mean, median, p25, p75, max, N) varwidth(30)
tabstat tot_contacts_sat,  stat(mean, median, p25, p75, max, N) varwidth(30) // 5
*sunday
tabstat tot_contacts_yest if weekday==0,  stat(mean, median, p25, p75, max, N) varwidth(30)

*do they differ significantly 
ttest tot_contacts_yest == tot_contacts_sat

gen contacts_sun = tot_contacts_yest if day_contacts==0
gen contacts_mon = tot_contacts_yest if day_contacts==1
gen contacts_tue = tot_contacts_yest if day_contacts==2
gen contacts_wed = tot_contacts_yest if day_contacts==3
gen contacts_thur = tot_contacts_yest if day_contacts==4
gen contacts_fri = tot_contacts_yest if day_contacts==5
gen contacts_sat = tot_contacts_sat

gen contacts_wkday=contacts_mon
replace contacts_wkday = contacts_tue if contacts_wkday ==.
replace contacts_wkday = contacts_wed if contacts_wkday ==.
replace contacts_wkday = contacts_thur if contacts_wkday ==.
replace contacts_wkday = contacts_fri if contacts_wkday ==.

egen contacts_wkend=rowmean(contacts_sat contacts_sun)

ttest contacts_wkday == contacts_wkend



// quite similar from one day to the next, but quite a lot lower on Saturdays 
*one for each day of the week (Mon-Fri)
foreach var in tot_contacts_yest {
	forvalues i = 1/5 {
tabstat `var' if day_contacts == `i', stat(median p25 p75 max N) 
tabstat `var' if day_contacts == `i', stat(median p25 p75 max N) by(gender) 
tabstat `var' if day_contacts == `i', stat(median p25 p75 max N)  by(ses_5) 
tabstat `var' if day_contacts == `i', stat(median p25 p75 max N)  by(age_5) 
tabstat `var' if day_contacts == `i', stat(median p25 p75 max N)  by(site_type) 
tabstat `var' if day_contacts == `i', stat(median p25 p75 max N)  by(occ_2) 
tabstat `var' if day_contacts == `i', stat(median p25 p75 max N)  by(occupation) 
	}
}

foreach var in contacts_wkday contacts_wkend {
	tabstat `var' , stat(median p25 p75 max N) 
}

preserve 
drop contacts_cat 

foreach var in contacts*  {
	tabstat `var' , stat(median p25 p75 max N) columns(statistics) varwidth(30)
}

restore 



* do summary statistics for the overall contacts by place during the week and on saturdays as per the R8 analysis. But in this case, i need to separate by days of the week 

** look at what fraction of people are leaving their district for work or school_bubble
tab school_out_dist
tab work_out_dist
tab comm_out_dist

* look at this in relation to the contacts people had 
sum tot_contacts_yest if school_out_dist ==1 // yes
sum tot_contacts_yest if school_out_dist ==2 // no

sum tot_contacts_yest if work_out_dist ==1
sum tot_contacts_yest if work_out_dist ==2

sum tot_contacts_yest if comm_out_dist ==1
sum tot_contacts_yest if comm_out_dist ==2


