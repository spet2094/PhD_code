**Zambia Cholera Project
**Consolidating Pepita's Do Files For Tables
**by Billy Hoo 
**Version : 15th August 2018
**Edited by : 



use  "D:\work\Zambia\Data Analysis\Data_91118.dta", clear


**I have applied Line 4 - 37 in previous files 
/*
xi i.resident_status, noomit
// 1 homeowner, 2 resident landlord, 3 tenant
gen resident= _Iresident__1 + 2*_Iresident__3 + 3*_Iresident__4
replace resident=. if resident==0
// Treatment indicators: 

generate Landlord=0
replace Landlord=1 if resident==2

generate Homeowner=0
replace Homeowner=1 if resident==1

generate Tenant=0
replace Tenant=1 if resident==3

tab randomize_questions randomize_frames
 
xi i.randomize_frames, noomit
rename _Irandomize_1 FrameHealth
rename _Irandomize_2 FrameLegal
rename _Irandomize_3 FrameSocialNorms

generate Frame= FrameLegal + 2*FrameSocialNorms + 3*FrameHealth
// Frame 1 legal, frame 2 social norms, frame 3 health --> please confirm

tab randomize_questions

xi i.randomize_questions , noomit

generate MainSample=_Irandomize_1+ _Irandomize_2 + _Irandomize_3
rename _Irandomize_4 GuesCost
rename _Irandomize_5 RealCost

generate Structure= MainSample + 2*GuesCost + 3*RealCost
*/

// Structure 1 main sample 2 guess costs 3 real cost

////////////////////////////////////////////////////////////////////////////////
/// Descriptive tables 
////////////////////////////////////////////////////////////////////////////////

generate HHemployed=0
replace  HHemployed=1 if hh_employed==2

generate WomanRespondent=0
replace WomanRespondent=1 if sex_of_respondent==1
 
generate HHcholera=0
replace  HHcholera=1 if cholera_cases==2

replace piped_dwelling =. if inlist(piped_dwelling,-99,1)
generate HHpiped=0
replace HHpiped=1 if piped_dwelling==3

generate ClientLWSC=0
replace ClientLWSC=1 if watsan_service_pro==1
replace ClientLWSC=1 if comm_water_operator ==4

generate HHtoilet=0
replace  HHtoilet=1 if Is_there_a_toilet ==2

generate HHOwns_toilet=0
replace  HHOwns_toilet=1 if toilet_owned_by_hh==2 

generate HHShared_toilet=0
replace  HHShared_toilet=1 if  shared_toilet_encoded ==2 

foreach var in age_hh people_in_household cost_electricity num_people_use_toilet number_hh_sharing_toilet {
replace `var'=. if `var'==-99
egen p99_`var' = pctile(`var'), p(99)
replace `var'=. if `var'>=p99_`var'
drop   p99_*
}
*	

// by resident status
//iebaltab age_hh people_in_household cost_electricity num_people_use_toilet number_hh_sharing_toilet HHemployed WomanRespondent HHcholera HHpiped ClientLWSC HHtoilet HHOwns_toilet HHShared_toilet  , grpvar(resident) fmissok savetex(ResidentTest) replace ftest rowvarlabel
// by frame 
//iebaltab age_hh people_in_household cost_electricity num_people_use_toilet number_hh_sharing_toilet HHemployed WomanRespondent HHcholera HHpiped ClientLWSC HHtoilet HHOwns_toilet HHShared_toilet  , grpvar(Frame) fmissok savetex(FrameTest) replace ftest rowvarlabel
// by structure 
//iebaltab age_hh people_in_household cost_electricity num_people_use_toilet number_hh_sharing_toilet HHemployed WomanRespondent HHcholera HHpiped ClientLWSC HHtoilet HHOwns_toilet HHShared_toilet  , grpvar(Structure) fmissok savetex(StructureTest) replace ftest rowvarlabel
 

////////////////////////////////////////////////////////////////////////////////
/// Choice 
////////////////////////////////////////////////////////////////////////////////

// generate numeric choice: 1 brick ´- 2 plastic - 3 pre-fab - zero none.
 
xi i.homeowner_toilet_choice, noomit 
generate choiceHomeowner=  _Ihomeowner_1 + 2*_Ihomeowner_3 + 3*_Ihomeowner_4
rename _Ihomeowner_2 NoChoiceHomeowner

