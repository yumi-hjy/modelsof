/*
** last changes: August 2017  by: J. Spenkuch (j-spenkuch@kellogg.northwestern.edu)
*/
if c(os) == "Unix" {
	global PATH "/projects/p30061"
	global PATHdata "/projects/p30061/data"
	global PATHcode "/projects/p30061/code"
	global PATHlogs "/projects/p30061/logs"
	
	cd $PATH
}
else if c(os) == "Windows" {
	global PATH "R:/Dropbox/research/advertising_paper/analysis"
	global PATHdata "R:/Dropbox/research/advertising_paper/analysis/input"
	global PATHcode "R:/Dropbox/research/advertising_paper/analysis/code"
	global PATHlogs "R:/Dropbox/research/advertising_paper/analysis/output"
	
	cd $PATH
}
else {
    display "unable to recognize OS -> abort!"
    exit
}


include code/preamble.do

#delim;

/**********************************************************
***
***		Table A26
***
**********************************************************/;

global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=5000 & (r_dem==1 | r_rep==1) & r_matched_street==1";
global VARs "r_vote r_D_ptyd_base r_ptyd_base_own r_dem BORDER*";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance r_rep r_matched_street";


log using $PATHlogs/log_tableA26.txt, replace;

cd $PATHcode;


use $VARs $SampleVars if $SAMPLE using $PATHdata/voterpanel.dta;
drop $SampleVars;

* helper vars;
gen byte T=(r_D_ptyd_base>0);
gen byte T_x_dem=T*r_dem;
forvalues p=1(1)4 {;
	gen distance`p'= r_D_ptyd_base^`p';
};
forvalues p=1(1)4 {;
	gen dem_x_distance`p'=r_dem* r_D_ptyd_base^`p';
};
forvalues p=1(1)4 {;
	gen T_x_distance`p'= T*r_D_ptyd_base^`p';
};
forvalues p=1(1)4 {;
	gen T_x_dem_x_distance`p'= T*r_dem*r_D_ptyd_base^`p';
};



*** cols (1)-(3) panel A;
forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: degree `p'";
	
	foreach bw in 500 1000 5000 {;

		di "BANDWIDTH: `bw' meters";
		
			
		areg r_vote
		T_x_dem T 
		distance1-distance`p' dem_x_distance1-dem_x_distance`p'
		T_x_distance1-T_x_distance`p' T_x_dem_x_distance1-T_x_dem_x_distance`p'
		if abs(r_D_ptyd_base)<=`bw', cluster(BORDER) absorb(BORDER_10k_PARTY_YEAR);

	
		local c=_b[T_x_dem];
		local s=_se[T_x_dem];
		local N=e(N);
		putexcel_wrapper  , coeff(`c') se(`s') p(`p') bw(`bw') n(`N') file("$PATHlogs/RDresults") sheet("rob_street_rf") opt("modify");


		
	};
};


*** cols (1)-(3) panel B;
gen PDIFFdem=r_ptyd_base_own*r_dem;

forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: degree `p'";
	foreach bw in 500 1000 5000 {;

		di "BANDWIDTH: `bw' meters";

		preserve;
		keep if abs(r_D_ptyd_base)<=`bw';
		
		tsls r_vote  (PDIFFdem r_ptyd_base_own = T T_x_dem) distance1-distance`p' dem_x_distance1-dem_x_distance`p' T_x_distance1-T_x_distance`p' T_x_dem_x_distance1-T_x_dem_x_distance`p', cluster(BORDER) fe(BORDER_10k_PARTY_YEAR) demean;
		
		local c=_b[PDIFFdem];
		local s=_se[PDIFFdem];
		local N=_N;
		
		restore;

		putexcel_wrapper, coeff(`c') se(`s') p(`p') bw(`bw') n(`N') file("$PATHlogs/RDresults") sheet("rob_street_tsls") opt("modify");
		

	};
};


log close;

