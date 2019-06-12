***Hollibaugh, Horton, and Lewis - "Presidents and Patronage" ***Stata Replication File for all Obama analyses***Note that all plots were made in R using ggplot***Models estimated in Stata 10.1 (cmp version 5.4.5)***Set working directory to the directory where the "AJPS Data.csv" file is.***To run entire file and to replicate analyses in Supplementary Appendix 1, ensure "AJPS Data Complete Observations.csv" is in the current working directoryclearinsheet using "AJPS Data.csv"***Need to run this command before running cmpcmp setup***Table 2 **(coefficients, standard errors, and other statistics will not always be exactly those in the paper; the simulated maximum likelihood relies on random draws)**However, the substantive inferences will be the same.**Also note the warning: "Each observation gets different draws, so changing the order of observations in the data set would change the results."**This will take a few minutes.  Be patient.cmp (avgagency = sotupriority clintonlewisideo lnprobias lnworkforce)(avgphd = sotupriority clintonlewisideo lnprobias lnworkforce)(avggovt = sotupriority clintonlewisideo lnprobias lnworkforce)(avgbushorclinton = sotupriority clintonlewisideo lnprobias lnworkforce)(avgsubjectall =sotupriority clintonlewisideo lnprobias lnworkforce)(avgpolitics = sotupriority clintonlewisideo lnprobias lnworkforce)(avgcampaignwork = sotupriority clintonlewisideo lnprobias lnworkforce)[aweight = number], ind("cond(avgagency, $cmp_cont, $cmp_left, $cmp_right)" "cond(avgphd, $cmp_cont, $cmp_left, $cmp_right)" "cond(avggovt, $cmp_cont, $cmp_left, $cmp_right)" "cond(avgbushorclinton, $cmp_cont, $cmp_left)" "cond(avgsubjectall, $cmp_cont, $cmp_left, $cmp_right)" "cond(avgpolitics, $cmp_cont, $cmp_left, $cmp_right)" "cond(avgcampaignwork, $cmp_cont, $cmp_left)") ghkdraws(14, type(random) scramble)***Principal Components **Predicted values are already in the data, but can be reestimated here.**They will be slightly different if reestimated here, but substantive inferences will be identical*pca avgagency avgphd avggovt avgbushorclinton avgsubjectall [aweight=number]*predict latentexpert*pca avgpolitics avgcampaignwork [aweight=number]*predict latentpatron*pca avgagency avgphd avggovt avgbushorclinton avgsubjectall avgpolitics avgcampaignwork [aweight=number]*predict expertpatron***Table 3sureg (latentexpert sotupriority clintonlewisideo lnprobias lnworkforce)(latentpatron sotupriority clintonlewisideo lnprobias lnworkforce) [aweight = number], small corrregress expertpatron sotupriority clintonlewisideo lnprobias lnworkforce [aweight = number]***Supplementary Appendix A3, Table 1tobit avgagency sotupriority clintonlewisideo lnprobias lnworkforce [aweight=number], ll(0) ul(1)tobit avgphd sotupriority clintonlewisideo lnprobias lnworkforce [aweight=number], ll(0) ul(1)tobit avggovt sotupriority clintonlewisideo lnprobias lnworkforce [aweight=number], ll(0) ul(1)tobit avgbushorclinton sotupriority clintonlewisideo lnprobias lnworkforce [aweight=number], ll(0) ul(1)tobit avgsubjectall sotupriority clintonlewisideo lnprobias lnworkforce [aweight=number], ll(0) ul(1)tobit avgpolitics sotupriority clintonlewisideo lnprobias lnworkforce [aweight=number], ll(0) ul(1)tobit avgcampaignwork sotupriority clintonlewisideo lnprobias lnworkforce [aweight=number], ll(0) ul(1)***Supplementary Appendix A3, Table 2regress avgagency sotupriority clintonlewisideo lnprobias lnworkforce [aweight=number]regress avgphd sotupriority clintonlewisideo lnprobias lnworkforce [aweight=number]regress avggovt sotupriority clintonlewisideo lnprobias lnworkforce [aweight=number]regress avgbushorclinton sotupriority clintonlewisideo lnprobias lnworkforce [aweight=number]regress avgsubjectall sotupriority clintonlewisideo lnprobias lnworkforce [aweight=number]regress avgpolitics sotupriority clintonlewisideo lnprobias lnworkforce [aweight=number]regress avgcampaignwork sotupriority clintonlewisideo lnprobias lnworkforce [aweight=number]***Supplementary Appendix A3, Table 3gen priorityideo = sotupriority*clintonlewisideo**This model is fragile and may take several attempts to converge properly.  **(like before, the coefficients, standard errors, and other statistics will not always be exactly those in the paper; the simulated maximum likelihood relies on random draws)**However, the substantive inferences will be the same.**Also note the warning: "Each observation gets different draws, so changing the order of observations in the data set would change the results."**This will take a few minutes.  Be patient.cmp (avgagency = sotupriority clintonlewisideo lnprobias lnworkforce priorityideo)(avgphd = sotupriority clintonlewisideo lnprobias lnworkforce priorityideo)(avggovt = sotupriority clintonlewisideo lnprobias lnworkforce priorityideo)(avgbushorclinton = sotupriority clintonlewisideo lnprobias lnworkforce priorityideo)(avgsubjectall =sotupriority clintonlewisideo lnprobias lnworkforce priorityideo)(avgpolitics = sotupriority clintonlewisideo lnprobias lnworkforce priorityideo)(avgcampaignwork = sotupriority clintonlewisideo lnprobias lnworkforce priorityideo)[aweight = number], ind("cond(avgagency, $cmp_cont, $cmp_left, $cmp_right)" "cond(avgphd, $cmp_cont, $cmp_left, $cmp_right)" "cond(avggovt, $cmp_cont, $cmp_left, $cmp_right)" "cond(avgbushorclinton, $cmp_cont, $cmp_left)" "cond(avgsubjectall, $cmp_cont, $cmp_left, $cmp_right)" "cond(avgpolitics, $cmp_cont, $cmp_left, $cmp_right)" "cond(avgcampaignwork, $cmp_cont, $cmp_left)") ghkdraws(14, type(random) scramble)***Now we provide the results in the appendix using the agency estimates based only on complete observationsclear***Make sure "AJPS Data Complete Observations.csv" is in the current working directoryinsheet using "AJPS Data Complete Observations.csv"***Supplementary Appendix A1, Table 1 **(coefficients, standard errors, and other statistics will not always be exactly those in the paper; the simulated maximum likelihood relies on random draws)**However, the substantive inferences will be the same.**Also note the warning: "Each observation gets different draws, so changing the order of observations in the data set would change the results."**This will take a few minutes.  Be patient.cmp (avgagency = sotupriority clintonlewisideo lnprobias lnworkforce)(avgphd = sotupriority clintonlewisideo lnprobias lnworkforce)(avggovt = sotupriority clintonlewisideo lnprobias lnworkforce)(avgbushorclinton = sotupriority clintonlewisideo lnprobias lnworkforce)(avgsubjectall =sotupriority clintonlewisideo lnprobias lnworkforce)(avgpolitics = sotupriority clintonlewisideo lnprobias lnworkforce)(avgcampaignwork = sotupriority clintonlewisideo lnprobias lnworkforce)[aweight = number], ind("cond(avgagency, $cmp_cont, $cmp_left, $cmp_right)" "cond(avgphd, $cmp_cont, $cmp_left, $cmp_right)" "cond(avggovt, $cmp_cont, $cmp_left, $cmp_right)" "cond(avgbushorclinton, $cmp_cont, $cmp_left)" "cond(avgsubjectall, $cmp_cont, $cmp_left, $cmp_right)" "cond(avgpolitics, $cmp_cont, $cmp_left, $cmp_right)" "cond(avgcampaignwork, $cmp_cont, $cmp_left)") ghkdraws(14, type(random) scramble)***Principal Components **Predicted values are already in the data, but can be reestimated here.**They will be slightly different if reestimated here, but substantive inferences will be identical*pca avgagency avgphd avggovt avgbushorclinton avgsubjectall [aweight=number]*predict latentexpert*pca avgpolitics avgcampaignwork [aweight=number]*predict latentpatron*pca avgagency avgphd avggovt avgbushorclinton avgsubjectall avgpolitics avgcampaignwork [aweight=number]*predict expertpatron***Supplementary Appendix A1, Table 2sureg (latentexpert sotupriority clintonlewisideo lnprobias lnworkforce)(latentpatron sotupriority clintonlewisideo lnprobias lnworkforce) [aweight = number], small corrregress expertpatron sotupriority clintonlewisideo lnprobias lnworkforce [aweight = number]