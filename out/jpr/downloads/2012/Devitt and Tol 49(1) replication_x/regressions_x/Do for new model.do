****************************************
*******Climate change & Civil War*******
****************************************

describe

*Table 1 - Summary statistics

***Original model

sum wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 if wargleditsch_july2006~=. & lnnewgdp~=. & newgrowth~=. & sxp_may06~=. & peace_gleditsch~=. & colfra-af~=. & xerfrac_march08~=. & ymen1529_march08 ~=. & lnpop~=. & mount_march08~=.

***New model

sum wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 migr_mean ms_growth affdrought drought_occ avg_precip wheatprod maizeprod coargr_prod cerealprod cerealprod if lnnewgdp~=. & newgrowth~=. & sxp_may06~=. & peace_gleditsch~=. & colfra-af~=. & xerfrac_march08~=. & ymen1529_march08~=. & lnpop~=. & mount_march08~=. & migr_mean~=. & affdrought~=. & cerealprod~=. 

sum wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 migr_mean affdrought cerealprod if lnnewgdp~=. & newgrowth~=. & sxp_may06~=. & peace_gleditsch~=. & colfra-af~=. & xerfrac_march08~=. & ymen1529_march08~=. & lnpop~=. & mount_march08~=. & migr_mean~=. & affdrought~=. & cerealprod~=. & wargleditsch_july2006==0

sum wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 migr_mean ms_growth affdrought drought_occ avg_precip wheatprod maizeprod coargr_prod cerealprod if lnnewgdp~=. & newgrowth~=. & sxp_may06~=. & peace_gleditsch~=. & colfra-af~=. & xerfrac_march08~=. & ymen1529_march08~=. & lnpop~=. & mount_march08~=. & migr_mean~=. & ms_growth~=. & affdrought~=. & drought_occ~=. & avg_precip~=. & wheatprod~=. & maizeprod~=. & coargr_prod~=. & cerealprod~=. & wargleditsch_july2006==0

sum wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 migr_mean ms_growth affdrought drought_occ avg_precip wheatprod maizeprod coargr_prod cerealprod if lnnewgdp~=. & newgrowth~=. & sxp_may06~=. & peace_gleditsch~=. & colfra-af~=. & xerfrac_march08~=. & ymen1529_march08~=. & lnpop~=. & mount_march08~=. & migr_mean~=. & ms_growth~=. & affdrought~=. & drought_occ~=. & avg_precip~=. & wheatprod~=. & maizeprod~=. & coargr_prod~=. & cerealprod~=. & wargleditsch_july2006==1   

sum wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 migr_mean ms_growth affdrought drought_occ avg_precip wheatprod maizeprod coargr_prod cerealprod if lnnewgdp~=. & newgrowth~=. & sxp_may06~=. & peace_gleditsch~=. & colfra-af~=. & xerfrac_march08~=. & ymen1529_march08~=. & lnpop~=. & mount_march08~=. & migr_mean~=. & ms_growth~=. & affdrought~=. & drought_occ~=. & avg_precip~=. & wheatprod~=. & maizeprod~=. & coargr_prod~=. & cerealprod~=. & colfra_af==1

sum wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 migr_mean ms_growth affdrought drought_occ avg_precip wheatprod maizeprod coargr_prod cerealprod if lnnewgdp~=. & newgrowth~=. & sxp_may06~=. & peace_gleditsch~=. & colfra-af~=. & xerfrac_march08~=. & ymen1529_march08~=. & lnpop~=. & mount_march08~=. & migr_mean~=. & ms_growth~=. & affdrought~=. & drought_occ~=. & avg_precip~=. & wheatprod~=. & maizeprod~=. & coargr_prod~=. & cerealprod~=. & drought_occ>=1

*Table 2 - Logit regressions

*1
logit wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 sxp2_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 migr_mean affdrought cerealprod
estimates store a1

*2
logit wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 sxp2_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 migr_mean drought_occ cerealprod
estimates store a2

*3
logit wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 sxp2_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 migr_mean avg_precip cerealprod
estimates store a3

*4
logit wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 sxp2_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 migr_mean affdrought wheatprod maizeprod coargr_prod
estimates store a4

*5
logit wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 sxp2_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 migr_mean drought_occ wheatprod maizeprod coargr_prod
estimates store a5

*6
logit wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 sxp2_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 migr_mean avg_precip wheatprod maizeprod coargr_prod
estimates store a6

*7
logit wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 sxp2_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 ms_growth affdrought cerealprod
estimates store a7

*8
logit wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 sxp2_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 ms_growth drought_occ cerealprod
estimates store a8

*9
logit wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 sxp2_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 ms_growth avg_precip cerealprod
estimates store a9

*10
logit wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 sxp2_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 ms_growth affdrought wheatprod maizeprod coargr_prod
estimates store a10

*11
logit wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 sxp2_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 ms_growth drought_occ wheatprod maizeprod coargr_prod
estimates store a11

*12
logit wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 sxp2_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 ms_growth avg_precip wheatprod maizeprod coargr_prod
estimates store a12


outreg2 [a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12] using b1, bdec(5) excel nonotes alpha(0.001, 0.01, 0.05) replace addstat(Pseudo R-squared, e(r2_p)) nor2


***Step-wise deletion***

logit wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 sxp2_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 migr_mean affdrought
estimates store b1

logit wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 sxp2_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 affdrought cerealprod
estimates store b2

logit wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 sxp2_may06 peace_gleditsch colfra_af xerfrac_march08 ymen1529_march08 lnpop mount_march08 affdrought maizeprod
estimates store b3

logit wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 sxp2_may06 peace_gleditsch colfra_af ymen1529_march08 lnpop mount_march08 affdrought cerealprod
estimates store b4

logit wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 sxp2_may06 peace_gleditsch colfra_af lnpop mount_march08 affdrought cerealprod
estimates store b5

logit wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 sxp2_may06 peace_gleditsch colfra_af lnpop affdrought cerealprod
estimates store b6

logit wargleditsch_july2006 lnnewgdp newgrowth sxp_may06 sxp2_may06 peace_gleditsch lnpop affdrought cerealprod
estimates store b7

outreg2 [b1 b2 b3 b4 b5 b6 b7] using h1, bdec(5) excel nonotes alpha(0.001, 0.01, 0.05) addstat(Pseudo R-squared, e(r2_p)) nor2 nocons

