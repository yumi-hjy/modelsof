use "FL10g_ResultsCrosstabs.dta"

hist yhat_10

egen senate_few_total = rowtotal(senate_few_early senate_few)

*tabs of the poll predictions