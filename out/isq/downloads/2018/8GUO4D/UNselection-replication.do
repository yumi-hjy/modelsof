use UNselection-replication, clear

*Model 1
oprobit level7pt p5contig oilexp p5defpactany p5crisis1 p5both p5col pkexp04lagged if pcw==0

*Model 2
pre

*Model 3 



*Model 6
oprobit level7pt p5contig oilexp p5defpactany p5crisis1 p5both pcw p5crisis1pcw p5defpactanypcw p5col viol cractr lncrisisdur contig pkexp04lagged askunp5nw askunoth

*Model 7
oprobit level7sc p5contig oilexp p5defpactany p5crisis1 p5both pcw p5crisis1pcw p5defpactanypcw p5col pkexp04lagged

*Model 8
oprobit level7sc viol cractr lncrisisdur contig pkexp04lagged
estat ic
pre

*Model 9
oprobit level7pt p5contig oilexp p5defpactany p5crisis1 p5both pcw p5crisis1pcw p5defpactanypcw p5col viol cractr lncrisisdur contig p5aff_min pkexp04lagged

*Model 10
oprobit level7pt p5contig oilexp p5defpactany p5crisis1 p5both pcw p5crisis1pcw p5defpactanypcw p5col viol cractr lncrisisdur contig europe america africa asia pkexp04lagged
estat ic
pre


**Figure 1a
keep year siguninv