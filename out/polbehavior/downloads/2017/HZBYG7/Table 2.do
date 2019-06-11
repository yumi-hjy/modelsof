*Use Country_Ind_Party_Distance.dta

set more off

*********************************************************************************
**** Variables ******************************************************************
*********************************************************************************

***Dependent Variables
*Distance from Mean Party Placement: mean_lr_deviance_abs
*Distance from Expert Party Placement: expert_lr_deviance_abs

***Independent Variables (Party Variables)
*Party Age: age_ 
*Party Ideology: LR_ideology_ 
*Party Vote Percent: B5001_
*Standard Deviation of Party Placement: SD_respondent_lr_placement

***Independent Varibles (Individual Variables)
*Income: Income 
*Education: Education 
*Political Information: PolInfo_Index 
*Age: Age 
*Female: Female 
*Urbanness: Urbanness 
*Contact Politician: ContactPol 
*Vote: Vote_curr

***Independent Variables (Country Variables)
*Plurality: Plurality 
*Presidential: Presidential 
*Federalism: Federalism 
*ENP (Effective Number of Parties): Eff_Num_Parties  
*Age Electoral System: AgeEleSyst 
*Age Democracy: AgeDemocracy

***Other Independent Variables
*Did Not Place Self: noplacedself_hat_xtmelogit
*Did Not Place Min Two Parties: noplacedmin2_hat_xtmelogit
*Did Not Place Self or Min Two Parties: noSat_Crit12_hat_xtmelogit

***If Only Considering the Major Parties
*Major parties: if include_==1

***Identifiers
*Level 1 (Party level): party_ID
*Level 2 (Individual level): B1005
*Level 3 (Country level): B1003

sum mean_lr_deviance_abs expert_lr_deviance_abs age_ LR_ideology_ B5001_ SD_respondent_lr_placement Income Education PolInfo_Index Age Female Urbanness ContactPol Vote_curr Plurality Presidential Federalism Eff_Num_Parties  AgeEleSyst AgeDemocracy noplacedself_hat_xtmelogit noplacedmin2_hat_xtmelogit noSat_Crit12_hat_xtmelogit party_ID B1005 B1003 include_

************************************************************************************************************************************************
**** Table 2: Distance from Mean Party Placement (all parties) **************************************************************
************************************************************************************************************************************************

xtmixed mean_lr_deviance_abs age_ LR_ideology_ B5001_ SD_respondent_lr_placement Income Education PolInfo_Index Age Female Urbanness ContactPol Vote_curr Plurality Presidential Federalism Eff_Num_Parties  AgeEleSyst AgeDemocracy ||  B1003: ||  B1005: , mle
estimates store M1

xtmixed mean_lr_deviance_abs age_ LR_ideology_ B5001_ SD_respondent_lr_placement Income Education PolInfo_Index Age Female Urbanness ContactPol Vote_curr Plurality Presidential Federalism Eff_Num_Parties  AgeEleSyst AgeDemocracy noplacedself_hat_xtmelogit ||  B1003: ||  B1005: , mle
estimates store M2

xtmixed mean_lr_deviance_abs age_ LR_ideology_ B5001_ SD_respondent_lr_placement Income Education PolInfo_Index Age Female Urbanness ContactPol Vote_curr Plurality Presidential Federalism Eff_Num_Parties  AgeEleSyst AgeDemocracy noplacedself_hat_xtmelogit noplacedmin2_hat_xtmelogit  ||  B1003: ||  B1005: , mle
estimates store M3

xtmixed mean_lr_deviance_abs age_ LR_ideology_ B5001_ SD_respondent_lr_placement Income Education PolInfo_Index Age Female Urbanness ContactPol Vote_curr Plurality Presidential Federalism Eff_Num_Parties  AgeEleSyst AgeDemocracy noplacedself_hat_xtmelogit noSat_Crit12_hat_xtmelogit  ||  B1003: ||  B1005: , mle
estimates store M4

esttab M1 M2 M3 M4, b(%7.3f) starlevels(* .10 ** .05 *** .01) stats (N, label("N") fmt(%9.0g %9.2f))





