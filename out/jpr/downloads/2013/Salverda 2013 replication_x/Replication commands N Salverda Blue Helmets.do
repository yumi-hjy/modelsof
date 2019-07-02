*** do-file for:
**Blue Helmets as Targets: 
**A Quantitative Analysis of Rebel Violence Against Peacekeepers, 1989-2003

**Nynke Salverda
**Department of Peace and Conflict Research, Uppsala University
**nynke.salverda@pcr.uu.se
**all regressions are carried out in stata 12.1





eststo: logit dv d_fightcap duration logsize d_rebsup logbattle nonun peaceyear peaceyear2 peaceyear3, cluster(cluster)
eststo: logit dv d_rebstrength duration sizexstr logsize d_rebsup logbattle nonun peaceyear peaceyear2 peaceyear3, cluster(cluster)
eststo: logit dv d_fightcap duration logsize sizexfight d_rebsup logbattle nonun peaceyear peaceyear2 peaceyear3, cluster(cluster)

esttab using table5.rtf, replace ///
mtitles("Model 1 (Relative Strength)" "Model 2 (Fighting Capacity)" "Model 3 (Interaction Rel Strength)" "Model 4 (Interaction Fight Cap)") ///
setx d_rebstrength 1
**table six, robustness
eststo clear
eststo: logit dv d_rebstrength duration d_rebsup logsize  logbattle nonun incomp pa negoti peaceyear peaceyear2 peaceyear3, cluster(cluster)
eststo: logit dv d_fightcap duration d_rebsup logbattle logsize nonun incomp pa negoti peaceyear peaceyear2 peaceyear3, cluster(cluster)
*standalone
eststo:logit dv d_rebstrength incomp pa negoti peaceyear peaceyear2 peaceyear3, cluster(cluster)
eststo: logit dv d_fightcap incomp pa negoti peaceyear peaceyear2 peaceyear3, cluster(cluster)

esttab using table6.rtf, replace ///
scalars( N "r2_p Pseudo R2" "Proportionate Reduction in Error" "aic AIC" "Area under ROC curve" ) ///
noeqlines se label nonumbers mtitles("Model 3" "Model 4" "Model 5" "Model 6") ///
title(Table 6: Robustness: Inclusion of Different Controls) modelwidth(0) varwidth(12) ///
onecell star(* 0.05 ** 0.01 *** 0.001)  drop(peaceyear peaceyear2 peaceyear3) ///
order(d_rebstrength d_fightcap logsizepko ) ///
addnote("Reported are the robust standard errors, clustered on peacekeeping operation. Peaceyears, peaceyears2 and peaceyears 3 were also included in the models, but not reported here. ")


eststo clear
eststo: logit dv d_rebstrength duration pkotype d_rebsup logbattle nonun peaceyear peaceyear2 peaceyear3, cluster(cluster)
eststo: logit dv d_fightcap duration pkotype d_rebsup logbattle nonun peaceyear peaceyear2 peaceyear3, cluster(cluster)
eststo: logit dv d_rebstrength duration typexstrength pkotype d_rebsup logbattle nonun peaceyear peaceyear2 peaceyear3, cluster(cluster)
eststo: logit dv d_fightcap duration typexfight pkotype d_rebsup logbattle nonun peaceyear peaceyear2 peaceyear3, cluster(cluster)
esttab using tableB.rtf, replace ///
scalars( N "r2_p Pseudo R2" "Proportionate Reduction in Error" "aic AIC" "Area under ROC curve" ) ///
noeqlines se label nonumbers mtitles("Model 3" "Model 4" "Model 5" "Model 6") ///
title(Table 6: Type of Peacekeeping Operation) modelwidth(0) varwidth(12) ///
onecell star(* 0.05 ** 0.01 *** 0.001)  drop(peaceyear peaceyear2 peaceyear3) ///
order(d_rebstrength d_fightcap pkotype typexstrength typexfight) ///
addnote("Reported are the robust standard errors, clustered on peacekeeping operation. Peaceyears, peaceyears2 and peaceyears 3 were also included in the models, but not reported here. ")




