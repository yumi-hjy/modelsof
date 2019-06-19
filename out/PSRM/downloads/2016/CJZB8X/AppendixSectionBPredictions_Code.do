*User must install "_gclsort.ado" to run the following code.
*Note that the user must enter correct paths where ellipses appear in the code below, and then remove the comment command ("*") at the start of the relevant line.

*******************

*use "/.../AppendixSectionB_Data.dta"

drop if days<=0

gen absnom=abs(dwnom1)
gen minabsnom=minority*absnom
gen mindwmeddist=minority*dwmeddist

xi: logit sign VoteSharePrevAdopt days days2 days3 PrevAdopters i.PetitionID if days>0 & cong!=., robust cluster(idno)

tabstat VoteSharePrevAdopt days days2 days3 PrevAdopters _IPetitionI_2-_IPetitionI_99 if days>0 & cong!=., stat(mean) save

matrix means=r(StatTotal)

scalar VoteShare=`i'
scalar days=48.75348
scalar days2=days^2
scalar days3=days^3
scalar constant=1
local counter=round(`i'*100)
generate xbetahat`counter'= M1_b1*VoteShare + M1_b2*means[1,2] + M1_b3*means[1,3] + M1_b4*means[1,4] + M1_b5*means[1,5] + M1_b6*0 + M1_b7*0 + M1_b8*0 + M1_b9*0 + M1_b10*0 + M1_b11*0 + M1_b12*0 + M1_b13*0 + M1_b14*0 + M1_b15*0 +M1_b16*0 + M1_b17*0 + M1_b18*0 + M1_b19*0 + M1_b20*0 + M1_b21*0 + M1_b22*0 + M1_b23*0 + M1_b24*0 + M1_b25*0 + M1_b26*1 + M1_b27*0 + M1_b28*0 + M1_b29*0 + M1_b30*0 + M1_b31*0 + M1_b32*0 + M1_b33*0 + M1_b34*0 + M1_b35*0 + M1_b36*0 + M1_b37*0 + M1_b38*0 + M1_b39*0 + M1_b40*0 + M1_b41*0 + M1_b42*0 + M1_b43*0 + M1_b44*0 + M1_b45*0 + M1_b46*0 + M1_b47*0 + M1_b48*0 + M1_b49*0 + M1_b50*0 + M1_b51*0 + M1_b52*0 + M1_b53*0 + M1_b54*0 + M1_b55*0 + M1_b56*0 + M1_b57*0 + M1_b58*0 + M1_b59*0 + M1_b60*0 + M1_b61*0 + M1_b62*0 + M1_b63*0 + M1_b64*0 + M1_b65*0 + M1_b66*0 + M1_b67*0 + M1_b68*0 + M1_b69*0 + M1_b70*0 + M1_b71*0 + M1_b72*0 + M1_b73*0 + M1_b74*0 + M1_b75*0 + M1_b76*0 + M1_b77*0 + M1_b78*0 + M1_b79*0 + M1_b80*0 + M1_b81*0 + M1_b82*0 + M1_b83*0 + M1_b84*0 + M1_b85*0 + M1_b86*0 + M1_b87*0 + M1_b88*0 + M1_b89*0 + M1_b90*0 + M1_b91*0 + M1_b92*0 + M1_b93*0 + M1_b94*0 + M1_b95*0 + M1_b96*0 + M1_b97*0 + M1_b98*0 + M1_b99*0 + M1_b100*0 + M1_b101*0 + M1_b102*0 + M1_b103*0 + M1_b104*constant

sort count
*use "/.../Model1Predictions_Values.dta"
drop M1_b1-pred85
collapse (mean) pred50a-pred85a
xpose, clear
rename v1 means
gen count=.5+(_n-1)/100
sort count
*save "/.../Model1Predictions_Means.dta"
*use "/.../Model1Predictions_CI.dta"
*merge count using "/.../Model1Predictions_Means.dta"
tab _merge
drop _merge
*save "/.../AppendixSectionBPredictionsModel1_Data.dta"

twoway (scatter LowBoundModel1 count) (scatter UpBoundModel1 count)


*******************

*******************

*use "/.../AppendixSectionB_Data.dta"

drop if days<=0

gen absnom=abs(dwnom1)
gen minabsnom=minority*absnom
gen mindwmeddist=minority*dwmeddist

xi: logit sign VoteSharePrevAdopt days days2 days3 PrevAdopters minority dweucldis dwmeddist mindwmeddist absnom minabsnom VoteShare ch_senior prestige_com CommLeader TargetCommMem IndCosponsors i.PetitionID if days>0 & cong!=., robust cluster(idno)

tabstat VoteSharePrevAdopt days days2 days3 PrevAdopters minority dweucldis dwmeddist mindwmeddist absnom minabsnom VoteShare ch_senior prestige_com CommLeader TargetCommMem IndCosponsors _IPetitionI_2-_IPetitionI_99 if days>0 & cong!=., stat(mean) save

matrix means=r(StatTotal)

scalar VoteShare=`i'
scalar days=48.75348
scalar days2=days^2
scalar days3=days^3
scalar constant=1
local counter=round(`i'*100)
generate xbetahat`counter'= M1_b1*VoteShare + M1_b2*means[1,2] + M1_b3*means[1,3] + M1_b4*means[1,4] + M1_b5*means[1,5] + M1_b6*means[1,6] + M1_b7*means[1,7] + M1_b8*means[1,8] + M1_b9*means[1,9] + M1_b10*means[1,10] + M1_b11*means[1,11] + M1_b12*means[1,12] + M1_b13*means[1,13] + M1_b14*means[1,14] + M1_b15*means[1,15] +M1_b16*means[1,16] + M1_b17*means[1,17] + M1_b18*0 + M1_b19*0 + M1_b20*0 + M1_b21*0 + M1_b22*0 + M1_b23*0 + M1_b24*0 + M1_b25*0 + M1_b26*0 + M1_b27*0 + M1_b28*0 + M1_b29*0 + M1_b30*0 + M1_b31*0 + M1_b32*0 + M1_b33*0 + M1_b34*0 + M1_b35*0 + M1_b36*0 + M1_b37*0 + M1_b38*1 + M1_b39*0 + M1_b40*0 + M1_b41*0 + M1_b42*0 + M1_b43*0 + M1_b44*0 + M1_b45*0 + M1_b46*0 + M1_b47*0 + M1_b48*0 + M1_b49*0 + M1_b50*0 + M1_b51*0 + M1_b52*0 + M1_b53*0 + M1_b54*0 + M1_b55*0 + M1_b56*0 + M1_b57*0 + M1_b58*0 + M1_b59*0 + M1_b60*0 + M1_b61*0 + M1_b62*0 + M1_b63*0 + M1_b64*0 + M1_b65*0 + M1_b66*0 + M1_b67*0 + M1_b68*0 + M1_b69*0 + M1_b70*0 + M1_b71*0 + M1_b72*0 + M1_b73*0 + M1_b74*0 + M1_b75*0 + M1_b76*0 + M1_b77*0 + M1_b78*0 + M1_b79*0 + M1_b80*0 + M1_b81*0 + M1_b82*0 + M1_b83*0 + M1_b84*0 + M1_b85*0 + M1_b86*0 + M1_b87*0 + M1_b88*0 + M1_b89*0 + M1_b90*0 + M1_b91*0 + M1_b92*0 + M1_b93*0 + M1_b94*0 + M1_b95*0 + M1_b96*0 + M1_b97*0 + M1_b98*0 + M1_b99*0 + M1_b100*0 + M1_b101*0 + M1_b102*0 + M1_b103*0 + M1_b104*0 + M1_b105*0 + M1_b106*0 + M1_b107*0 + M1_b108*0 + M1_b109*0 + M1_b110*0 + M1_b111*0 + M1_b112*0 + M1_b113*0 + M1_b114*0 + M1_b115*0 + M1_b116*constant

sort count

*use "/.../Model2Predictions_Values.dta"
drop M1_b1-pred85
collapse (mean) pred50a-pred85a
xpose, clear
rename v1 means
gen count=.5+(_n-1)/100
sort count
*save "/.../Model2Predictions_Means.dta"
*use "/.../Model2Predictions_CI.dta"
*merge count using "/.../Model2Predictions_Means.dta"
tab _merge
drop _merge
*save "/.../AppendixSectionBPredictionsModel2_Data.dta"



*******************

*******************

*use "/.../AppendixSectionB_Data.dta"

drop if days<=0

gen absnom=abs(dwnom1)
gen minabsnom=minority*absnom
gen mindwmeddist=minority*dwmeddist

xi: logit sign VoteSharePrevAdopt VoteSharePANetwork days days2 days3 PrevAdopters PrevAdoptersNetwork minority dweucldis dwmeddist mindwmeddist absnom minabsnom VoteShare ch_senior prestige_com CommLeader TargetCommMem IndCosponsors i.PetitionID if days>0 & cong!=., robust cluster(idno)

tabstat VoteSharePrevAdopt VoteSharePANetwork days days2 days3 PrevAdopters PrevAdoptersNetwork minority dweucldis dwmeddist mindwmeddist absnom minabsnom VoteShare ch_senior prestige_com CommLeader TargetCommMem IndCosponsors _IPetitionI_2-_IPetitionI_99 if days>0 & cong!=., stat(mean) save

matrix means=r(StatTotal)


*Using 1% and 99% for VoteSharePANetwork
scalar VoteShare=`i'
scalar VoteSharePANetwork=.5812
scalar days=48.75348
scalar days2=days^2
scalar days3=days^3
scalar constant=1
local counter=round(`i'*100)
generate xbetahat`counter'= M1_b1*VoteShare + M1_b2*VoteSharePANetwork + M1_b3*means[1,3] + M1_b4*means[1,4] + M1_b5*means[1,5] + M1_b6*means[1,6] + M1_b7*means[1,7] + M1_b8*means[1,8] + M1_b9*means[1,9] + M1_b10*means[1,10] + M1_b11*means[1,11] + M1_b12*means[1,12] + M1_b13*means[1,13] + M1_b14*means[1,14] + M1_b15*means[1,15] +M1_b16*means[1,16] + M1_b17*means[1,17] + M1_b18*means[1,18] + M1_b19*means[1,19] + M1_b20*0 + M1_b21*0 + M1_b22*0 + M1_b23*0 + M1_b24*0 + M1_b25*0 + M1_b26*0 + M1_b27*0 + M1_b28*0 + M1_b29*0 + M1_b30*0 + M1_b31*0 + M1_b32*0 + M1_b33*0 + M1_b34*0 + M1_b35*0 + M1_b36*0 + M1_b37*0 + M1_b38*0 + M1_b39*0 + M1_b40*1 + M1_b41*0 + M1_b42*0 + M1_b43*0 + M1_b44*0 + M1_b45*0 + M1_b46*0 + M1_b47*0 + M1_b48*0 + M1_b49*0 + M1_b50*0 + M1_b51*0 + M1_b52*0 + M1_b53*0 + M1_b54*0 + M1_b55*0 + M1_b56*0 + M1_b57*0 + M1_b58*0 + M1_b59*0 + M1_b60*0 + M1_b61*0 + M1_b62*0 + M1_b63*0 + M1_b64*0 + M1_b65*0 + M1_b66*0 + M1_b67*0 + M1_b68*0 + M1_b69*0 + M1_b70*0 + M1_b71*0 + M1_b72*0 + M1_b73*0 + M1_b74*0 + M1_b75*0 + M1_b76*0 + M1_b77*0 + M1_b78*0 + M1_b79*0 + M1_b80*0 + M1_b81*0 + M1_b82*0 + M1_b83*0 + M1_b84*0 + M1_b85*0 + M1_b86*0 + M1_b87*0 + M1_b88*0 + M1_b89*0 + M1_b90*0 + M1_b91*0 + M1_b92*0 + M1_b93*0 + M1_b94*0 + M1_b95*0 + M1_b96*0 + M1_b97*0 + M1_b98*0 + M1_b99*0 + M1_b100*0 + M1_b101*0 + M1_b102*0 + M1_b103*0 + M1_b104*0 + M1_b105*0 + M1_b106*0 + M1_b107*0 + M1_b108*0 + M1_b109*0 + M1_b110*0 + M1_b111*0 + M1_b112*0 + M1_b113*0 + M1_b114*0 + M1_b115*0 + M1_b116*0 + M1_b117*0 + M1_b118*constant

sort count

*use "/.../Model3Predictions_ValuesLowNet.dta"
drop M1_b1-pred85
collapse (mean) pred50a-pred85a
xpose, clear
rename v1 means
gen count=.5+(_n-1)/100
sort count
*save "/.../Model3Predictions_MeansLowNet.dta"
*use "/.../Model3Predictions_CILowNet.dta"
*merge count using "/.../Model3Predictions_MeansLowNet.dta"
tab _merge
drop _merge
*save "/.../AppendixSectionBPredictionsModel3Low_Data.dta"


*******************

*******************

*use "/.../AppendixSectionB_Data.dta"

drop if days<=0

gen absnom=abs(dwnom1)
gen minabsnom=minority*absnom
gen mindwmeddist=minority*dwmeddist

xi: logit sign VoteSharePrevAdopt VoteSharePANetwork days days2 days3 PrevAdopters PrevAdoptersNetwork minority dweucldis dwmeddist mindwmeddist absnom minabsnom VoteShare ch_senior prestige_com CommLeader TargetCommMem IndCosponsors i.PetitionID if days>0 & cong!=., robust cluster(idno)

tabstat VoteSharePrevAdopt VoteSharePANetwork days days2 days3 PrevAdopters PrevAdoptersNetwork minority dweucldis dwmeddist mindwmeddist absnom minabsnom VoteShare ch_senior prestige_com CommLeader TargetCommMem IndCosponsors _IPetitionI_2-_IPetitionI_99 if days>0 & cong!=., stat(mean) save

matrix means=r(StatTotal)


*Using 1% and 99% for VoteSharePANetwork
scalar VoteShare=`i'
scalar VoteSharePANetwork=.7848967
scalar days=48.75348
scalar days2=days^2
scalar days3=days^3
scalar constant=1
local counter=round(`i'*100)
generate xbetahat`counter'= M1_b1*VoteShare + M1_b2*VoteSharePANetwork + M1_b3*means[1,3] + M1_b4*means[1,4] + M1_b5*means[1,5] + M1_b6*means[1,6] + M1_b7*means[1,7] + M1_b8*means[1,8] + M1_b9*means[1,9] + M1_b10*means[1,10] + M1_b11*means[1,11] + M1_b12*means[1,12] + M1_b13*means[1,13] + M1_b14*means[1,14] + M1_b15*means[1,15] +M1_b16*means[1,16] + M1_b17*means[1,17] + M1_b18*means[1,18] + M1_b19*means[1,19] + M1_b20*0 + M1_b21*0 + M1_b22*0 + M1_b23*0 + M1_b24*0 + M1_b25*0 + M1_b26*0 + M1_b27*0 + M1_b28*0 + M1_b29*0 + M1_b30*0 + M1_b31*0 + M1_b32*0 + M1_b33*0 + M1_b34*0 + M1_b35*0 + M1_b36*0 + M1_b37*0 + M1_b38*0 + M1_b39*0 + M1_b40*1 + M1_b41*0 + M1_b42*0 + M1_b43*0 + M1_b44*0 + M1_b45*0 + M1_b46*0 + M1_b47*0 + M1_b48*0 + M1_b49*0 + M1_b50*0 + M1_b51*0 + M1_b52*0 + M1_b53*0 + M1_b54*0 + M1_b55*0 + M1_b56*0 + M1_b57*0 + M1_b58*0 + M1_b59*0 + M1_b60*0 + M1_b61*0 + M1_b62*0 + M1_b63*0 + M1_b64*0 + M1_b65*0 + M1_b66*0 + M1_b67*0 + M1_b68*0 + M1_b69*0 + M1_b70*0 + M1_b71*0 + M1_b72*0 + M1_b73*0 + M1_b74*0 + M1_b75*0 + M1_b76*0 + M1_b77*0 + M1_b78*0 + M1_b79*0 + M1_b80*0 + M1_b81*0 + M1_b82*0 + M1_b83*0 + M1_b84*0 + M1_b85*0 + M1_b86*0 + M1_b87*0 + M1_b88*0 + M1_b89*0 + M1_b90*0 + M1_b91*0 + M1_b92*0 + M1_b93*0 + M1_b94*0 + M1_b95*0 + M1_b96*0 + M1_b97*0 + M1_b98*0 + M1_b99*0 + M1_b100*0 + M1_b101*0 + M1_b102*0 + M1_b103*0 + M1_b104*0 + M1_b105*0 + M1_b106*0 + M1_b107*0 + M1_b108*0 + M1_b109*0 + M1_b110*0 + M1_b111*0 + M1_b112*0 + M1_b113*0 + M1_b114*0 + M1_b115*0 + M1_b116*0 + M1_b117*0 + M1_b118*constant

sort count

*use "/.../Model3Predictions_ValuesHighNet.dta"
drop M1_b1-pred85
collapse (mean) pred50a-pred85a
xpose, clear
rename v1 means
gen count=.5+(_n-1)/100
sort count
*save "/.../Model3Predictions_MeansHighNet.dta"
*use "/.../Model3Predictions_CIHighNet.dta"
*merge count using "/.../Model3Predictions_MeansHighNet.dta"
tab _merge
drop _merge
*save "/.../AppendixSectionBPredictionsModel3High_Data.dta"