xi i.ll_toilet_choice, noomit
generate choiceLandlord= _Ill_toilet_1   + 2*_Ill_toilet_3  + 3*_Ill_toilet_4
rename _Ill_toilet_2 NoChoiceLandlord

xi i.t_toilet_choice , noomit
generate choiceTenant= _It_toilet__1  + 2*_It_toilet__3  + 3*_It_toilet__4
rename _It_toilet__2 NoChoiceTenant

gen choice= choiceHomeowner 
replace choice = choiceLandlord if resident==2
replace choice = choiceTenant if resident==3

gen Nochoice= NoChoiceHomeowner 
replace Nochoice = NoChoiceLandlord if resident==2
replace Nochoice = NoChoiceTenant if resident==3

replace choice=. if Nochoice==1


foreach var in choiceHomeowner choiceLandlord choiceTenant {

generate Brick`var'=0
replace Brick`var'=1 if `var'==1
replace Brick`var'=. if `var'==.

generate Plastic`var'=0
replace Plastic`var'=1 if `var'==2
replace Plastic`var'=. if `var'==.

generate PreFab`var'=0
replace PreFab`var'=1 if `var'==3
replace PreFab`var'=. if `var'==.
}
*
// Table of main sample choice compared across frames
//iebaltab BrickchoiceHomeowner PlasticchoiceHomeowner PreFabchoiceHomeowner BrickchoiceLandlord PlasticchoiceLandlord PreFabchoiceLandlord BrickchoiceTenant PlasticchoiceTenant PreFabchoiceTenant if MainSample==1   , grpvar(Frame) fmissok savetex(Choice) replace  rowvarlabel


xi i.choice, noomit
rename _Ichoice_1 Brick
rename _Ichoice_2 Plastic
rename _Ichoice_3 PreFab


////////////////////////////////////////////////////////////////////////////////
/// Interest on the choice & afford 
////////////////////////////////////////////////////////////////////////////////
 
generate interest= interested_toilet_choice 
replace interest = ll_interested_toilet_choice if resident==2
// note: tenant_questionstenant_interest is not comparible since tenant had different and more alternatives.

generate interestN=0
replace interestN=1 if interest=="yes"
replace interestN=. if interest=="."
replace interestN=. if choice==.

tab  resident interest, row

/*
          |       interest
  resident |        no        yes |     Total
-----------+----------------------+----------
         1 |       718      2,929 |     3,647 
           |     19.69      80.31 |    100.00 
-----------+----------------------+----------
         2 |       496      1,972 |     2,468 
           |     20.10      79.90 |    100.00 
-----------+----------------------+----------
     Total |     1,214      4,901 |     6,115 
           |     19.85      80.15 |    100.00

*/ 

// can afford the choice
 
generate afford= afford_toilet_choice
replace afford=ll_afford_toilet_choice if resident==2

generate affordN=0
replace affordN=1 if afford=="yes"
replace affordN=. if afford=="."
replace affordN=. if choice==.

generate ChooseFacility=0
 replace ChooseFacility=1 if Nochoice==0


foreach var in ChooseFacility interestN affordN {
generate LL`var'= `var' if resident==2
generate HO`var'= `var' if resident==1
}
*
 
tab  resident afford, row

/*
          |              afford
  resident | dont_know         no        yes |     Total
-----------+---------------------------------+----------
         1 |       471      1,717      1,459 |     3,647 
           |     12.91      47.08      40.01 |    100.00 
-----------+---------------------------------+----------
         2 |       303      1,138      1,027 |     2,468 
           |     12.28      46.11      41.61 |    100.00 
-----------+---------------------------------+----------
     Total |       774      2,855      2,486 |     6,115 
           |     12.66      46.69      40.65 |    100.00 
*/
 
iebaltab ChooseFacility   interestN  affordN HOChooseFacility HOinterestN  HOaffordN LLChooseFacility LLinterestN   LLaffordN if MainSample==1   , grpvar(Frame) fmissok savetex(InterestAfford) replace  rowvarlabel

iebaltab ChooseFacility   interestN  affordN if GuesCost==1   , grpvar(Frame) fmissok savetex(InterestAfford2) replace  rowvarlabel

