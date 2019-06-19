
#delimit;
  
log off; 

sort msic87; egen x=sum(fobSng), by(msic87); egen y=sum(fobNng), by(msic87);
drop if x==0 & y==0; drop x y; 
gen dd=(fobSng/fobSog)/(fobNng/fobNog); 
gen ddlog=log(dd+1); ***making sure that 0 values in dd still have 0 values in ddlog;
gen ddlog2=log(dd);
gen t=year-77; gen t2=t*t; 
encode msic87, gen (ind); ***from 1 to 265; sort ind; 
gen tb=.; gen tse=.; gen t2b=.; gen t2se=.; gen tblog=.; gen tselog=.; gen t2blog=.; 
gen t2selog=.;gen vt=fobSng+fobSog+fobNng+fobNog; by msic87, sort: egen vtbar=mean(vt); egen time=group(t);

gen taoSng=(cifSng-fobSng)/fobSng; gen taoSog=(cifSog-fobSog)/fobSog;
gen taoNng=(cifNng-fobNng)/fobNng; gen taoNog=(cifNog-fobNog)/fobNog;

count if taoSng<0 | taoSog<0 | taoNng<0 | taoNog<0; 
sum tao* if taoSng>=0 & taoSog>=0 & taoNng>=0 & taoNog>=0; 
gen ddtao=(taoSng/taoSog)/(taoNng/taoNog);
replace ddtao=. if taoSng<0 | taoSog<0 | taoNng<0 | taoNog<0;
gen ddlogtao=log(ddtao+1); gen ddlogtao2=log(ddtao);

*************************************************manually run weighted LS, Stata aweight option***************;

gen ddlog2W=ddlog2*sqrt(vtbar); gen tW=t*sqrt(vtbar); gen t2W=t2*sqrt(vtbar); gen ddlogtao2W=ddlogtao2*sqrt(vtbar); 
gen constantW=sqrt(vtbar); 

******************1. replicate results in the paper******************;
*areg ddlog2 t t2 ddlogtao2 [aweight=vtbar], absorb(ind) cluster(time);

**********************2. manual weighted regressions duplicate the results above************************;
*areg ddlog2W tW t2W ddlogtao2W, absorb(ind) cluster(time);
*reg ddlog2W constantW tW t2W ddlogtao2W i.ind, nocons cluster(time);


***note 1. cannot run this, because bootstrap option is not allowed with aweight option; 
*areg ddlog2 t t2 ddlogtao2 [aweight=vtbar], absorb(ind) cluster(time) vce(bootstrap, rep(200));
***note 2. can run this, but produces error message:

. areg ddlog2 t t2 ddlogtao2, absorb(ind) cluster(time) vce(bootstrap, rep(200))
(running areg on estimation sample)

Bootstrap replications (200)
----+--- 1 ---+--- 2 ---+--- 3 ---+--- 4 ---+--- 5 
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    50
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   100
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   150
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   200
insufficient observations to compute bootstrap standard errors
no results will be saved
r(2000);

