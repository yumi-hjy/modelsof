//Final Do File to Accompany Self Monitoring Paper//




clear
//keep hispanic black asian white workbla violbla /*
*/eqright eqchanc eqpeopl blame hardwrk poverty /*
*/strongr closer strongd /*
*/conserv moderat liberal /*
*/i_expec i_amnot i_nojoy i_deciv /* 
*/yearbrn educ gender /*
*/irish tryhard deserve slavery discrim noeduc /*
*/homeown integr locgov spended affact1 affact2 /*
*/profil1 profil2 profil3 deathpe favord /*
*/suspend nylaw innocen helpblc /*
*/profil2 profil3 deathpe favord suspend nylaw innocen /*
*/pct_aa nxtdoor localtv area areacode zip
//Generate a pseudo zip
//egen cluster=group(zip)
//replace zip=cluster
//The original data file was merged with census data based on respondent zipcode//
//To preserve participant anonymity, the replication data includes the contextual data we use
//the survey variables we rely on, but excludes identifying information, including zipcodes
  
//The above syntax explains how the data for replication were generated. Run everything below
  
  
//Various Measures of Context//
************************************************************************
set scheme s2mono
//A zero to 1 scale//
 
//Black v. White Heterogeneity//
//This is the measure in the paper, the rest are for the appendix//
gen het2=p2-sum2
graph twoway histogram het2 || kdensity het2, bwidth(0.05) ytitle("density") xtitle("Heterogeneity, Blacks/Whites") legend(label(1 "Histogram") label(2 "Kernel Density") )

//Just percentage black//
graph twoway histogram black || kdensity black, bwidth(0.05) ytitle("density") xtitle("Percent Black") legend(label(1 "Histogram") label(2 "Kernel Density") )

//Black:White//
*replace this to vary from 0 to 1
sum dif
replace dif=(dif+ .9870968 )/1.712533
gen lndif=ln(dif+.01)
  
**Recode so that dissembling is reject, midpoint, or opt out.
recode mid1 (1 2 4=1) (3=0), gen(dissemble1)
recode mid2 (1 3 4=1) (2=0), gen(dissemble2)

************************************************************

//Independent variables//


recode eqright (5 6=.), gen(eqright_r)
recode eqchanc (1=4) (2=3) (3=2) (4=1)  (5 6=.), gen(eqchanc_r)
recode eqpeopl (5 6=.), gen(eqpeopl_r)
replace eqright_r=(eqright_r-1)/3
replace eqchanc_r=(eqchanc_r-1)/3
replace eqpeopl_r=(eqpeopl_r-1)/3
egen egalitarianism=rmean(eqright_r eqpeopl_r)

recode blame (1=4) (2=3) (3=2) (4=1) (5 6=.), gen(blame_r)
recode hardwrk  (5 6=.), gen(hardwrk_r)
recode poverty (1=3) (2=1) (3=2) (4=2) (5 6=.), gen(poverty_r)
replace blame_r=(blame_r-1)/3
replace hardwrk_r=(hardwrk_r-1)/3
replace poverty_r=(poverty_r-1)/3
alpha blame_r poverty_r
egen individualism=rmean(blame_r poverty_r)
**High scores are republicans and conservatives**
recode i_amnot (1=4) (2=3) (3=2) (4=1) (5 6=.), gen(i_amnot_r )
recode i_nojoy (1=4) (2=3) (3=2) (4=1) (5 6=.), gen(i_nojoy_r)
recode i_deciv (1=4) (2=3) (3=2) (4=1) (5 6=.), gen(i_deciv_r )
replace i_expec_r=(i_expec_r-1)/3
replace i_amnot_r=(i_amnot_r-1)/3
replace i_nojoy_r=(i_nojoy_r-1)/3
replace i_deciv_r=(i_deciv_r-1)/3
alpha i_expec_r i_amnot_r i_nojoy_r i_deciv_r
egen smonitor=rmean(i_expec_r i_amnot_r i_nojoy_r i_deciv_r)
gen welfbla0=welfarb
replace welfbla0=. if welfbla0>10
replace welfbla0=(welfbla0-1)/9
replace wealthb=. if wealthb>10
gen poorbla0=((11-wealthb)-1)/9