iebaltab ChooseFacility   interestN  affordN if RealCost==1   , grpvar(Frame) fmissok savetex(InterestAfford3) replace  rowvarlabel


 iebaltab BrickchoiceHomeowner PlasticchoiceHomeowner PreFabchoiceHomeowner  BrickchoiceLandlord PlasticchoiceLandlord PreFabchoiceLandlord   BrickchoiceTenant PlasticchoiceTenant PreFabchoiceTenant if MainSample==1   , grpvar(Frame) fmissok savetex(ChoiceFrameResident) replace  rowvarlabel


//iebaltab BrickchoiceHomeowner PlasticchoiceHomeowner PreFabchoiceHomeowner HOinterestN HOaffordN BrickchoiceLandlord PlasticchoiceLandlord PreFabchoiceLandlord LLinterestN LLaffordN BrickchoiceTenant PlasticchoiceTenant PreFabchoiceTenant if Frame==1   , grpvar(Structure) fmissok savetex(ChoiceStructureF1) replace  rowvarlabel
//iebaltab BrickchoiceHomeowner PlasticchoiceHomeowner PreFabchoiceHomeowner HOinterestN HOaffordN BrickchoiceLandlord PlasticchoiceLandlord PreFabchoiceLandlord LLinterestN LLaffordN BrickchoiceTenant PlasticchoiceTenant PreFabchoiceTenant if Frame==2   , grpvar(Structure) fmissok savetex(ChoiceStructureF2) replace  rowvarlabel
//iebaltab BrickchoiceHomeowner PlasticchoiceHomeowner PreFabchoiceHomeowner HOinterestN HOaffordN BrickchoiceLandlord PlasticchoiceLandlord PreFabchoiceLandlord LLinterestN LLaffordN BrickchoiceTenant PlasticchoiceTenant PreFabchoiceTenant if Frame==3   , grpvar(Structure) fmissok savetex(ChoiceStructureF3) replace  rowvarlabel

////////////////////////////////////////////////////////////////////////////////
/// Willingness to pay
////////////////////////////////////////////////////////////////////////////////

// Plastic

generate PlasticWTP=.
replace PlasticWTP=0 if affordN==1 & Plastic==1
replace PlasticWTP=1 if plastic_at_20_percent=="yes" & resident==1
replace PlasticWTP=2 if plastic_at_30_percent=="yes" & resident==1
replace PlasticWTP=3 if plastic_at_50_percent=="yes" & resident==1

replace PlasticWTP=1 if ll_plastic_at_20_percent=="yes" & resident==2
replace PlasticWTP=2 if ll_plastic_at_30_percent=="yes" & resident==2
replace PlasticWTP=3 if ll_plastic_at_50_percent=="yes" & resident==2

generate MaxWTP= wtp_maximum_plastic if resident ==1
replace MaxWTP= ll_wtp_maximum_plastic if resident==2
replace PlasticWTP=4 if MaxWTP !=.
replace PlasticWTP=. if resident==3

// Prefab

generate PrefabWTP=.
replace PrefabWTP=0 if affordN==1 & PreFab==1
replace PrefabWTP=1 if prefab_at_20_percent=="yes" & resident==1
replace PrefabWTP=2 if prefab_at_30_percent=="yes" & resident==1
replace PrefabWTP=3 if prefab_at_50_percent=="yes" & resident==1

replace PrefabWTP=1 if ll_prefab_at_20_percent=="yes" & resident==2
replace PrefabWTP=2 if ll_prefab_at_30_percent=="yes" & resident==2
replace PrefabWTP=3 if ll_prefab_at_50_percent=="yes" & resident==2

capture drop MaxWTP
generate MaxWTP= wtp_maximum_prefab if resident ==1
replace MaxWTP= ll_wtp_maximum_prefab if resident==2
replace PrefabWTP=4 if MaxWTP !=.
replace PrefabWTP=. if resident==3

// Brick 

generate BrickWTP=.
replace BrickWTP=0 if affordN==1 & Brick==1
replace BrickWTP=1 if brick_at_20_percent=="yes" & resident==1
replace BrickWTP=2 if brick_at_30_percent=="yes" & resident==1
replace BrickWTP=3 if brick_at_50_percent=="yes" & resident==1

