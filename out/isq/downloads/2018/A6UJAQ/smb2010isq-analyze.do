version 9.2

use smb2010isq.dta, clear;
		/* Table 1, Model 1:  Naive Model. No imputation.	*/
streg COWIO jdemo2 totactor majdyad hihost pratio distance strtyr if imputeid==1 & sample==1, 

		/* Table 1, Model 2:  Duration with Selection Model.	*/
dursel cumdurat COWIO jdemo2 totactor majdyad hihost pratio distance strtyr 
