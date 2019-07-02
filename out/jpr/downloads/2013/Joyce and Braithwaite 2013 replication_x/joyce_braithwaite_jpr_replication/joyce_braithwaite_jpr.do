**********************************************************************************************
**				Proximity and Third Party Joiners in Militarized Interstate Disputes"
**				The results are shown in Tables I and II
**				joyce_braithwaite_predicted_probabilities_lsg_jpr.csv
**				joyce_braithwaite_predicted_probabilities_conditional_jpr.csv	
clear

*Set the working directory;
*cd "...";

use "joyce_braithwaite_jpr.dta";
log using "joyce_braithwaite_jpr.log", replace;

**********************************************************************************************;
*Table I, Model 1: No LSG Adjustment;
**********************************************************************************************;
logit joined cinc_nolsg_itj contig_itj alliance_itj democ_itj autoc_itj, robust cluster(id);

*Multiply CINC score by 1000 for loop;
gen double cinc_nolsg_itj_1000=cinc_nolsg_itj*1000;
gen double cinc_axis=_n-1 in 1/1001;

estsimp logit joined cinc_nolsg_itj_1000 contig_itj alliance_itj democ_itj autoc_itj, robust cluster(id) sims(1001);
*Not Contiguous, Not Allied;

*Set contiguity equal to 0, alliance equal to 0, democracy equal to 0, autocracy equal to 0;
*Vary capability from its minimum to its maximum; 


setx cinc_nolsg_itj_1000 min contig_itj 0 alliance_itj 0 democ_itj 0 autoc_itj 0;

local a=0;

di `a';

egen mean_pi=mean(pi);



*Contiguous, Not Allied;

*Set contiguity equal to 1, alliance equal to 0, democracy equal to 0, autocracy equal to 0;
*Vary capability from its minimum to its maximum; 


setx cinc_nolsg_itj_1000 min contig_itj 1 alliance_itj 0 democ_itj 0 autoc_itj 0;

local a=0;

di `a';


egen mean_pi=mean(pi);


*Not Contiguous, Allied;

*Set contiguity equal to 0, alliance equal to 1, democracy equal to 0, autocracy equal to 0;
*Vary capability from its minimum to its maximum; 


setx cinc_nolsg_itj_1000 min contig_itj 0 alliance_itj 1 democ_itj 0 autoc_itj 0;

local a=0;

di `a';


egen mean_pi=mean(pi);


*Contiguous, Allied;

*Set contiguity equal to 1, alliance equal to 1, democracy equal to 0, autocracy equal to 0;
*Vary capability from its minimum to its maximum; 


setx cinc_nolsg_itj_1000 min contig_itj 1 alliance_itj 1 democ_itj 0 autoc_itj 0;

local a=0;

di `a';


egen mean_pi=mean(pi);


drop b1 b2 b3 b4 b5 b6;

*Table I, Model 2: LSG Adjustment Based on Distance to Initial Belligerents;
**********************************************************************************************;
logit joined cinc_km_combined_itj contig_itj alliance_itj democ_itj autoc_itj, robust cluster(id);

*Multiply CINC score by 1000 for loop;
gen double cinc_km_combined_itj_1000=cinc_km_combined_itj*1000;

estsimp logit joined cinc_km_combined_itj_1000 contig_itj alliance_itj democ_itj autoc_itj, robust cluster(id) sims(1001);


*Set contiguity equal to 0, alliance equal to 0, democracy equal to 0, autocracy equal to 0;
*Vary capability from its minimum to its maximum; 


setx cinc_km_combined_itj_1000 min contig_itj 0 alliance_itj 0 democ_itj 0 autoc_itj 0;

local a=0;

di `a';


egen mean_pi=mean(pi);


*Contiguous, Not Allied;

*Set contiguity equal to 1, alliance equal to 0, democracy equal to 0, autocracy equal to 0;
*Vary capability from its minimum to its maximum; 


setx cinc_km_combined_itj_1000 min contig_itj 1 alliance_itj 0 democ_itj 0 autoc_itj 0;

local a=0;

di `a';