replace BrickWTP=1 if ll_brick_at_20_percent=="yes" & resident==2
replace BrickWTP=2 if ll_brick_at_30_percent=="yes" & resident==2
replace BrickWTP=3 if ll_brick_at_50_percent=="yes" & resident==2

capture drop MaxWTP
generate MaxWTP= wtp_maximum_brick if resident ==1
replace MaxWTP= ll_wtp_maximum_brick if resident==2
replace BrickWTP=4 if MaxWTP !=.
replace BrickWTP=. if resident==3

tab PlasticWTP if resident==1 & MainSample==1
tab PlasticWTP if resident==2 & MainSample==1

tab PrefabWTP if resident==1 & MainSample==1
tab PrefabWTP if resident==2 & MainSample==1

tab BrickWTP if resident==1 & MainSample==1
tab BrickWTP if resident==2 & MainSample==1

sum wtp_maximum_plastic if MainSample==1
sum ll_wtp_maximum_plastic if MainSample==1

sum wtp_maximum_prefab if MainSample==1
sum ll_wtp_maximum_prefab if MainSample==1

sum wtp_maximum_brick if MainSample==1
sum ll_wtp_maximum_brick if MainSample==1

// Increase value of the property with improved facility:

generate IncreaseValue= property_value_increase
replace IncreaseValue= ll_property_value_increase if resident==2

tab resident IncreaseValue, row

xi i.IncreaseValue, noomit

capture drop IncreaseValue
generate IncreaseValue=_IIncreaseV_2

sum IncreaseValue if resident==1 & MainSample==1
sum IncreaseValue if resident==2 & MainSample==1

sum IncreaseValue if resident==1 & MainSample==1 & Plastic==1
sum IncreaseValue if resident==2 & MainSample==1 & Plastic==1

sum IncreaseValue if resident==1 & MainSample==1 & Prefab==1
sum IncreaseValue if resident==2 & MainSample==1 & Prefab==1

sum IncreaseValue if resident==1 & MainSample==1 & Brick==1
sum IncreaseValue if resident==2 & MainSample==1 & Brick==1

// Increase in rend tenant is willing to pay // landlord is expecting:

foreach var in units_rented_out total_monthly_rent units_rented total_rent_paid {
replace `var'=. if `var'==-99
egen p99_`var' = pctile(`var'), p(99)
replace `var'=. if `var'>=p99_`var'
drop   p99_*
}
*

foreach var in rent_increase_10_percent rent_increase_20_percent rent_increase_30_percent  IM IN IO {
generate N`var'=0 if `var'=="no"
replace N`var'=1 if `var'=="yes"
}
*
* These three variables were removed from the list on line 328 IL IM IN


/* 
 histogram PlasticWTP if Structure<3 & Frame==1 , frac by(Structure)
 histogram PlasticWTP if Structure<3 & Frame==2 , frac by(Structure)
 histogram PlasticWTP if Structure<3 & Frame==3 , frac by(Structure)
 ranksum PlasticWTP if Structure<3 & Frame==1 ,  by(Structure)
 ranksum PlasticWTP if Structure<3 & Frame==2 , by(Structure)
 ranksum PlasticWTP if Structure<3 & Frame==3 , by(Structure)

 histogram PrefabWTP if Structure<3 & Frame==1 , frac by(Structure)
 histogram PrefabWTP if Structure<3 & Frame==2 , frac by(Structure)
 histogram PrefabWTP if Structure<3 & Frame==3 , frac by(Structure)
 ranksum PrefabWTP if Structure<3 & Frame==1 ,  by(Structure)
 ranksum PrefabWTP if Structure<3 & Frame==2 , by(Structure)
 ranksum PrefabWTP if Structure<3 & Frame==3 , by(Structure)
 
 ranksum BrickWTP if Structure<3 & Frame==1 ,  by(Structure)
 ranksum BrickWTP if Structure<3 & Frame==2 , by(Structure)
 ranksum BrickWTP if Structure<3 & Frame==3 , by(Structure)
 histogram BrickWTP if Structure<3 & Frame==1 , frac by(Structure)
 histogram BrickWTP if Structure<3 & Frame==2 , frac by(Structure)
 histogram BrickWTP if Structure<3 & Frame==3 , frac by(Structure)
*/
 
////////////////////////////////////////////////////////////////////////////////
/// Cost guess and Real cost 
////////////////////////////////////////////////////////////////////////////////

