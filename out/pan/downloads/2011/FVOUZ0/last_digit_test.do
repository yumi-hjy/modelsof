clearset more off#delimit ;log using "/Users/sebastian/Mac/Argentina/Fraud/paper/replication_materials/last_digit_test", replace text;use "/Users/sebastian/Mac/Argentina/Fraud/paper/replication_materials/real_simulated_votes.dta";tostring radical_clean conservative_clean radical_fraud conservative_fraud radical_1931 conservative_1931 radical_1935 conservative_1935 radical_1940 conservative_1940 conservative_1941 radical_1941, replace;gen lenp_1=length(radical_clean);gen lenp_2=length(conservative_clean);gen lenp_3=length(radical_fraud);gen lenp_4=length(conservative_fraud);gen lenp_5=length(radical_1931);gen lenp_6=length(conservative_1931);gen lenp_7=length(radical_1935);gen lenp_8=length(conservative_1935);gen lenp_9=length(radical_1940);gen lenp_10=length(conservative_1940);gen lenp_11=length(radical_1941);gen lenp_12=length(conservative_1941);gen l_1=substr(radical_clean,lenp_1,1);gen l_2=substr(conservative_clean,lenp_2,1);gen l_3=substr(radical_fraud,lenp_3,1);gen l_4=substr(conservative_fraud,lenp_4,1);gen l_5=substr(radical_1931,lenp_5,1);gen l_6=substr(conservative_1931,lenp_6,1);gen l_7=substr(radical_1935,lenp_7,1);gen l_8=substr(conservative_1935,lenp_8,1);gen l_9=substr(radical_1940,lenp_9,1);gen l_10=substr(conservative_1940,lenp_10,1);gen l_11=substr(radical_1941,lenp_11,1);gen l_12=substr(conservative_1941,lenp_12,1);destring radical_clean conservative_clean radical_fraud conservative_fraud radical_1931 conservative_1931 radical_1935 conservative_1935 radical_1940 conservative_1940 conservative_1941 radical_1941, replace;destring l_1 l_2 l_3 l_4 l_5 l_6 l_7 l_8 l_9 l_10 l_11 l_12, replace;*/ Last Digit Test */;*/ Simulated Clean */;csgof l_1, expperc(10 10 10 10 10 10 10 10 10 10);csgof l_2, expperc(10 10 10 10 10 10 10 10 10 10);*/ Simulated Fraud */;csgof l_3, expperc(10 10 10 10 10 10 10 10 10 10);csgof l_4, expperc(10 10 10 10 10 10 10 10 10 10);*/ 1931 */;csgof l_5, expperc(10 10 10 10 10 10 10 10 10 10);csgof l_6, expperc(10 10 10 10 10 10 10 10 10 10);*/ 1935 */;csgof l_7, expperc(10 10 10 10 10 10 10 10 10 10);csgof l_8, expperc(10 10 10 10 10 10 10 10 10 10);*/ 1940 */;csgof l_9, expperc(10 10 10 10 10 10 10 10 10 10);csgof l_10, expperc(10 10 10 10 10 10 10 10 10 10);*/ 1941 */;csgof l_11, expperc(10 10 10 10 10 10 10 10 10 10);csgof l_12, expperc(10 10 10 10 10 10 10 10 10 10);log c; 