egen mean_pi=mean(pi);


*Not Contiguous, Allied;

*Set contiguity equal to 0, alliance equal to 1, democracy equal to 0, autocracy equal to 0;
*Vary capability from its minimum to its maximum; 


setx cinc_km_combined_itj_1000 min contig_itj 0 alliance_itj 1 democ_itj 0 autoc_itj 0;

local a=0;

di `a';


egen mean_pi=mean(pi);


*Contiguous, Allied;

*Set contiguity equal to 1, alliance equal to 1, democracy equal to 0, autocracy equal to 0;
*Vary capability from its minimum to its maximum; 


setx cinc_km_combined_itj_1000 min contig_itj 1 alliance_itj 1 democ_itj 0 autoc_itj 0;

local a=0;

di `a';

egen mean_pi=mean(pi);


drop b1 b2 b3 b4 b5 b6;

**********************************************************************************************;
*Table I, Model 3: LSG Adjustment Based on Distance to MID Location (WGS84); 
**********************************************************************************************;
logit joined cinc_km_wgs84_itj contig_itj alliance_itj democ_itj autoc_itj, robust cluster(id);

*Multiply CINC score by 1000 for loop;
gen double cinc_km_wgs84_itj_1000=cinc_km_wgs84_itj*1000;

estsimp logit joined cinc_km_wgs84_itj_1000 contig_itj alliance_itj democ_itj autoc_itj, robust cluster(id) sims(1001);


*Set contiguity equal to 0, alliance equal to 0, democracy equal to 0, autocracy equal to 0;
*Vary capability from its minimum to its maximum; 


setx cinc_km_wgs84_itj_1000 min contig_itj 0 alliance_itj 0 democ_itj 0 autoc_itj 0;

local a=0;

di `a';

egen mean_pi=mean(pi);


*Contiguous, Not Allied;

*Set contiguity equal to 1, alliance equal to 0, democracy equal to 0, autocracy equal to 0;
*Vary capability from its minimum to its maximum; 


setx cinc_km_wgs84_itj_1000 min contig_itj 1 alliance_itj 0 democ_itj 0 autoc_itj 0;

local a=0;

di `a';

egen mean_pi=mean(pi);


*Not Contiguous, Allied;

*Set contiguity equal to 0, alliance equal to 1, democracy equal to 0, autocracy equal to 0;
*Vary capability from its minimum to its maximum; 


setx cinc_km_wgs84_itj_1000 min contig_itj 0 alliance_itj 1 democ_itj 0 autoc_itj 0;

local a=0;

di `a';

egen mean_pi=mean(pi);


*Contiguous, Allied;

*Set contiguity equal to 1, alliance equal to 1, democracy equal to 0, autocracy equal to 0;
*Vary capability from its minimum to its maximum; 


setx cinc_km_wgs84_itj_1000 min contig_itj 1 alliance_itj 1 democ_itj 0 autoc_itj 0;

local a=0;

di `a';

egen mean_pi=mean(pi);


drop b1 b2 b3 b4 b5 b6;

*Save a file containing the predicted probabilities and confidence intervals to plot in R;
outsheet cinc_axis plo_00_nolsg phi_00_nolsg p_00_nolsg plo_10_nolsg phi_10_nolsg p_10_nolsg plo_01_nolsg phi_01_nolsg p_01_nolsg plo_11_nolsg phi_11_nolsg p_11_nolsg plo_00_combined phi_00_combined p_00_combined plo_10_combined phi_10_combined p_10_combined plo_01_combined phi_01_combined p_01_combined plo_11_combined phi_11_combined p_11_combined plo_00_wgs84 phi_00_wgs84 p_00_wgs84 plo_10_wgs84 phi_10_wgs84 p_10_wgs84 plo_01_wgs84 phi_01_wgs84 p_01_wgs84 plo_11_wgs84 phi_11_wgs84 p_11_wgs84 if cinc_axis!=. using "joyce_braithwaite_predicted_probabilities_lsg_jpr.csv", comma replace;

