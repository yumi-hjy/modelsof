**Imbens, G. 2003. "Sensitivity to Exogeneity Assumptions in Program Evaluation", The American Economic Review 93(2):126-132* run immigration_replicationfile.do up to "*** SAVE ***" first and save before running this fileuse immigration_data.dta, clearset more off*rename re78 targrename h1bvisas_scale targsensitiveJM targ groupcat2  dscore2 female age agesq married educ racewhite income2 pid  techzip2 if dscore!=.&race!=4, modei eq1max(10000) eq1min(-10000) eq2max(10) eq2min(-10)  matrix sv_mat = e(res)sensitiveJM targ groupcat2  dscore2 female age agesq married educ racewhite income2 pid  techzip2 if dscore!=.&race!=4, modev r2Winit(.3020542) r2Yinit(.1496924) eq1max(10000) eq1min(-10000) eq2max(10) eq2min(-10)  matrix sv_mat = sv_mat \ e(res)sensitiveJM targ groupcat2  dscore2 female age agesq married educ racewhite income2 pid  techzip2 if dscore!=.&race!=4, modev r2Winit(.3020542) r2Yinit(.1496924) group(groupcat1 dscore2 female age married educ racewhite income2 pid  techzip2) eq1max(10000) eq1min(-10000) eq2max(10) eq2min(-10) matrix sv_mat = sv_mat \ e(res)*** Create Figure      set more offmatrix points = 1.0, -.5855 \1.7271499, -.31900000\2.1572981, -.26907000\2.5881854,-.24059999 \3.042803, -.22209999 \3.5, -.21299999 \4.75, -.19899999local n = rowsof(points)forval j = 1(1)`n' {	local x = points[`j',1]	local y = points[`j',2]	sensitiveJM targ groupcat2  dscore2 female age agesq married educ racewhite income2 pid  techzip2 if dscore!=.&race!=4, modea alpha(`x') delta(`y') r2Winit(.3020542) r2Yinit(.1496924) eq1max(10000) eq1min(-10000) eq2max(10) eq2min(-10) 	matrix sv_mat = sv_mat \ e(res)}matrix list sv_matsvmat sv_mat, names(col)matrix plotvar = J(1,1,0), J(1,1,0), J(1,1,0) \ J(10,1,1),  J(10,1,0),  J(10,1,0) \ J(1,1,0) , J(1,1,1) , J(1,1,0) \J(7,1,0) ,J(7,1,0), J(7,1,1)svmat plotvarscatter r2Y_partial r2W_partial if plotvar2, xscale(range(0 0.6)) msymbol(Oh)|| scatter r2Y_partial r2W_partial if plotvar1 , legend(label(1 "Influence of covariates combined on working in high technology and support for H-1B visas") label (2 "Influence of each covariate on working in high technology and support for H-1B visas") label(3 "Threshold for covariate to reduce the effect size of working in high technology and support for H-1B visas to zero") col(1) size(vsmall) span region(lcolor(white))) graphregion(color(white)) xscale(range(0 0.6)) yscale(range(0 .2)) msymbol(plus) || scatter r2Y_partial r2W_partial if plotvar3  , connect(l) msymbol(none) scheme(s1mono) xtitle("Influence of covariate on working in high technology" "(Increase in R-squared)", size(small) margin(medsmall)) ytitle("Influence of covariate on support" "for H-1B visas (Increase in R-squared)", size(small) margin(medsmall)) note("Notes: The figure presents the results of the sensitivity analysis following Imbens (2003). Each + represents an immigration opposition" "covariate, plotted according to its additional explanatory power for treatment assignment (on the horizontal axis) and its explanatory" "power for the outcome (vertical axis), which in this case is support for H-1B visas. In essence, each axis measures the increase" "(or decrease) in the R-squared statistic from adding that covariate to the regression in question. The downward sloping curve" "represents the locus of points at which any independent covariate (observed or unobserved) would have sufficient association" "with both treatment and outcomes to reduce the effect of working in high technology on opposition to H-1B visa expanstion to zero.", span size(vsmall))