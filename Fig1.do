// FIGURE 1

use "data/recip.dta", clear

pwcorr social_p gsocialilag1
pwcorr gsociali social_plag1

set scheme plotplain

twoway (scatter social_p gsocialilag1)(lfit social_p gsocialilag1), ///
graphregion(color(white)) bgcolor(white) leg(off) ///
title("Panel A. Spending and Lagged Preferences") ///
xtitle("Social Spending Preferences, t-1") ///
ytitle("Social Spending as % of Total Budget") ///
text(5.3 0 "R = 0.18", box margin(l+1 r+1 t+1 b+1) fcolor(white)) ///
saving("data/f1pa.gph", replace)

twoway (scatter gsociali social_plag1)(lfit gsociali social_plag1), ///
graphregion(color(white)) bgcolor(white) leg(off) ///
title("Panel B. Preferences and Lagged Spending") ///
xtitle("Social Spending as % of Total Budget, t-1") ///
ytitle("Social Spending Preferences") ///
text(-.05 5 "R = 0.12", box margin(l+1 r+1 t+1 b+1) fcolor(white)) ///
saving("data/f1pb.gph", replace)

gr combine "data/f1pa.gph" "data/f1pb.gph", ///
title("Fig 1. Competing Unidirectional Models") ///
note("NOTE: {it: Data from national budget and General Social Survey, USA 1972-2016}", size(vsmall))

graph export "results/Fig1.png", as(png) replace
