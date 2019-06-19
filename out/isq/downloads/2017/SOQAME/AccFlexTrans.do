************************************************************************************************************
**** Basic Descriptives re: different regime types' accountability, flexibility, and transparency **********
************************************************************************************************************

use "AccFlexTrans.dta"

***** Accountability -- Audience Cost Capacity (Uzonyi et al. 2012)
tab acc if sp==1
tab acc if mil==1
tab acc if per==1

*Comparison of sp regime to mil regime


***** Flexibility -- POLCON (Henisz 2000)
sum h_polcon5 if sp==1
sum h_polcon5 if mil==1
sum h_polcon5 if per==1

*Comparison of sp regime to mil regime


****** Transparency -- Freedom of the Press (Freedom House)
sum fh_press if sp==1
sum fh_press if mil==1
sum fh_press if per==1

*Comparison of sp regime to mil regime
