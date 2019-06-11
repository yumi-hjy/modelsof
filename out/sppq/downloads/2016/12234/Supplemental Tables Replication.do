// Appendix Table B1reg CDcomp prescomp NG if GerryYearreg CDcomp prescomp DG RG CG NG if GerryYearreg CDcomp prescomp DG RG CG NG if ~confederacy&GerryYear// Appendix Table C1probit close prescomp popcomp DemG RepG BipartG CourtG NonpartG, cluster(cdcluster)probit close prescomp popcomp DemG RepG BipartG CourtG NonpartG if confederacy==0, cluster(cdcluster)probit close prescomp popcomp Open DemG RepG BipartG CourtG NonpartG, cluster(cdcluster)probit close prescomp popcomp DemG RepG BipartG CourtG NonpartG DemPC RepPC BipartPC CourtPC NonpartPC, cluster(cdcluster)// Table C2probit close prescomp popcomp if DemG, cluster(cdcluster)probit close prescomp popcomp if RepG, cluster(cdcluster)probit close prescomp popcomp if DemG|RepG, cluster(cdcluster)probit close prescomp popcomp if BipartG, cluster(cdcluster)probit close prescomp popcomp if NonpartG, cluster(cdcluster)probit close prescomp popcomp if small, cluster(cdcluster)probit close prescomp popcomp, cluster(cdcluster)// Table C3probit close prescomp popcomp if DemG&popularvote<0, cluster(cdcluster)probit close prescomp popcomp if DemG&popularvote>0, cluster(cdcluster)probit close prescomp popcomp if DemG, cluster(cdcluster)// Table C4reg MeanClose prescomp popcomp DG RG CG NG if cd==1 [aweight=weight], cluster(cdcluster)reg MeanClose prescomp popcomp DG RG CG NG DGPC RGPC CGPC NGPC if cd==1 [aweight=weight], cluster(cdcluster)reg MeanClose prescomp popcomp DG RG CG NG DGPC RGPC CGPC NGPC weight if cd==1 [aweight=weight], cluster(cdcluster)reg MeanClose prescomp popcomp DemG RepG BipartG CourtG NonpartG if cd==1 [aweight=weight], cluster(cdcluster)reg MeanClose prescomp popcomp DemG RepG BipartG CourtG NonpartG DemPC RepPC BipartPC CourtPC NonpartPC if cd==1 [aweight=weight], cluster(cdcluster)// Table C5probit close prescomp wavehigh DG RG CG NG, cluster(cdcluster)probit close prescomp wavehigh DG RG CG NG if confederacy==0, cluster(cdcluster)probit close prescomp wavehigh DG RG CG NG weight, cluster(cdcluster)probit close prescomp wavehigh Open DG RG CG NG, cluster(cdcluster)probit close prescomp wavehigh DG RG CG NG DGWave RGWave CGWave NGWave, cluster(cdcluster)probit close prescomp wavehigh DG RG CG NG DGWave RGWave CGWave NGWave weight, cluster(cdcluster)// Table C6probit close prescomp wavehigh if DG, cluster(cdcluster)probit close prescomp wavehigh if RG, cluster(cdcluster)probit close prescomp wavehigh if RG|DG, cluster(cdcluster)probit close prescomp wavehigh if BG, cluster(cdcluster)probit close prescomp wavehigh if NG, cluster(cdcluster)probit close prescomp wavehigh, cluster(cdcluster)//Table C7probit close prescomp wavehigh if DG&popularvote<0, cluster(cdcluster)probit close prescomp wavehigh if DG&popularvote>0, cluster(cdcluster)probit close prescomp wavehigh if DG, cluster(cdcluster)//Table C8probit close5 prescomp popcomp if DG, cluster(cdcluster)probit close5 prescomp popcomp if RG, cluster(cdcluster)probit close5 prescomp popcomp if RG|DG, cluster(cdcluster)probit close5 prescomp popcomp if BG, cluster(cdcluster)probit close5 prescomp popcomp if NG, cluster(cdcluster)probit close5 prescomp popcomp, cluster(cdcluster)probit close15 prescomp popcomp if DG, cluster(cdcluster)probit close15 prescomp popcomp if RG, cluster(cdcluster)probit close15 prescomp popcomp if RG|DG, cluster(cdcluster)probit close15 prescomp popcomp if BG, cluster(cdcluster)probit close15 prescomp popcomp if NG, cluster(cdcluster)probit close15 prescomp popcomp, cluster(cdcluster)//Table C9probit close prescomp popcomp Open DG RG CG NG, cluster(cdcluster)probit close prescomp popcomp Open DG RG CG NG DGPC RGPC CGPC NGPC, cluster(cdcluster)probit close prescomp popcomp CDcomp DG RG CG NG, cluster(cdcluster)probit close prescomp popcomp CDcomp DG RG CG NG DGPC RGPC CGPC NGPC, cluster(cdcluster)