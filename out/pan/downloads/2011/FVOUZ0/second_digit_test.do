clearset more off#delimit ;log using "/Users/sebastian/Mac/Argentina/Fraud/paper/replication_materials/second_digit_test", replace text;use "/Users/sebastian/Mac/Argentina/Fraud/paper/replication_materials/real_simulated_votes.dta";label var radical_clean " ";label var conservative_clean " ";label var radical_fraud " ";label var conservative_fraud " ";tostring radical_clean conservative_clean radical_fraud conservative_fraud radical_1931 conservative_1931 radical_1935 conservative_1935 radical_1940 conservative_1940 conservative_1941 radical_1941, replace;gen s_1=substr(radical_clean,2,1);gen s_2=substr(conservative_clean,2,1);gen s_3=substr(radical_fraud,2,1);gen s_4=substr(conservative_fraud,2,1);gen s_5=substr(radical_1931,2,1);gen s_6=substr(conservative_1931,2,1);gen s_7=substr(radical_1935,2,1);gen s_8=substr(conservative_1935,2,1);gen s_9=substr(radical_1940,2,1);gen s_10=substr(conservative_1940,2,1);gen s_11=substr(radical_1941,2,1);gen s_12=substr(conservative_1941,2,1);destring radical_clean conservative_clean radical_fraud conservative_fraud radical_1931 conservative_1931 radical_1935 conservative_1935 radical_1940 conservative_1940 conservative_1941 radical_1941, replace;destring s_1 s_2 s_3 s_4 s_5 s_6 s_7 s_8 s_9 s_10 s_11 s_12, replace;*/ Second Digit Test */;*/ Simulated Clean */;csgof s_1, expperc(12 11.4 10.9 10.4 10 9.7 9.3 9 8.8 8.5);csgof s_2, expperc(12 11.4 10.9 10.4 10 9.7 9.3 9 8.8 8.5);*/ Simulated Fraud */;csgof s_3, expperc(12 11.4 10.9 10.4 10 9.7 9.3 9 8.8 8.5);csgof s_4, expperc(12 11.4 10.9 10.4 10 9.7 9.3 9 8.8 8.5);*/ 1931 */;csgof s_5, expperc(12 11.4 10.9 10.4 10 9.7 9.3 9 8.8 8.5);csgof s_6, expperc(12 11.4 10.9 10.4 10 9.7 9.3 9 8.8 8.5);*/ 1935 */;csgof s_7, expperc(12 11.4 10.9 10.4 10 9.7 9.3 9 8.8 8.5);csgof s_8, expperc(12 11.4 10.9 10.4 10 9.7 9.3 9 8.8 8.5);*/ 1940 */;csgof s_9, expperc(12 11.4 10.9 10.4 10 9.7 9.3 9 8.8 8.5);csgof s_10, expperc(12 11.4 10.9 10.4 10 9.7 9.3 9 8.8 8.5);*/ 1941 */;csgof s_11, expperc(12 11.4 10.9 10.4 10 9.7 9.3 9 8.8 8.5);csgof s_12, expperc(12 11.4 10.9 10.4 10 9.7 9.3 9 8.8 8.5);log c; 