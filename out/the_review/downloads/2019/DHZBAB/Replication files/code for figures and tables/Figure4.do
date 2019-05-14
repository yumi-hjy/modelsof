set scheme s1color
use petitionsdataset, clear


gen postwar=(issueyear>=1917)
gen german=(country=="Germany")

* create interactions of German dummy with petition year
tab issueyear, gen(yr_)
forval x=1/15 {
	gen inter_`x'=german*yr_`x'
}

estimates clear
xi: reg petitions i.country i.issueyear inter_2-inter_15 i.state, cl(country)
eststo m1
coefplot (m1, ciopts(lcolor(black) recast(rcap))), ci(90) vertical yline(0) keep(inter_*) ///
coeflabels(inter_2="1912" inter_3=" " inter_4="1914" inter_5=" " inter_6="1916" inter_7=" " inter_8="1918" ///
		inter_9=" " inter_10="1920" inter_11=" " inter_12="1922" inter_13=" " inter_14="1924" inter_15=" ") ///
		plotregion(style(none)) ysca(titlegap(2)) msize(small) mcolor(black) ///
		xtitle("Year of petition", size(small)) ytitle("Interaction with German", size(small)) ///
		xlabel(, nogrid labsize(small)) ylabel(, nogrid labsize(small)) xsca(titlegap(2))