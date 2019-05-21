***************************
*MASTER MODELS - Table 2
***************************

*use "/Users/.../FoxNews_Master.dta"

set more off

gen daysfox=daystoelection*FoxNews
gen days2fox=daystoelection2*FoxNews
gen days3fox=daystoelection3*FoxNews

*Democrats

*Republicans

*Code for the simulated predictions for these and other models is available from the authors upon request.


*****************************************
*DEMOCRATIC VOTE SHARE MODELS - Table 3
*****************************************

clear

*use "/Users/.../FoxNews_Master.dta"

gen dvprop=dv/100

gen daysdv=daystoelection*dvprop
gen days2dv=daystoelection2*dvprop
gen days3dv=daystoelection3*dvprop

*Democrats Without Fox

*Republicans With Fox

*Republicans Without Fox


********************************************
*INTERRUPTED TIME SERIES MODELS - Table 4
********************************************

clear

*use "/Users/.../FoxNews_InterruptedTimeSeries.dta"

*Democrats 


*CONTINUOUS MEASURE MODELS - Table 5
********************************************

clear

*use "/Users/.../FoxNews_Master.dta"

gen dayscontexp=daystoelection*ContinuousExposure
gen days2contexp=daystoelection2*ContinuousExposure
gen days3contexp=daystoelection3*ContinuousExposure

*Democrats


*******************************
*ROBUSTNESS CHECKS - Table 6
*******************************

*PLACEBO TEST

clear

*use "/Users/.../FoxNews_Placebo.dta"

*Democrats

*Republicans 


*NON-PARTY VOTES

clear

*use "/Users/.../FoxNews_Master.dta"

gen daysfox=daystoelection*FoxNews
gen days2fox=daystoelection2*FoxNews
gen days3fox=daystoelection3*FoxNews

*Democrats

*Republicans