// Guess cost only happens in Structure==2

generate plastic_costguess=  gauging_cost_plastic
generate brick_costguess=   gauging_cost_brick
generate prefab_costguess=    gauging_cost_pre_fab

replace plastic_costguess=   ll_gauging_cost_plastic  if resident==2
replace brick_costguess=  ll_gauging_cost_brick if resident==2
replace prefab_costguess= ll_gauging_cost_pre_fab  if resident ==2

foreach var in plastic_costguess brick_costguess prefab_costguess {
replace `var'=. if `var'==-99
egen p99_`var' = pctile(`var'), p(99)
replace `var'=. if `var'>=p99_`var'
drop   p99_*
}
*

foreach var in price_plastic_toilet price_pre_fab_toilet price_brick gauging_realcost_plastic gauging_realcost_brick gauging_realcost_pre_fab {
tab `var', nolabel
gen N`var'=1 if `var'=="yes"
replace N`var'=0 if `var'=="no"
}
*

//iebaltab  plastic_costguess brick_costguess prefab_costguess Nprice_plastic_toilet Nprice_pre_fab_toilet Nprice_brick Ngauging_realcost_plastic Ngauging_realcost_brick Ngauging_realcost_pre_fab  , grpvar(Frame) fmissok savetex(Costs) replace  rowvarlabel
 
 /////////////////////////////////
 // Regressions Take-up across frames
 /////////////////////////////////

reg ChooseFacility FrameHealth FrameSocial if MainSample==1
test FrameHealth FrameSocial
outreg2 using T1.tex,   tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Choose Facility) keep (FrameHealth FrameSocial)  addtext (Sample, All, Controls, No) replace
 
reg ChooseFacility FrameHealth FrameSocial HHemployed WomanRespondent HHcholera HHpiped ClientLWSC HHtoilet HHOwns_toilet HHShared_toilet if MainSample==1
test FrameHealth FrameSocial
outreg2 using T1.tex,   tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Choose Facility) keep (FrameHealth FrameSocial)  addtext (Sample, All, Controls, Yes) append

reg ChooseFacility FrameHealth FrameSocial if MainSample==1 & Landlord==1
test FrameHealth FrameSocial
outreg2 using T1.tex,   tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Choose Facility) keep (FrameHealth FrameSocial) addtext (Sample, Landlords, Controls, No) append

reg ChooseFacility FrameHealth FrameSocial HHemployed WomanRespondent HHcholera HHpiped ClientLWSC HHtoilet HHOwns_toilet HHShared_toilet  if MainSample==1 & Landlord==1
test FrameHealth FrameSocial
outreg2 using T1.tex, tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Choose Facility) keep (FrameHealth FrameSocial)  addtext (Sample, Landlord, Controls, Yes) append
 
reg ChooseFacility FrameHealth FrameSocial if MainSample==1 & Homeowner==1
test FrameHealth FrameSocial
outreg2 using T1.tex, tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Choose Facility) keep (FrameHealth FrameSocial) addtext (Sample, Homeowner, Controls, No) append

reg ChooseFacility FrameHealth FrameSocial HHemployed WomanRespondent HHcholera HHpiped ClientLWSC HHtoilet HHOwns_toilet HHShared_toilet if MainSample==1 & Tenant==1
test FrameHealth FrameSocial
outreg2 using T1.tex, tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Choose Facility) keep (FrameHealth FrameSocial) addtext (Sample, Homeowner, Controls, Yes) append
   
reg ChooseFacility FrameHealth FrameSocial if MainSample==1 & Tenant==1
test FrameHealth FrameSocial
outreg2 using T1.tex, tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Choose Facility) keep (FrameHealth FrameSocial) addtext (Sample, Tenant, Controls, No) append

reg ChooseFacility FrameHealth FrameSocial  HHemployed WomanRespondent HHcholera HHpiped ClientLWSC HHtoilet HHOwns_toilet HHShared_toilet if MainSample==1 & Homeowner==1
test FrameHealth FrameSocial
outreg2 using T1.tex, tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Choose Facility) keep (FrameHealth FrameSocial) addtext (Sample, Tenant, Controls, Yes) append
  
 
reg ChooseFacility FrameHealth FrameSocial if GuesCost==1
test FrameHealth FrameSocial
outreg2 using T2.tex,   tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Choose Facility) keep (FrameHealth FrameSocial)  addtext (Sample, All, Controls, No) replace

