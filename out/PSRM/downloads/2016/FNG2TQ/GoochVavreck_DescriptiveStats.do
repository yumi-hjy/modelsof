** GOOCH AND VAVRECK -- Descriptive Statistics 

** Run this file on data called GoochVavreck_DescriptiveStats




***  CREATE VARS for the DESCRIPTIVE STATS TABLES
	choice08 newsp dentist techinternetfreq smoker drink churatd
	moby meds wsum1 wsum2 wsum4 wsum5 
	immi partyid retro income educ race trust interest bible teaparty
	rr_1 rr_2 rr_3 rr_4 { ;
	gen `i'codeNM = `i'code
	replace `i'codeNM = . if `i'code == 0
	}
	replace `i'NM = . if `i' == 5
	}
	
foreach i in meds register {
	replace `i'NM = . if `i' == 3
	}
	
replace choice08NM = . if choice08NM == 4
	
***** CREATE TABLE OF DESCRIPTIVE STATISTICS

sum *NM, separator(0)	