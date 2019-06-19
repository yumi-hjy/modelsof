/* ML Estimators.do */
/* This file writes two maximum likelihood estimators */
/* Estimator 1: Quasi-hyperbolic discounting with Luce Errors */
/* Estimator 2: Pure hyperbolic discounting with Luce Errors */

/**** Estimator 1 ****/
/* Quasi-hyperbolic Discounting */

capture drop llbd

		
		* evaluate the discounted utilities
		generate double `duB' = (`b'*(`d'^`k')*(`optionB'))

/**** Estimator 2 ****/
/* Hyperbolic Discounting */

capture program drop ML_hyp
		

		generate double `duB' = (1/(1+(`a'*(t+k))))*`optionB'