reg ChooseFacility FrameHealth FrameSocial if GuesCost==1 & Landlord==1
test FrameHealth FrameSocial
outreg2 using T2.tex,   tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Choose Facility) keep (FrameHealth FrameSocial)  addtext (Sample, Landlord, Controls, No) append
reg ChooseFacility FrameHealth FrameSocial if GuesCost==1 & Homeowner==1
test FrameHealth FrameSocial
outreg2 using T2.tex,   tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Choose Facility) keep (FrameHealth FrameSocial)  addtext (Sample, Homeowner, Controls, No) append
reg ChooseFacility FrameHealth FrameSocial if GuesCost==1 & Tenant==1
test FrameHealth FrameSocial
outreg2 using T2.tex,   tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Choose Facility) keep (FrameHealth FrameSocial)  addtext (Sample, Tenant, Controls, No) append

reg ChooseFacility FrameHealth FrameSocial if RealCost==1
test FrameHealth FrameSocial
outreg2 using T2.tex,   tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Choose Facility) keep (FrameHealth FrameSocial)  addtext (Sample, All, Controls, No) append


 /////////////////////////////////
 // Regressions Take-up across survey structures
 /////////////////////////////////


reg ChooseFacility GuesCost RealCost if FrameLegal==1  
test GuesCost RealCost
outreg2 using T3.tex,   tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Legal) keep (GuesCost RealCost)  addtext (Sample, All, Controls, No) replace
 
reg ChooseFacility GuesCost RealCost if FrameLegal==1  & Landlord==1
test GuesCost RealCost
outreg2 using T3.tex,   tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Legal) keep (GuesCost RealCost)  addtext (Sample,Landlord, Controls, No) append

reg ChooseFacility GuesCost RealCost if FrameLegal==1  & Homeowner==1
test GuesCost RealCost
outreg2 using T3.tex,   tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Legal) keep (GuesCost RealCost)  addtext (Sample,Homeowner, Controls, No) append

reg ChooseFacility GuesCost RealCost if FrameLegal==1  & Tenant==1
test GuesCost RealCost
outreg2 using T3.tex,   tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Legal) keep (GuesCost RealCost)  addtext (Sample,Tenant, Controls, No) append

reg ChooseFacility GuesCost RealCost if FrameSocial==1  
test GuesCost RealCost
outreg2 using T3.tex,   tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Social) keep (GuesCost RealCost)  addtext (Sample, All, Controls, No) append
 
reg ChooseFacility GuesCost RealCost if FrameSocial==1    & Landlord==1
test GuesCost RealCost
outreg2 using T3.tex,   tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Social) keep (GuesCost RealCost)  addtext (Sample,Landlord, Controls, No) append

reg ChooseFacility GuesCost RealCost if FrameSocial==1    & Homeowner==1
test GuesCost RealCost
outreg2 using T3.tex,   tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Social) keep (GuesCost RealCost)  addtext (Sample,Homeowner, Controls, No) append

reg ChooseFacility GuesCost RealCost if FrameSocial==1   & Tenant==1
test GuesCost RealCost
outreg2 using T3.tex,   tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Social) keep (GuesCost RealCost)  addtext (Sample,Tenant, Controls, No) append

reg ChooseFacility GuesCost RealCost if FrameHealth==1  
test GuesCost RealCost
outreg2 using T3.tex,   tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Health) keep (GuesCost RealCost)  addtext (Sample, All, Controls, No) append
 
reg ChooseFacility GuesCost RealCost if FrameHealth==1    & Landlord==1
test GuesCost RealCost
outreg2 using T3.tex,   tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Health) keep (GuesCost RealCost)  addtext (Sample,Landlord, Controls, No) append

reg ChooseFacility GuesCost RealCost if FrameHealth==1    & Homeowner==1
test GuesCost RealCost
outreg2 using T3.tex,   tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Health) keep (GuesCost RealCost)  addtext (Sample,Homeowner, Controls, No) append

