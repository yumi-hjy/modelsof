* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
generate chad=0

**BIVARIATE MODEL 1**
stcox notsigned, robust cluster(dyadid)

*with anypact*
capture drop sch* sca*
capture drop sch* sca*
stcox notsigned chad nowpcon dyadduration intensity_dyad incomp unpk nonunpk, cluster(dyadid) strata(strata) nolog
capture drop mg
predict double xb, xb
**models without: 17, 60, 80, 86, 110 - 22, 119,50, 38, 53
stcox notsigned nowpcon dyadduration intensity_dyad incomp unpk nonunpk, cluster(dyadid) strata(strata) nolog

stcox expa, robust cluster(dyadid)
stcox expa chad nowpcon dyadduration intensity_dyad incomp unpk nonunpk, cluster(dyadid) strata(strata) nolog
**OUTLIERS MODEL 2**
stcox expa nowpcon dyadduration intensity_dyad incomp unpk nonunpk, cluster(dyadid) strata(strata) nolog
**OUTLIERS MODEL 3**
capture drop mg
*store the data in double format*
stcox exfight1 nowpcon dyadduration intensity_dyad incomp unpk nonunpk, cluster(dyadid) strata(strata) nolog
********************************