*This is a STATA Do-file to replicate the standard deviations of Column (2) of Table 2 and Columns (1)-(2) of Table 3 in Feenstra-Li-Yu (2014, ReSTATA)            *
*The code is by Robert Feenstra (UC-Davis), Zhiyuan Li(SHUFE), and Miaojie Yu(Peking Univ.)                                                                        *
*To run the code, please put all datasets in the same directoray in your PC                                                                                        *
*After getting the standard deviations, we store it in a separate spreadsheet called "bootstrapped t-value" to manually calculate the t-values reported in the text*

********** STATA SETUP
clear
drop _all
set memory 31g
set matsize 11000
set more off

capture log close   
log using Table2_C2_Table3_C1C2_se_bootstrap.out, text replace



*********************************************Bootstrap Regressions***********************************


****generate blank stack to save outcomes********
g btfp=0
g btang_p1=0
g btang_d1=0
g bklratio1=0


g btang_p2=0
g btang_d2=0
g bklratio2=0
g bimr=0

g beta1=0
g beta2=0
g beta3=0
g beta4=0
g beta5=0

g stfp=0
g stang_p1=0
g stang_d1=0
g sklratio1=0

g stang_p2=0
g stang_d2=0
g sklratio2=0
g simr=0

g se1=0
g se2=0
g se3=0
g se4=0
g se5=0


save  Table2n3_Stack_1, replace


************
* This program runs the panel bootstrapping by randomly drawing firms.
* There are in fact 5 steps to obtain the standard deviations in column 2 of Table 2 and in columns (1)-(2) of Table 3 in the following loop: 
*(1) The pliminary regression of firm TFP (called tfpop) on firm-level indicators, 4-digit industry indicators and ex-ante TFP (called tfpop2), and interactions between 2-digit industry indicators and other variables that appead on the right of Equ. (30) in the text (skipped here)
*(2) The selectin equation (30) in the text using fitted TFP
*(3) The second-step Heckman Equation excluding fitted TFP, used to obtain predicted export share
*(4) The  first-step of the 2SLS estimates, see footnote 26 in the text for details
*(5) The second-step of the 2SLS estimates, see footnote 26 in the text for details





***********************************
forvalues i=1/100 {

****READ DATA**************
* This is the dataset that have done the first step (i.e., prelim fit) and hence predicted TFP (tfpp) is already included there****
u  Table2_c1c2_Table3_c1c2_tfpp



****bootstrap*********
bsample, cluster(newid)
disp "iteration # `i'"
**********************



***Step (1): Prelim Fit which is already done in previous step and its outcome variable, predicted TFP (tfpp) is already included in the current dataset**
***Step (2): The Selection Equation with fitted TFP (tfpp)*******************
xi: qui probit FX tfpp   tang_percent  tang_dummy klratio* dyear2-dyear9 i.cic_adj
predict XI

g btfp=_b[tfpp]
g btang_p1=_b[tang_percent]
g btang_d1=_b[tang_dummy]
g bklratio1=_b[klratio]

g stfp=_se[tfpp]
g stang_p1=_se[tang_percent]
g stang_d1=_se[tang_dummy]
g sklratio1=_se[klratio]

predict PROBITXB, xb
gen PDFPROBIT=(1/sqrt(2*_pi))*exp(-(PROBITXB^2/2))
gen CDFPROBIT = normprob(PROBITXB)
gen IMR_klratio = PDFPROBIT/CDFPROBIT      /* gets the inverse mills ratio*/
su IMR_klratio


***Step (3): the second-step Heckman Equation excluding fitted TFP, used to obtain predicted export share, shown as Column (2) of Table 3******************
xi: qui reg expint tang_percent tang_dummy klratio* IMR_klratio dyear2-dyear9 i.cic_adj
predict expint_p



g btang_p2=_b[tang_percent]
g btang_d2=_b[tang_dummy]
g bklratio2=_b[klratio]
g bimr=_b[IMR_klratio]

g stang_p2=_se[tang_percent]
g stang_d2=_se[tang_dummy]
g sklratio2=_se[klratio]
g simr=_se[IMR_klratio]

g diff=expint-expint_p
su diff if FX==1
g diffvar=r(Var)  

su expint if FX==1
g etamean=r(mean)


g expintpsq=(expint_p)^2
g expintsqp=expintpsq/XI*(1+diffvar/(etamean)^2)
g expintsqp_int=expintsqp*int_usd



*****Generate variables for main estimates*********************
 g       iv            =exp(tfpop2)
 g       iv_expintp    =iv*expint_p
 g       iv_expintsqp  =iv*(expintsqp)  
 g       expintp_int   =expint_p*int_usd






****Step (4)-(5): 2SLS estimates of Equ. (25), shown as Column (3) of Table 2********
**Coefficients of the 2nd-step results are reported in the text, though t-values will be corrected by using bootstrap as reported in other files


xi: qui ivreg2 rev_usd  (int_usd  expintp_int expintsqp_int =iv  iv_expintp iv_expintsqp) expint_p   FX    i.cic1d    dyear* , robust 

g beta1=_b[int_usd]
g beta2=_b[expintp_int]
g beta3=_b[expintsqp_int]
g beta4=_b[expint_p]
g beta5=_b[FX]

g se1=_se[int_usd]
g se2=_se[expintp_int]
g se3=_se[expintsqp_int]
g se4=_se[expint_p]
g se5=_se[FX]

duplicates drop beta1, force
keep beta* se* btfp btang* bklratio* bimr stfp  stang* sklratio* simr 

  append using Table2n3_Stack_1
save Table2n3_Stack_1, replace
}
su

********** CLOSE OUTPUT
drop _all
log close