replace workwhi=. if workwhi>10


//Generate several "difference" measures//
gen d1_violent=violbla0-violwhi0
gen d1_work=workbla0-workwhi0
reg violbla0 violwhi0
reg workbla0 workwhi0



//Age//
replace yearbrn=. if yearbrn>1983
gen age=2001-yearbrn
gen agemiss=age==.




//Other Demographic Variables
*Education is 1 if some college or greater

//Dependent variables//


gen pcent=pct_aa
replace pcent=0 if nxtdoor==2
recode pcent (999 998 111=.)

//Media consumption
gen local=localtv
replace local=. if local==8

//Wave variable
gen wave_r=0 if area<.
replace wave_r=1 if areacode<.

egen EGALITARIANISM=mean(egalitarianism) 
egen LOCAL=mean(local)

replace het=het-HET
replace local=local-LOCAL
//Weak evidence that SM correlation varies across smonitoring.
corr workbla0 violbla0 if smonitor> .1246931  & smonitor<.
corr workbla0 violbla0 if  smonitor<-.1253069 
corr workbla0 violbla0 if smonitor>-.1252  & smonitor<.125  

alpha deathpe suspend nylaw innocen
 
//model with difference black-white//
local h="dif"

//Impute Age. Linear projection of covariates. Things do not substantively change when interactions and dvs are included
mi query
mi set mlong
mi register imputed age 
mi register regular egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor dif 
mi impute mvn age  =  egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor dif , add(1) rseed(546) force 

//Mean center after imputation
egen AGE=mean(age)
replace age=age-AGE
replace hiD=0 if dif<=-.1350976  

sum smonitor, detail
gen hiS=1 if smonitor>=.2913598      & smonitor<.
replace hiS=0 if smonitor<= -0.2919736

by hiD, sort: sum  egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor age dif

//Also for supplement
by zip, sort: gen count=_n
drop if count!=1
drop if hiD==.
sort hiD zip
keep hiD zip

////////////////////////////////////////////////////////////////////////////////////////////////////////////

//These are the tables//
//Table 1, OLS results
//Table 2, Marginal effects
//Tables 3 and 4, Dissembling analysis

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
sum  egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor age dif
//First order effects (Reported in Table 1)
reg dv_1 egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor age dif
reg death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor age dif
//Interactive Model with three ways (Reported in Table 1). Uncomment est store below for footnote X
reg dv_1 egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor age dif workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP  
est store a1
reg death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor age dif workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP  
est store a2
suest a1 a2
test [a1_mean]_b[workXsmXZIP]-[a2_mean]_b[workXsmXZIP]=0
test [a1_mean]_b[vioXsmXZIP]-[a2_mean]_b[vioXsmXZIP]=0
//Dissembling Table Model (Reported in Tables 3 and 4)
reg workbla0 egalitarianism individualism pid libcon gender educ smonitor age dif  ZIPbXsm
//Alternative Specifications and Estimators (Reported in Supplementary Table A1)
//These are reported in supplementary appendix, table A1.
reg dv_1 egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP, cluster(zip)
reg death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP, cluster(zip)
xtmixed dv_1 egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP ||zip:
xtmixed death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP || zip:
//Heckman Model. This is included in a footnote.
heckman workbla0 egalitarianism individualism  pid libcon gender educ smonitor age agemiss dif  ZIPbXsm, select(egalitarianism individualism  pid libcon gender educ smonitor age dif ZIPbXsm resent4)
recode mid1 (1=1) (2=0) (3=0) (4=.), gen (mi1)
recode mid2 (1=1) (2=0) (3=0) (4=.), gen (mi2)
//Check this below
heckman mi1 egalitarianism individualism  pid libcon gender educ smonitor age dif  ZIPbXsm, select(egalitarianism individualism  pid libcon gender educ smonitor age dif ZIPbXsm resent4)
heckman mi2 egalitarianism individualism  pid libcon gender educ smonitor age dif  ZIPbXsm, select(egalitarianism individualism  pid libcon gender educ smonitor age dif ZIPbXsm resent4)

