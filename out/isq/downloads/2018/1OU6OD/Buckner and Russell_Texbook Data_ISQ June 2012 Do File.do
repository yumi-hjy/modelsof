**********************************************

* Open Textbook Dataset

use "Textbook Data_ISQ_Cleaned.dta"

*************************************************************************

*************************************************************************
			size(*.80))
	ylabel(0[.1].6)



			size(*.8))

preserve
 	graph twoway (scatter globzn decade if world_==3, mc(gs5) msym(S))
	
	(scatter globzn decade if world_==1, mc(gs5) msym(+))
