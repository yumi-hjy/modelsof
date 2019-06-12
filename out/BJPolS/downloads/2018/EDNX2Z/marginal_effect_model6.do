log using marginal_effect_model6

**** This code can be used to generate line a in Table 3 
* "Average marginal effects of ideological proximity conditional
*on the level of corruption, perceptual accuracy and political efficacy
*and their 95% confidence intervals" in the article

** The code has been generated based on Hanmer and Kalkan(2013) online Appendix
* AJPS_602_sm_suppmatS1.docx available at 
* http://onlinelibrary.wiley.com/doi/10.1111/j.1540-5907.2012.00602.x/abstract

* Hanmer, M. J. and K. O. Kalkan (2013). Behind the curve: Clarifying the best 
* approach to calculating predicted probabilities and marginal effects from 
* limited dependent variable models. American Journal of Political Science 57 (1),
* 263–277

***The measures for corruption should be purchased from the PRG Group. 
*In this article, I used the monthy measures of corruption from Table 3b and 
*calculated the annual averages:
*forvalues i=1984/2016{
*gen corruption`i'= _01_`i'+_02_`i'+ _03_`i'+_04_`i'+ _05_`i' + _06_`i'+ ///
*_07_`i'+_08_`i'+ _09_`i'+_10_`i'+ _11_`i' + _12_`i'
*}
*drop Variable _01_1984 - _01_2017
*reshape long corruption, i(Country) j(year)

** These should be merged with the data. Make sure the variable is called corruption 

** The dataset DOES NOT include a variable for corruption!!!

clear all

set mem 1000m
set maxvar 32767

set seed 99
estimates use sem2 // See probit-models-of-vote-for-the-incumbent

mat b=e(b)
mat V=e(V)


drawnorm corruption_b ideolcor_b ideolprime_b externalef_b interaction3_b ///
age_b male_b income_b loweducation_b higheducation_b unemployed_b retired_b /// 
other_b partisan_b growth_b gdp_b durable_b partyage_b pr_b pluralty_b ///
 mdmh_b p_effnv_b   p_maj_b  state_b east_b noneuro_b  system_b cons_b ///
 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 a16 a17 a18 a19 a20 a21 ///
 a22 a23 a24 a25 , mean(b) cov(V) n(1000)
  
  
merge using recoded_CSES_data.dta


*** Effect of ideolprime when corruption is low (0.1)

replace corruption=0.1

// calculate the marginal effect of ideological proximity when political
// efficacy is low (0.25) and high (1)
 
foreach j of numlist 25 100 {   

 replace externalef=`j'
 
 gen eff_ideol_`j'=.

 replace externalef=`j'/100
 

 
  quietly  forvalues i=1/1000{
 gen p_`i'=normalden(corruption_b[`i']*corruption + ///
 ideolcor_b[`i']*ideolprime*corruption + ideolprime_b[`i']*ideolprime + ///
 externalef_b[`i']*externalef + interaction3_b[`i']*externalef*ideolprime +  ///
age_b[`i']*age + male_b[`i']*male + income_b[`i']*income +  ///
loweducation_b[`i']*loweducation +  higheducation_b[`i']*higheducation + ///
unemployed_b[`i']*unemployed + retired_b[`i']*retired + other_b[`i']*other + ///
 partisan_b[`i']*partisan + gdp_b[`i']*gdp + durable_b[`i']*durable + ///
 partyage_b[`i']*partyage + pr_b[`i']*pr + pluralty_b[`i']*pluralty +  ///
 mdmh_b[`i']*mdmh + p_effnv_b[`i']*p_effnv +   p_maj_b[`i']*p_maj + ///
 state_b[`i']*state_b + east_b[`i']*east + noneuro_b[`i']*noneuro + ///
 system_b[`i']*system + growth_b[`i']*growth + ///
cons_b[`i'])*(ideolcor_b[`i']*corruption+ ideolprime_b[`i'] + ///
 interaction3_b[`i']*externalef)
 
 sum p_`i', meanonly
 
 replace eff_ideol_`j'=r(mean) in `i'
 }
 drop p_1-p_1000
 
  }
  
 gen effect_lc=. // estimate
  gen effect_l_lc=. // low value of 95% confidence interval
 gen effect_u_lc=. // high value of 95% confidence interval

  
foreach k of numlist  25 100 {
 sum eff_ideol_`k', meanonly
 replace effect_lc=r(mean) in `k'
 centile eff_ideol_`k', centile(2.5)
  replace effect_l_lc=r(c_1) in `k'
 centile eff_ideol_`k', centile(97.5)
  replace effect_u_lc=r(c_1) in `k'
  }
  
  
drop eff_ideol_25 eff_ideol_100



*** Effect of ideolprime when corruption is high

replace corruption=0.8


 
foreach j of numlist 25 100 {   
 
 gen eff_ideol_`j'=.

 replace externalef=`j'/100
 
 // calculate the marginal effect of ideological proximity when political
// efficacy is low (0.25) and high (1)

  quietly forvalues i=1/1000{
 gen p_`i'=normalden(corruption_b[`i']*corruption + ///
 ideolcor_b[`i']*ideolprime*corruption + ideolprime_b[`i']*ideolprime + ///
 externalef_b[`i']*externalef + interaction3_b[`i']*externalef*ideolprime +  ///
age_b[`i']*age + male_b[`i']*male + income_b[`i']*income +  ///
loweducation_b[`i']*loweducation +  higheducation_b[`i']*higheducation + ///
unemployed_b[`i']*unemployed + retired_b[`i']*retired + other_b[`i']*other + ///
 partisan_b[`i']*partisan + gdp_b[`i']*gdp + durable_b[`i']*durable + ///
 partyage_b[`i']*partyage + pr_b[`i']*pr + pluralty_b[`i']*pluralty +  ///
 mdmh_b[`i']*mdmh + p_effnv_b[`i']*p_effnv +   p_maj_b[`i']*p_maj + ///
 state_b[`i']*state_b + east_b[`i']*east + noneuro_b[`i']*noneuro + ///
 system_b[`i']*system + growth_b[`i']*growth + ///
cons_b[`i'])*(ideolcor_b[`i']*corruption+ ideolprime_b[`i'] + ///
 interaction3_b[`i']*externalef)
 
 sum p_`i', meanonly
 
 replace eff_ideol_`j'=r(mean) in `i'
 }
 drop p_1-p_1000
 
  }
  
 gen effect_hc=. // estimate
  gen effect_l_hc=. //low value of 95% confidence interval
 gen effect_u_hc=. // high value of 95% confidence interval
 

  
foreach k of numlist  25 100 {
 sum eff_ideol_`k', meanonly
 replace effect_hc=r(mean) in `k'
 centile eff_ideol_`k', centile(2.5)
  replace effect_l_hc=r(c_1) in `k'
 centile eff_ideol_`k', centile(97.5)
  replace effect_u_hc=r(c_1) in `k'
  }
  
  *** The marginal effect of ideological voting when:
  * low political efficacy, low corruption: 
list effect_lc effect_l_lc effect_u_lc in 25

   * low political efficacy, high corruption: 
list effect_hc effect_l_hc effect_u_hc in 25 

   * high political efficacy, low corruption: 
list effect_lc effect_l_lc effect_u_lc in 100
  
   * high political efficacy, high corruption: 
list effect_hc effect_l_hc effect_u_hc in 100

log close
 