//Footnote XX
//These models are included in Footnote XX. They add survey wave and media consumption
//First order effects (Reported in Table 1)
reg dv_1 egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor age dif local wave_r
reg death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor age dif local wave_r
//Interactive Model with three ways (Reported in Table 1). Uncomment est store below for footnote X
reg dv_1 egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor age dif workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP  local wave_r
reg death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor age dif workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP  local wave_r
//Dissembling Table Model (Reported in Tables 3 and 4)
reg workbla0 egalitarianism individualism pid libcon gender educ smonitor age dif  ZIPbXsm local wave_r

//These models are included in Footnote XX. They rely on a censored version of diversity.
drop ZIPbXsm-vioXsmXZIP
gen censored_dif=black-white
replace censored_dif=0 if censored_dif>0 & censored_dif<.
local h="censored_dif"

reg dv_1 egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor age censored_dif 
reg death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor censored_dif  
//Interactive Model with three ways (Reported in Table 1). Uncomment est store below for footnote X
reg dv_1 egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor age censored_dif  workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP  
reg death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor age censored_dif  workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP 
//Dissembling Table Model (Reported in Tables 3 and 4)
reg workbla0 egalitarianism individualism pid libcon gender educ smonitor age censored_dif   ZIPbXsm



//Simple Slopes/Marginal Effects Analysis for the Text//
//This is table 2.
//Note: The fixed values are assuming nothing is mean centered. So do not mean center if this is run; otherwise,change 10, 25, 75, and 90 percentiles
//Racial Policy//
*p<0.10, 1.645
**p<0.05, 2.03
***p<0.01, 2.7
reg dv_1 egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
	  *10th percentile SM and 10th percentile DIF
	  local valsm = 0
	  local valblack=0.01
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 			  
			  di dydx2 se2 
			  			  di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
	*10th percentile SM and 25th percentile DIF
	 local valsm = 0
	  local valblack=0.031
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2
			    di dydx1/se1
						  di dydx2/se2 
			  drop dydx1 se1 dydx2 se2  			  
	*10th percentile SM and 75th percentile DIF
	 local valsm = 0
	  local valblack=0.172
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2	  
	*10th percentile SM and 90th percentile DIF
	 local valsm = 0
	  local valblack=0.381
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2	
			  
			    
   *25th percentile SM and 10th percentile DIF
	  local valsm = 0.167
	  local valblack=0.01
	          quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
	*25th percentile SM and 25th percentile DIF
	 local valsm = 0.167
	  local valblack=0.031
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2		  			  
	*25th percentile SM and 75th percentile DIF
	 local valsm = 0.167
	  local valblack=0.172
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2  
	*25th percentile SM and 90th percentile DIF
	 local valsm = 0.167
	  local valblack=0.381
	    quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
	*75th percentile SM and 10th percentile DIF
	  local valsm = 0.417
	  local valblack=0.01
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
	*75th percentile SM and 25th percentile DIF
	 local valsm = 0.417
	  local valblack=0.031
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2  			  
	*75th percentile SM and 75th percentile DIF
	 local valsm = 0.417
	  local valblack=0.172
	          quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2 
	*75th percentile SM and 90th percentile DIF
	 local valsm = 0.417
	  local valblack=0.381
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2		  
	  
	*90th percentile SM and 10th percentile DIF
	  local valsm = 0.58
	  local valblack=0.01
	          quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
	*90th percentile SM and 25th percentile DIF
	 local valsm = 0.58
	  local valblack=0.031
	          quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2	  			  
	*90th percentile SM and 75th percentile DIF
	 local valsm = 0.58
	  local valblack=0.172
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2  
	*90th percentile SM and 90th percentile DIF
	 local valsm = 0.58
	  local valblack=0.381
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
			  			  		  
//Death Penalty Attitudes
//The fixed values are assuming nothing is mean centered. So do not mean center if this is run; otherwise,change 10, 25, 75, and 90 percentiles

