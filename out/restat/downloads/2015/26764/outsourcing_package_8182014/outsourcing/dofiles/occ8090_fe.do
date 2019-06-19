#delimit;
********************************************;
* Create two-digit occupation fixed effects ;
********************************************;
gen occ8090_fe=0 if occ8090>=0 & occ8090<=9;
replace occ8090_fe=1 if occ8090>=10 & occ8090<=19;
replace occ8090_fe=2 if occ8090>=20 & occ8090<=29;
replace occ8090_fe=3 if occ8090>=30 & occ8090<=39;
replace occ8090_fe=4 if occ8090>=40 & occ8090<=49;
replace occ8090_fe=5 if occ8090>=50 & occ8090<=59;
replace occ8090_fe=6 if occ8090>=60 & occ8090<=69;
replace occ8090_fe=7 if occ8090>=70 & occ8090<=79;
replace occ8090_fe=8 if occ8090>=80 & occ8090<=89;
replace occ8090_fe=9 if occ8090>=90 & occ8090<=99;
replace occ8090_fe=10 if occ8090>=100 & occ8090<=109;
replace occ8090_fe=11 if occ8090>=110 & occ8090<=119;
replace occ8090_fe=12 if occ8090>=120 & occ8090<=129;
replace occ8090_fe=13 if occ8090>=130 & occ8090<=139;
replace occ8090_fe=14 if occ8090>=140 & occ8090<=149;
replace occ8090_fe=15 if occ8090>=150 & occ8090<=159;
replace occ8090_fe=16 if occ8090>=160 & occ8090<=169;
replace occ8090_fe=17 if occ8090>=170 & occ8090<=179;
replace occ8090_fe=18 if occ8090>=180 & occ8090<=189;
replace occ8090_fe=19 if occ8090>=190 & occ8090<=199;
replace occ8090_fe=20 if occ8090>=200 & occ8090<=209;
replace occ8090_fe=21 if occ8090>=210 & occ8090<=219;
replace occ8090_fe=22 if occ8090>=220 & occ8090<=229;
replace occ8090_fe=23 if occ8090>=230 & occ8090<=239;
replace occ8090_fe=24 if occ8090>=240 & occ8090<=249;
replace occ8090_fe=25 if occ8090>=250 & occ8090<=259;
replace occ8090_fe=26 if occ8090>=260 & occ8090<=269;
replace occ8090_fe=27 if occ8090>=270 & occ8090<=279;
replace occ8090_fe=28 if occ8090>=280 & occ8090<=289;
replace occ8090_fe=29 if occ8090>=290 & occ8090<=299;
replace occ8090_fe=30 if occ8090>=300 & occ8090<=309;
replace occ8090_fe=31 if occ8090>=310 & occ8090<=319;
replace occ8090_fe=32 if occ8090>=320 & occ8090<=329;
replace occ8090_fe=33 if occ8090>=330 & occ8090<=339;
replace occ8090_fe=34 if occ8090>=340 & occ8090<=349;
replace occ8090_fe=35 if occ8090>=350 & occ8090<=359;
replace occ8090_fe=36 if occ8090>=360 & occ8090<=369;
replace occ8090_fe=37 if occ8090>=370 & occ8090<=379;
replace occ8090_fe=38 if occ8090>=380 & occ8090<=389;
replace occ8090_fe=39 if occ8090>=390 & occ8090<=399;
replace occ8090_fe=40 if occ8090>=400 & occ8090<=409;
replace occ8090_fe=41 if occ8090>=410 & occ8090<=419;
replace occ8090_fe=42 if occ8090>=420 & occ8090<=429;
replace occ8090_fe=43 if occ8090>=430 & occ8090<=439;
replace occ8090_fe=44 if occ8090>=440 & occ8090<=449;
replace occ8090_fe=45 if occ8090>=450 & occ8090<=459;
replace occ8090_fe=46 if occ8090>=460 & occ8090<=469;
replace occ8090_fe=47 if occ8090>=470 & occ8090<=479;
replace occ8090_fe=48 if occ8090>=480 & occ8090<=489;
replace occ8090_fe=49 if occ8090>=490 & occ8090<=499;
replace occ8090_fe=50 if occ8090>=500 & occ8090<=509;
replace occ8090_fe=51 if occ8090>=510 & occ8090<=519;
replace occ8090_fe=52 if occ8090>=520 & occ8090<=529;
replace occ8090_fe=53 if occ8090>=530 & occ8090<=539;
replace occ8090_fe=54 if occ8090>=540 & occ8090<=549;
replace occ8090_fe=55 if occ8090>=550 & occ8090<=559;
replace occ8090_fe=56 if occ8090>=560 & occ8090<=569;
replace occ8090_fe=57 if occ8090>=570 & occ8090<=579;
replace occ8090_fe=58 if occ8090>=580 & occ8090<=589;
replace occ8090_fe=59 if occ8090>=590 & occ8090<=599;
replace occ8090_fe=60 if occ8090>=600 & occ8090<=609;
replace occ8090_fe=61 if occ8090>=610 & occ8090<=619;
replace occ8090_fe=62 if occ8090>=620 & occ8090<=629;
replace occ8090_fe=63 if occ8090>=630 & occ8090<=639;
replace occ8090_fe=64 if occ8090>=640 & occ8090<=649;
replace occ8090_fe=65 if occ8090>=650 & occ8090<=659;
replace occ8090_fe=66 if occ8090>=660 & occ8090<=669;
replace occ8090_fe=67 if occ8090>=670 & occ8090<=679;
replace occ8090_fe=68 if occ8090>=680 & occ8090<=689;
replace occ8090_fe=69 if occ8090>=690 & occ8090<=699;
replace occ8090_fe=70 if occ8090>=700 & occ8090<=709;
replace occ8090_fe=71 if occ8090>=710 & occ8090<=719;
replace occ8090_fe=72 if occ8090>=720 & occ8090<=729;
replace occ8090_fe=73 if occ8090>=730 & occ8090<=739;
replace occ8090_fe=74 if occ8090>=740 & occ8090<=749;
replace occ8090_fe=75 if occ8090>=750 & occ8090<=759;
replace occ8090_fe=76 if occ8090>=760 & occ8090<=769;
replace occ8090_fe=77 if occ8090>=770 & occ8090<=779;
replace occ8090_fe=78 if occ8090>=780 & occ8090<=789;
replace occ8090_fe=79 if occ8090>=790 & occ8090<=799;
replace occ8090_fe=80 if occ8090>=800 & occ8090<=809;
replace occ8090_fe=81 if occ8090>=810 & occ8090<=819;
replace occ8090_fe=82 if occ8090>=820 & occ8090<=829;
replace occ8090_fe=83 if occ8090>=830 & occ8090<=839;
replace occ8090_fe=84 if occ8090>=840 & occ8090<=849;
replace occ8090_fe=85 if occ8090>=850 & occ8090<=859;
replace occ8090_fe=86 if occ8090>=860 & occ8090<=869;
replace occ8090_fe=87 if occ8090>=870 & occ8090<=879;
replace occ8090_fe=88 if occ8090>=880 & occ8090<=889;