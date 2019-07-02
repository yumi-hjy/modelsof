* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

**STSET SIGNATORY PEACE**
sort unique_id_ year
gen start_of_segment = year
*Model 1 - stset with signatory peace*
stset end_of_segment, origin(time first_year_of_peace) enter(time start_of_segment) failure(endsig2event==1) exit(time .) id(unique_id_)
list id_ unique_id start_of_segment end_of_segment first_year_of_peace _d _t if id_==24
list id_ unique_id start_of_segment end_of_segment first_year_of_peace _d _t if id_==2
**GENERATE & RECODE VARIABLES**
gen signprop =sign/nowpcon
gen sign2 = sign
recode sign2 3/max=0 2=1
generate anypk = 0
recode anypk 0=1 if unpk==1 
recode anypk 0=1 if nonunpk==1
generate WPdummy = nowpcon
recode WPdummy 2=0 3/max=1
generate Twoparty = nowpcon
recode Twoparty 2=1 3/max=0
generate nowpcon2 = nowpcon*nowpcon
generate chad = 0
recode chad 0=1 if id_==8

correlate exmultiple signprop Twoparty nowpcon anypact duration intensity incompatibility nonunpk unpk polity politysquared logungdp
***MAIN MODEL with weibull***
**CLUSTER ON COUNTRY**
stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(country_) robust nolog
**ADDITIONAL CONTROLS**
*polity*
stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk polity politysquared, cluster(id_) robust nolog 
*ungdp*
*signatories*
*no.party-dummy*
stcox inclusive WPdummy anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust nolog 
*no.party-curvelinear*
stcox inclusive nowpcon nowpcon2 anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust nolog 
**PROP.TEST**
capture drop sch* sca*
**BIVARIATE**
stcox inclusive, robust cluster(id)
stcox signprop, robust cluster(id)

****FIRST OUTLIER TEST****
**OUTLIERS MODEL SIGNATORY PEACE**
capture drop mg
stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust mgale(mg) nohr nolog
*store the data in double format*
scatter dev xb if dev>1.5, mlabel(id_)
**models without: 22, 21, 29, 8, 34, 35, 6, 37, 15
stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(id_) nolog
**OUTLIERS MODEL OVERALL PEACE**
capture drop mg
stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust mgale(mg) nohr nolog
*store the data in double format*
**models without: 21, 33, 39, 35, 15, 29
stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(id_) nolog