**********************************************************************************************;
*Table II, Model 1: LSG Adjustment Based on Distance to MID Location, No Distance, No Interactions; 
**********************************************************************************************;
logit joined cinc_km_wgs84_itj contig_itj alliance_itj democ_itj autoc_itj, robust cluster(id);

**********************************************************************************************;
*Table II, Model 2: LSG Adjustment Based on Distance to MID Location, Distance, No Interactions; 
**********************************************************************************************;
logit joined cinc_km_wgs84_itj contig_itj alliance_itj distance_wgs84 democ_itj autoc_itj, robust cluster(id);

**********************************************************************************************;
*Table II, Model 3: LSG Adjustment Based on Distance to MID Location, Distance, Interactions; 
**********************************************************************************************;
logit joined cinc_km_wgs84_itj contig_itj contig_itj_dist_wgs84 alliance_itj alliance_itj_dist_wgs84 
	distance_wgs84 democ_itj autoc_itj, robust cluster(id);

gen dist_axis=_n-1 in 1/19991;

*Not Contiguous, Not Allied

*Set capability equal to its mean, contiguity and its interaction equal to 0, alliance and its interaction equal to 0, 
*democracy equal to 0, autocracy equal to 0;
*Vary distance to MID location from its min to its max;


estsimp logit joined cinc_km_wgs84_itj contig_itj contig_itj_dist_wgs84 alliance_itj alliance_itj_dist_wgs84 
	distance_wgs84 democ_itj autoc_itj, robust cluster(id) sims(19990);
setx cinc_km_wgs84_itj mean contig_itj 0 contig_itj_dist_wgs84 0 alliance_itj 0 alliance_itj_dist_wgs84 0 
	distance_wgs84 min democ_itj 0 autoc_itj 0;

egen mean_pi=mean(pi);


*Contiguous, Not Allied

*Set capability equal to its mean, alliance and its interaction equal to 0, democracy equal to 0, autocracy equal to 0;
*Set contiguity equal to 1, vary distance to MID location from its min to its max, and thus, vary contiguity and its interaction
*with distance to MID location across the same range as the distance to MID location variable.;


setx cinc_km_wgs84_itj mean contig_itj 1 contig_itj_dist_wgs84 min alliance_itj 0 alliance_itj_dist_wgs84 0 
	distance_wgs84 min democ_itj 0 autoc_itj 0;

local a=0;
egen mean_pi=mean(pi);

drop mean_pi pi;

*Not Contiguous, Allied

*Set capability equal to its mean, contiguity and its interaction equal to 0, democracy equal to 0, autocracy equal to 0;
*Set allied equal to 1, vary distance to MID location from its min to its max, and thus, vary allied and its interaction
*with distance to MID location across the same range as the distance to MID location variable.;


setx cinc_km_wgs84_itj mean contig_itj 0 contig_itj_dist_wgs84 0 alliance_itj 1 alliance_itj_dist_wgs84 min 
	distance_wgs84 min democ_itj 0 autoc_itj 0;

local a=0;
egen mean_pi=mean(pi);

drop mean_pi pi;

};
*Contiguous, Allied

*Set capability equal to its mean, democracy equal to 0, autocracy equal to 0;
*Set contiguity equal to 1, allied equal to 1, vary distance to MID location from its min to its max, 
*and thus, vary contiguity and its interaction with distance to MID location and allied and its interaction 
*with distance to MID location across the same range as the distance variable.;


setx cinc_km_wgs84_itj mean contig_itj 1 contig_itj_dist_wgs84 min alliance_itj 1 alliance_itj_dist_wgs84 min 
	distance_wgs84 min democ_itj 0 autoc_itj 0;

egen mean_pi=mean(pi);

drop mean_pi pi;

};
drop b1 b2 b3 b4 b5 b6 b7 b8 b9;

*Save a file containing the predicted probabilities and confidence intervals to plot in R;