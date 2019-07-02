/* Replication do file for Erickson, Jennifer L. 2013. "Stopping the Legal Flow of Weapons: Compliance with Arms Embargoes, 1981-2004. Journal of Peace Research 50 (2)."
use "Erickson.ArmsEmbargo.v1.dta"*/

/* Figure 2 */

tabulate embargo satransfer, chi2 col row;
tabulate embargo mcwdich, chi2 col row;

/* Small arms xtlogit models and calculations for changes in predicted probabilities in Table I */

scalar coldwar_m = 0;

scalar satransfer_emtype1 = el(satransfer_coeff,1,5);
scalar satransfer_emtype3 = el(satransfer_coeff,1,7);
scalar satransfer_coldwar = el(satransfer_coeff,1,8);
scalar satransfer_y1981 = el(satransfer_coeff,1,9);
scalar satransfer_y1982 = el(satransfer_coeff,1,10);
scalar satransfer_y1990 = el(satransfer_coeff,1,18);
scalar satransfer_y2002 = el(satransfer_coeff,1,30);
scalar satransfer_y2003 = el(satransfer_coeff,1,31);
scalar satransfer_y2004 = el(satransfer_coeff,1,32);
scalar emtype1high_lp = satransfer_cons + (satransfer_polity2 * polity2lag_mean) + (satransfer_atopally * atopallylag_m) + (satransfer_ungdpcaplog * ungdpcaploglag_mean) + (satransfer_oilprod * oilprodlag_mean) + (satransfer_emtype1 * emtype1lag_high) + (satransfer_emtype2 * emtype2lag_m) + (satransfer_emtype3 * emtype3lag_m) + (satransfer_coldwar * coldwar_m) + (satransfer_y1981 * y1981_m) + (satransfer_y1982 * y1982_m) + (satransfer_y1983 * y1983_m) + (satransfer_y1984 * y1984_m) + (satransfer_y1985 * y1985_m) + (satransfer_y1986 * y1986_m) + (satransfer_y1987 * y1987_m) + (satransfer_y1988 * y1988_m) + (satransfer_y1989 * y1989_m) + (satransfer_y1990 * y1990_m) + (satransfer_y1991 * y1991_m) + (satransfer_y1992 * y1992_m) + (satransfer_y1993 * y1993_m) + (satransfer_y1994 * y1994_m) + (satransfer_y1995 * y1995_m) + (satransfer_y1996 * y1996_m) + (satransfer_y1997 * y1997_m) + (satransfer_y1998 * y1998_m) + (satransfer_y1999 * y1999_m) + (satransfer_y2000 * y2000_m) + (satransfer_y2001 * y2001_m) + (satransfer_y2002 * y2002_m) + (satransfer_y2003 * y2003_m) + (satransfer_y2004 * y2004_m);

scalar emtype2high_lp = satransfer_cons + (satransfer_polity2 * polity2lag_mean) + (satransfer_atopally * atopallylag_m) + (satransfer_ungdpcaplog * ungdpcaploglag_mean) + (satransfer_oilprod * oilprodlag_mean) + (satransfer_emtype1 * emtype1lag_m) + (satransfer_emtype2 * emtype2lag_high) + (satransfer_emtype3 * emtype3lag_m) + (satransfer_coldwar * coldwar_m) + (satransfer_y1981 * y1981_m) + (satransfer_y1982 * y1982_m) + (satransfer_y1983 * y1983_m) + (satransfer_y1984 * y1984_m) + (satransfer_y1985 * y1985_m) + (satransfer_y1986 * y1986_m) + (satransfer_y1987 * y1987_m) + (satransfer_y1988 * y1988_m) + (satransfer_y1989 * y1989_m) + (satransfer_y1990 * y1990_m) + (satransfer_y1991 * y1991_m) + (satransfer_y1992 * y1992_m) + (satransfer_y1993 * y1993_m) + (satransfer_y1994 * y1994_m) + (satransfer_y1995 * y1995_m) + (satransfer_y1996 * y1996_m) + (satransfer_y1997 * y1997_m) + (satransfer_y1998 * y1998_m) + (satransfer_y1999 * y1999_m) + (satransfer_y2000 * y2000_m) + (satransfer_y2001 * y2001_m) + (satransfer_y2002 * y2002_m) + (satransfer_y2003 * y2003_m) + (satransfer_y2004 * y2004_m);

scalar emtype3high_lp = satransfer_cons + (satransfer_polity2 * polity2lag_mean) + (satransfer_atopally * atopallylag_m) + (satransfer_ungdpcaplog * ungdpcaploglag_mean) + (satransfer_oilprod * oilprodlag_mean) + (satransfer_emtype1 * emtype1lag_m) + (satransfer_emtype2 * emtype2lag_m) + (satransfer_emtype3 * emtype3lag_high) + (satransfer_coldwar * coldwar_m) + (satransfer_y1981 * y1981_m) + (satransfer_y1982 * y1982_m) + (satransfer_y1983 * y1983_m) + (satransfer_y1984 * y1984_m) + (satransfer_y1985 * y1985_m) + (satransfer_y1986 * y1986_m) + (satransfer_y1987 * y1987_m) + (satransfer_y1988 * y1988_m) + (satransfer_y1989 * y1989_m) + (satransfer_y1990 * y1990_m) + (satransfer_y1991 * y1991_m) + (satransfer_y1992 * y1992_m) + (satransfer_y1993 * y1993_m) + (satransfer_y1994 * y1994_m) + (satransfer_y1995 * y1995_m) + (satransfer_y1996 * y1996_m) + (satransfer_y1997 * y1997_m) + (satransfer_y1998 * y1998_m) + (satransfer_y1999 * y1999_m) + (satransfer_y2000 * y2000_m) + (satransfer_y2001 * y2001_m) + (satransfer_y2002 * y2002_m) + (satransfer_y2003 * y2003_m) + (satransfer_y2004 * y2004_m);

/* Small arms "moving windows" analyses, Figure 3 */

/* Major conventional arms xtpcse models in Table II */

tsset dyadid year;
xtpcse mctransfer polity2lag atopallylag ungdpcaploglag oilprodlag emdichlag coldwar y1981 y1982 y1982 y1984 y1985 y1986 y1987 y1988 y1989 y1990 y1991 y1992 y1993 y1994 y1995 y1996 y1997 y1998 y1999 y2000 y2001 y2002 y2003 y2004, hetonly;
xtpcse mctransfer polity2lag atopallylag ungdpcaploglag oilprodlag embargopartiallag embargofulllag coldwar y1981 y1982 y1982 y1984 y1985 y1986 y1987 y1988 y1989 y1990 y1991 y1992 y1993 y1994 y1995 y1996 y1997 y1998 y1999 y2000 y2001 y2002 y2003 y2004, hetonly;
xtpcse mctransfer polity2lag atopallylag ungdpcaploglag oilprodlag emtype1lag emtype2lag emtype3lag coldwar y1981 y1982 y1982 y1984 y1985 y1986 y1987 y1988 y1989 y1990 y1991 y1992 y1993 y1994 y1995 y1996 y1997 y1998 y1999 y2000 y2001 y2002 y2003 y2004, hetonly;

/* Major conventional arms "moving windows" analyses, Figure 4 */
