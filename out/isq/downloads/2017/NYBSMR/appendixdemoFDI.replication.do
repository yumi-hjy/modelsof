/* This code is for the APPENDIX to empirical analysis of "Democratization and FDI Liberalization, 1970-2000" */

/* 20 Point Polity Variable */ 



use "/Users/ssp5d/Dropbox/data_sonal/notoecd.dta", clear


use "/Users/ssp5d/Desktop/RESEARCH/data_sonal/full.interp.entry.dta", clear

xtabond entry_res l.democracy l.currency l.bank l.reschedule l.signed_imf l.entryres_lang l.entry_res_colony l.ln_gdp_pc, two maxldep(2) maxlags(1) vce(robust) 

/* Cumulative Measure of Democracy */