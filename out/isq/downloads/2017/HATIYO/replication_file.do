*     ***************************************************************** *;

tabulate treatment gender, chi2 row
tabulate treatment region, chi2 row
tabulate treatment urban, chi2 row
by treatment, sort: summarize age
anova treatment age
tabulate treatment education, chi2 row
by treatment, sort: summarize polknowledge
anova treatment polknowledge

	
	/*ATE*/
	
	/*ATE, Men (Figure 3)*/
	
	
	
replace treatment_usimams=0 if treatment==2
replace treatment_usimams=1 if treatment==3
ttest dv_indexstand, by(treatment_usimams)
ttest dv_indexstand if gender==0, by(treatment_usimams)
ttest dv_indexstand if gender==1, by(treatment_usimams)



by regime_supporter, sort: ttest dv_indexstand if gender==1 & (treatment==1 | treatment==2), by(treatment) unequal

display .1480696*sqrt(127)
display 0.0001*4