reg death_penalty egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
	 	  *10th percentile SM and 10th percentile DIF
	  local valsm = 0
	  local valblack=0.01
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 			  
			  di dydx2 se2 
			  			  di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
	*10th percentile SM and 25th percentile DIF
	 local valsm = 0
	  local valblack=0.031
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2
			    di dydx1/se1
						  di dydx2/se2 
			  drop dydx1 se1 dydx2 se2  			  
	*10th percentile SM and 75th percentile DIF
	 local valsm = 0
	  local valblack=0.172
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2	  
	*10th percentile SM and 90th percentile DIF
	 local valsm = 0
	  local valblack=0.381
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2	
			  
			    
   *25th percentile SM and 10th percentile DIF
	  local valsm = 0.167
	  local valblack=0.01
	          quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
	*25th percentile SM and 25th percentile DIF
	 local valsm = 0.167
	  local valblack=0.031
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2		  			  
	*25th percentile SM and 75th percentile DIF
	 local valsm = 0.167
	  local valblack=0.172
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2  
	*25th percentile SM and 90th percentile DIF
	 local valsm = 0.167
	  local valblack=0.381
	    quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
	*75th percentile SM and 10th percentile DIF
	  local valsm = 0.417
	  local valblack=0.01
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
	*75th percentile SM and 25th percentile DIF
	 local valsm = 0.417
	  local valblack=0.031
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2  			  
	*75th percentile SM and 75th percentile DIF
	 local valsm = 0.417
	  local valblack=0.172
	          quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2 
	*75th percentile SM and 90th percentile DIF
	 local valsm = 0.417
	  local valblack=0.381
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2		  
	  
	*90th percentile SM and 10th percentile DIF
	  local valsm = 0.58
	  local valblack=0.01
	          quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
	*90th percentile SM and 25th percentile DIF
	 local valsm = 0.58
	  local valblack=0.031
	          quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2	  			  
	*90th percentile SM and 75th percentile DIF
	 local valsm = 0.58
	  local valblack=0.172
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2  
	*90th percentile SM and 90th percentile DIF
	 local valsm = 0.58
	  local valblack=0.381
	         quietly predictnl dydx1=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se1)
			 quietly predictnl dydx2=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se2)
			  di dydx1 se1 
			  di dydx2 se2 
			    di dydx1/se1
						  di dydx2/se2
			  drop dydx1 se1 dydx2 se2
			  			  		  		
			  			  		  		
			  			  		  		


