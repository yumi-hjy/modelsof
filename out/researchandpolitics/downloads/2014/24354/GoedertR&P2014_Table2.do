//The first three commands replicate Table 2 when used with the 2012 Congressional Results data set 

regress PercDiff DemG RepG Hisp if ~exclude [aweight=seats]