reg ChooseFacility GuesCost RealCost if FrameHealth==1   & Tenant==1
test GuesCost RealCost
outreg2 using T3.tex,   tex(pr land) alpha(0.01, 0.05, 0.1, 0.15) adds(F-test, r(F), Prob > F, `r(p)') symbol(***, **, *, +) bdec(4) sdec(3) ctitle (Health) keep (GuesCost RealCost)  addtext (Sample,Tenant, Controls, No) append




	


////////////////////////////////////////////////////////////////////////////////
/// GROUP AND INSTALLMENTS
////////////////////////////////////////////////////////////////////////////////
 
// Instalments

generate Instalments= option_pay_installments 
replace Instalments= ll_option_pay_installments if resident==2

tab Instalments resident if Structure==1, column 
tab Instalments resident if Structure==1 & Brick==1, column 
tab Instalments resident if Structure==1 & Prefab==1, column 
tab Instalments resident if Structure==1 & Plastic==1, column 

// Group discount 

generate GroupDiscount= group_pay_discount
replace GroupDiscount= ll_group_pay_discount if resident==2

tab GroupDiscount resident, column all


tab resident IncreaseValue, row

/*
           |          IncreaseValue
  resident | don_t_k..   increase  stay_same |     Total
-----------+---------------------------------+----------
         1 |       466      2,473        708 |     3,647 
           |     12.78      67.81      19.41 |    100.00 
-----------+---------------------------------+----------
         2 |       148      1,893        427 |     2,468 
           |      6.00      76.70      17.30 |    100.00 
-----------+---------------------------------+----------
     Total |       614      4,366      1,135 |     6,115 
           |     10.04      71.40      18.56 |    100.00 
*/

// Group purchase

generate GroupPurchase= group_pay_discount
replace GroupPurchase= ll_group_pay_discount if resident==2

 tab resident GroupPurchase, row
/*     
      |               |                GroupPurchase
  resident | 100_ins..  30_upfr..  50_upfr..       none |     Total
-----------+--------------------------------------------+----------
         1 |       735        453        241      2,037 |     3,466 
           |     21.21      13.07       6.95      58.77 |    100.00 
-----------+--------------------------------------------+----------
         2 |       584        185        159      1,540 |     2,468 
           |     23.66       7.50       6.44      62.40 |    100.00 
-----------+--------------------------------------------+----------
     Total |     1,319        638        400      3,577 |     5,934 
           |     22.23      10.75       6.74      60.28 |    100.00 


*/

							  
////////////////////////////////////////////////////////////////////////////////
/// Cost guess 
////////////////////////////////////////////////////////////////////////////////

**gauging_cost_plastic gauging_cost_brick gauging_cost_pre_fab

*generate plastic_costguess=   homeowner_questionsgauging_cost_
*generate brick_costguess= v138
*generate prefab_costguess= v139

*replace plastic_costguess=   landlord_questionsgauging_cost_3 if resident==2
*replace brick_costguess= v189 if resident==2
*replace prefab_costguess=v190 if resident ==2


////////////////////////////////////////////////////////////////////////////////
/// Regression analysys  
////////////////////////////////////////////////////////////////////////////////

mprobit choice i.resident , base(0)
mprobit choice i.Frame, base(0)

mprobit choice i.Frame##i.resident, base(0) nocons

mprobit choice i.Frame IncreaseValue , base(0)  



////////////////////////////////////////////////////////////////////////////////
// Figures 
////////////////////////////////////////////////////////////////////////////////

preserve

keep resident choice Frame interest interestN afford affordN Brick Plastic PreFab     
generate T=1
saveold B1.dta, replace

replace T=2 if T==1
saveold B2.dta, replace

replace T=3 if T==2
append using B1.dta
append using B2.dta

generate ChoiceFigure= Brick
replace ChoiceFigure=Plastic if T==2
replace ChoiceFigure=PreFab if T==3

foreach var in interestN affordN {

generate `var'Figure= `var' if Brick==1 & T==1
replace `var'Figure= `var' if Plastic==1 & T==2
replace `var'Figure= `var' if PreFab==1 & T==3

}
*

cibar ChoiceFigure if resident<=2, over1(Frame) over2(T) over3(resident) graphopts(title("Choice"))
cibar interestNFigure if resident<=2, over1(Frame) over2(T) over3(resident) graphopts(title("Interested in Choice"))
cibar affordNFigure if resident<=2, over1(Frame) over2(T) over3(resident) graphopts(title("Afford Choice"))

restore