//Wireframe Plot to create figures A2 and A3****
//Again, not mean centered, so comment mean centering syntax above if used.
local h="dif"
set obs 101
gen n=_n
reg dv_1 egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
set more off
**Create a 100x100 matrix with SM on the row, Diversity on the column. Do not mean center**
forvalues j=1/59{
    gen t`j'=.
    }    
    set more off
*Loop around values of sm. Go from 0.10 to 90th percentile which is 0.to 0.58
  forvalues i=1/59{
	  local valsm = (`i'-1)/100
	  *Loop around values of value black, go from 10 to 90th 
              forvalues j=2/39{
              	local valblack=(`j'-1)/100
                  quietly predictnl dydx=_b[workbla0]+_b[workblaXsm]*`valsm'+_b[workblaXZIPb]*`valblack'+_b[workXsmXZIP]*`valblack'*`valsm', se(se)
                  quietly replace t`j'=dydx/se if n==`i'
               drop dydx se
               }
}
reg death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
set more off
**Create two 100x100 matrix with SM on the row, Diversity on the column**
forvalues j=1/59{
    gen u`j'=.
    }    
    set more off
*Loop around values of sm. Go from 0.10 to 90th percentile which is 0 to 0.58
  forvalues i=1/59{
	  local valsm = (`i'-1)/100
	  *Loop around values of value black, go from 10 to 90th, which is 0.01 to 0.38
              forvalues j=2/39{
              	local valblack=(`j'-1)/100
                  quietly predictnl dydx=_b[violbla0]+_b[violblaXsm]*`valsm'+_b[violblaXZIPb]*`valblack'+_b[vioXsmXZIP]*`valblack'*`valsm', se(se)
                  quietly replace u`j'=dydx/se if n==`i'
               drop dydx se
               }
}
**Output a file to create a wireframe plot in R**
outsheet t1-t59 u1-u59 in 1/101 using "wire.csv", comma  replace

	  			  
			  			  
//Table A2 and A3; this model excludes values
reg dv_1   pid libcon  workbla0 violbla0 gender educ smonitor dif age 
reg death_penalty  pid libcon  workbla0 violbla0 gender educ smonitor dif age
reg dv_1 pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
reg death_penalty  pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
reg workbla0   pid libcon gender educ smonitor age dif  ZIPbXsm  
reg violbla0   pid libcon gender educ smonitor age dif  ZIPbXsm   
mlogit mid1   pid libcon gender educ smonitor age dif  ZIPbXsm  , base(3) 
mlogit mid2   pid libcon gender educ smonitor age dif  ZIPbXsm  , base(2) 

//Imputation Models (Reported in Footnote)
*drop age
//Age//
replace yearbrn=. if yearbrn>1983
drop age
gen age=2001-yearbrn
mi query
mi set mlong
mi register imputed age 
mi register regular egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor dif 
//Multiple Imputations
mi impute mvn age  =  egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor dif , add(20) rseed(546) force 
mi estimate: reg dv_1  egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor dif workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP  age 
mi estimate: reg death_penalty  egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor dif age workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
mi estimate: reg workbla0  egalitarianism individualism pid libcon gender educ smonitor age dif  ZIPbXsm


//Additional Robustness checks for supplementary material (Table A5, A6, and A7)
//Branton and Jones (2005) measure
drop ZIPbXsm-vioXsmXZIP
local h="het"
reg dv_1 egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor `h' age 
reg death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor `h' age
reg dv_1 egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor age `h' workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
reg death_penalty egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor age `h' workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
reg workbla0  egalitarianism individualism pid libcon gender educ smonitor age `h'  ZIPbXsm
mlogit mid1 egalitarianism individualism pid libcon gender educ smonitor age `h' ZIPbXsm , base(3)
reg violbla0  egalitarianism individualism pid libcon gender educ smonitor age `h'  ZIPbXsm
mlogit mid2 egalitarianism individualism pid libcon gender educ smonitor age  `h' ZIPbXsm , base(2)



//Alternative specification using log transformed (Reported in Table A8, A9, and A10)
drop ZIPbXsm-vioXsmXZIP
local h="lndif"
reg dv_1 egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor `h' age 
reg death_penalty egalitarianism individualism pid libcon  workbla0 violbla0 gender educ smonitor `h' age
reg dv_1 egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor age `h' workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
reg death_penalty egalitarianism individualism  pid libcon  workbla0 violbla0 gender educ smonitor age `h' workblaXsm violblaXsm ZIPbXsm workblaXZIPb violblaXZIPb workXsmXZIP vioXsmXZIP
reg workbla0  egalitarianism individualism pid libcon gender educ smonitor age `h'  ZIPbXsm
mlogit mid1 egalitarianism individualism pid libcon gender educ smonitor age  `h' ZIPbXsm , base(3)
reg violbla0  egalitarianism individualism pid libcon gender educ smonitor age `h'  ZIPbXsm
mlogit mid2 egalitarianism individualism pid libcon gender educ smonitor age  `h' ZIPbXsm , base(2)



//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//
//Figures 1 and 2 reported in the Text//

*Syntax to Generate Figures 1 and 2. Generate figure at 10 and 90 percentiles for SM and Diversity
**Do not use mean centered variables***


drop stereot
estsimp reg violbla0 egalitarianism individualism  pid libcon gender educ smonitor age dif  ZIPbXsm


			local black=blackhat
			local black=blackhat

gen vv1=v1
gen vv2=v2
gen vv3=v3
gen vv7=v7

***Multinomial logit figures*********
generate ploa1=.
***Low Diversity****
		      local black=blackhat
***High Diversity****
		      local black=blackhat
***Low Diversity****
		      local black=blackhat

***High Diversity****
		      local black=blackhat
*Midpoint
*Reject
*Endorse
*Opt out