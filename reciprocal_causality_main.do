/*
Technical Appendix for 

Reciprocal Causality Theory and Model Toolkit: 
Autoregression, Simultaneous Feedback 
and Dynamic Cross-Lagged Models in Stata


Nate Breznau, University of Bremen, breznau.nate@gmail.com 

Stata version 15
*/


version 15
// GSS DATA

/*
GSS data downloaded from http://gss.norc.org/ 
original data copyrighted by NORC, therefore users must download their own file
GSS.dat and run 'gss_setup.do'. However, users can simply start with the 
cleaned file I provide 'gss_cleaned.dta'
*/

use "data/gss_cleaned.dta", clear

order id_ year
recode natrace-nathealy (0=.)(8=2)(1=3)(3=1)(9=.), gen (gblack gdefns gfaid groad gtrans gparks gspacey genvry gcityy gcrimy gdrugy geducy gblacky gdefnsy gfaidy geduc gdrug gcrim ghealth gwelf gsocs ghealthy)
recode spmentl sphlth spretire spunemp sphlthkd (0 9=.)(5=1)(4=2)(2=4)(1=5)(8=3)(3=3), gen(gmentl gsphlth gretire gunemp ghlthkd)
recode natspac-natfarey (0=.)(8=2)(1=3)(3=1)(9=.), gen (gspace genvr gcity gpoory)


// USA NATIONAL BUDGET DATA

*US National Budget
*Downloaded from https://www.whitehouse.gov/omb/historical-tables/ (18.12.2017)
*Calculations made for Big Cities and others, 
*see spreadsheet "data/US National Budget.xls".

merge m:1 year using "data/natbgt.dta"
drop _merge


// USA RIGHT PARTY DATA

/*
Right party control of exec and congress (from QoG).

Teorell, Jan, Stefan Dahlberg, Sören Holmberg, Bo Rothstein, Natalia Alvarado Pachon & Sofia Axelsson. 
2020. The Quality of Government Standard Dataset, version Jan20. University of Gothenburg: The Quality of 
Government Institute, http://www.qog.pol.gu.se doi:10.18157/qogstdjan20
*/

preserve
use "data/qog_bas_ts_jan20.dta", clear
drop if ccodealp != "USA"
keep ccode year cpds_lcon
drop if year < 1972 | year > 2016
* import Republican president = 1 by year data (hand coded)
merge 1:1 year using "data/rpc_exec.dta"
drop _merge
label var rpc_exec "President is Republican"
save "data/rpc.dta", replace
restore

merge m:1 year using "data/rpc.dta"
drop _merge


// USA CONSUMER SPENDING DATA

/*
”Index of Consumer Sentiment” (i.e., Consumer Confidence Index) 
from U of M http://www.sca.isr.umich.edu/tables.html 
*/

merge m:1 year using "data/cci.dta"
drop _merge
*Prep for Collapse
drop natrace-natfarey
drop gmentl-ghlthkd


// RECODE and SCALING

/*
1. Create a parity US$ value to comapre across years
2. Create change scores
3. Create a social spending as % of total budget
3. Create a predicted latent factor for social spending preferences
2. Lagged variables for preferences and spending
3. Change scores for both
4. Lagged independent variables
5. Counter and Republican control of gov't scale
6. Save 'recip.dta'
*/

do scaling.do

// Figure 1

do Fig1.do



// FIGURE 3

use "data/recip.dta", clear

*Time-Series Concerns
pwcorr gsociali gsocialilag1 social_p social_plag1
 
/*With a theory of x and y as reciprocally causal, even if lagged, 
they are then a system. Running them as seperate regressions ignores 
this system. The theory identifies 4 concepts (variables) and these 
are x at time one and two and y at time one and two. Without specifying 
this four variable relationship, theory is not parsimonious with the model. 
In other words, cannot explain the world I observe; at least not this tiny,
4-variable world. 
*/

reg social_p gsocialilag1, b
predict social_pR, residual
reg gsociali social_plag1, b
predict gsocialiR, residual
pwcorr gsocialiR gsociali gsocialilag1 social_pR social_p social_plag1
 
*Here the problem becomes evident, the residuals of each individual regression are highly correlated with the lagged version of each dependent variable.


// FIGURE 5

*Serial-correlation
set scheme plotplain
twoway (line social_p year, ytitle("Spending as %")) ///
(line gsociali year, yaxis(2) ytitle("Public Preferences", axis(2))), ///
graphregion(color(white)) bgcolor(white) leg(pos(6)) ///
xtitle(" ") 
graph export "results/Fig5.png", as(png) replace


twoway (scatter social_p social_plag1)(lfit social_p social_plag1)
 
*Auto-correlation. Simple concept that a variable is correlated with lagged versions of itself
tsset year
corrgram gsociali, lags(10)
*Partial correlation is the remaining correlation after adjusting for all shorter lag correlations.
 

corrgram social_p, lags(12)
 

xcorr social_p gsociali, lags(8)
 
*Estimation (Case N=1)
* ‘Old-Fashioned’ OLS approach
*Estimates have been made in the past using two OLS equations
reg gsociali social_plag1 gsocialilag1, b
reg social_p gsocialilag1 social_plag1, b
*Maximum Likelihood 
*results are the same
sem (gsociali <- gsocialilag1 social_plag1)(social_p <- social_plag1 gsocialilag1), standardize
*N=1 is a special case

*Estimation (Case N=many)

*Remove the effect of year trends by domain
*Everything left is what year trend does not explain
reg health_p year
predict healthPR, residual
reg defns_p year
predict defnsPR, residual
reg educ_p year
predict educPR, residual
reg cities2_p year
predict citiesPR, residual
reg envir_p year
predict envirPR, residual
reg space_p year
predict spacePR, residual
reg welf_p year
predict welfPR, residual
reg social_p year
predict socialPR, residual
*With and without year
reg social_p gsocialilag1 social_plag1, b
est store year1
reg gsociali social_plag1 gsocialilag1, b
est store year2

reg social_p gsocialilag1 social_plag1 year, b
est store year3
reg gsociali social_plag1 gsocialilag1 year, b
est store year4

label var social_p "Social Spend(%GDP)"
label var social_plag1 "Social Spend,t-1"
label var gsociali "Spend More"
label var gsocialilag1 "Spend More,t-1"
label var year "Year"

esttab year1 year2 year3 year4, beta r2 l
 

*VAR for comparison
tsset year
var social_p gsociali, lag(1)

*Standardize for comparison
egen social_pZ = std(social_p)
egen gsocialiZ = std(gsociali)

var social_pZ gsocialiZ, lag(1)
est store v1o
*Without constraints, these should be seemingly unrelated regression(SUR) estimates. SUR – are two-stage OLS equations where the residuals of the first stage are incorporated into the second state of the other equation 
var social_pZ gsocialiZ, lag(1) exog(year)
est store v1w
esttab v1o v1w

*Forecasting
*Impulse-Response
*Here I can test how a shock to one variable of magnitude 1 (i.e., 1 standard deviation when they are standardized) affects the future of the system (forcasting).
var gsocialiZ social_pZ, lag(1) exog(year)
irf graph oirf
 *Adding an impulse makes the system recursive, meaning that the ordering of variables matters.
*Also, consider that the orthogonalized irf represents Granger causality

*Lag>1
*Here OLS and VAR diverge
var social_pZ gsocialiZ, lag(1/2)
est store v1
reg social_pZ L1.gsocialiZ L2.gsocialiZ
est store v2
reg gsocialiZ L1.social_pZ L2.social_pZ
est store v3
esttab v1 v2 v3
*Combine measures
preserve

gen spend_p = health_p
gen gop = ghealthi
gen gopl1 = ghealthilag1
gen spendPR = healthPR
sort year
gen spendPRlag1 = spendPR[_n-1]
keep year spend_p gop gopl1 spendPR spendPRlag1 rpc_execlag1 rpc_conglag1

gen cat = 1
gen n = [_n]
save "C:\data\recip1.dta", replace

restore

preserve

gen spend_p = defns_p
gen gop = gdefnsi
gen gopl1 = gdefnsilag1
gen spendPR = defnsPR
sort year
gen spendPRlag1 = spendPR[_n-1]
keep year spend_p gop gopl1 spendPR spendPRlag1 rpc_execlag1 rpc_conglag1

gen cat = 2
gen n = [_n]
replace n=n+45
save "C:\data\recip2.dta", replace

restore

preserve

gen spend_p = educ_p
gen gop = geduci
gen gopl1 = geducilag1
gen spendPR = educPR
sort year
gen spendPRlag1 = spendPR[_n-1]
keep year spend_p gop gopl1 spendPR spendPRlag1 rpc_execlag1 rpc_conglag1

gen cat = 3
gen n = [_n]
replace n=n+90
save "C:\data\recip3.dta", replace

restore

preserve

gen spend_p = cities2_p
gen gop = gcityi
gen gopl1 = gcityilag1
gen spendPR = citiesPR
sort year
gen spendPRlag1 = spendPR[_n-1]
keep year spend_p gop gopl1 spendPR spendPRlag1 rpc_execlag1 rpc_conglag1

gen cat = 4
gen n = [_n]
replace n=n+135
save "C:\data\recip4.dta", replace

restore

preserve

gen spend_p = envir_p
gen gop = genvri
gen gopl1 = genvrilag1
gen spendPR = envirPR
sort year
gen spendPRlag1 = spendPR[_n-1]
keep year spend_p gop gopl1 spendPR spendPRlag1 rpc_execlag1 rpc_conglag1

gen cat = 5
gen n = [_n]
replace n=n+180
save "C:\data\recip5.dta", replace

restore

preserve

gen spend_p = space_p
gen gop = gspacei
gen gopl1 = gspaceilag1
gen spendPR = spacePR
sort year
gen spendPRlag1 = spendPR[_n-1]
keep year spend_p gop gopl1 spendPR spendPRlag1 rpc_execlag1 rpc_conglag1

gen cat = 6
gen n = [_n]
replace n=n+225
save "C:\data\recip6.dta", replace

restore

gen spend_p = welf_p
gen gop = gwelfi
gen gopl1 = gwelfilag1
gen spendPR = welfPR
sort year
gen spendPRlag1 = spendPR[_n-1]
keep year spend_p gop gopl1 spendPR spendPRlag1 rpc_execlag1 rpc_conglag1
 
gen cat = 7
gen n = [_n]
replace n=n+270

*Merge combined data
append using "C:\data\recip1.dta"
append using "C:\data\recip2.dta"
append using "C:\data\recip3.dta"
append using "C:\data\recip4.dta"
append using "C:\data\recip5.dta"
append using "C:\data\recip6.dta"
save "C:\data\recipC.dta", replace
*Panel Structure by Policy Domain
use "C:\data\recipC.dta", clear

label define cat 1 "health" 2 "defense" 3 "educ" 4 "cities" 5 "envir" 6 "space" 7 "welf"
label val cat cat
gen counter = year-1971

drop if gop==.
replace counter = counter-1

*OLS / ML results are again identical
reg spendPR gopl1 spendPRlag1, b
reg gop spendPRlag1 gopl1, b
 
sem (spendPR <- gopl1 spendPRlag1) (gop <- spendPRlag1 gopl1), standardize
*Cross-Lagged Heterogeneity
*With more than two time points (and more than 1 case) researchers often just assume that cross-lagged effects are the same. But this is an empirical question. To test it requires data to be reshaped into wide format.
preserve
keep spend_p gop spendPR cat counter
reshape wide spend_p gop spendPR, i(cat) j(counter)

*Model 1 - Free
sem (spendPR2 <- spendPR1@b1 gop1@b2) (spendPR3 <- spendPR2@b1 gop2@b2) (spendPR4 <- spendPR3@b1 gop3@b2) (spendPR5 <- spendPR4@b1 gop4@b2) (spendPR6 <- spendPR5@b1 gop5@b2) (spendPR7 <- spendPR6@b1 gop6@b2) (spendPR8 <- spendPR7@b1 gop7@b2) (spendPR9 <- spendPR8@b1 gop8@b2) (spendPR10 <- spendPR9@b1 gop9@b2) (spendPR11 <- spendPR10@b1 gop10@b2) (spendPR12 <- spendPR11@b1 gop11@b2) (spendPR13 <- spendPR12@b1 gop12@b2) (spendPR14 <- spendPR13@b1 gop13@b2) (spendPR15 <- spendPR14@b1 gop14@b2)(spendPR16 <- spendPR15@b1 gop15@b2) (spendPR17 <- spendPR16@b1 gop16@b2) (spendPR18 <- spendPR17@b1 gop17@b2) (spendPR19 <- spendPR18@b1 gop18@b2) (spendPR20 <- spendPR19@b1 gop19@b2) (spendPR21 <- spendPR20@b1 gop20@b2)(spendPR22 <- spendPR21@b1 gop21@b2) (spendPR23 <- spendPR22@b1 gop22@b2) (spendPR24 <- spendPR23@b1 gop23@b2) (spendPR25 <- spendPR24@b1 gop24@b2) (spendPR26 <- spendPR25@b1 gop25@b2) (spendPR27 <- spendPR26@b1 gop26@b2)(spendPR28 <- spendPR27@b1 gop27@b2) (spendPR29 <- spendPR28@b1 gop28@b2) (spendPR30 <- spendPR29@b1 gop29@b2) (spendPR31 <- spendPR30@b1 gop30@b2) (spendPR32 <- spendPR31@b1 gop31@b2) (spendPR33 <- spendPR32@b1 gop32@b2)(spendPR34 <- spendPR33@b1 gop33@b2) (spendPR35 <- spendPR34@b1 gop34@b2) (spendPR36 <- spendPR35@b1 gop35@b2) (spendPR37 <- spendPR36@b1 gop36@b2) (spendPR38 <- spendPR37@b1 gop37@b2) (spendPR39 <- spendPR38@b1 gop38@b2)(spendPR40 <- spendPR39@b1 gop39@b2) (spendPR41 <- spendPR40@b1 gop40@b2) (spendPR42 <- spendPR41@b1 gop41@b2) (spendPR43 <- spendPR42@b1 gop42@b2) (spendPR44 <- spendPR43@b1 gop43@b2)(gop2 <- gop1@a1 spendPR1@a2) (gop3 <- gop2@a1 spendPR2@a2) (gop4 <- gop3@a1 spendPR3@a2) (gop5 <- gop4@a1 spendPR4@a2) (gop6 <- gop5@a1 spendPR5@a2) (gop7 <- gop6@a1 spendPR6@a2) (gop8 <- gop7@a1 spendPR7@a2) (gop9 <- gop8@a1 spendPR8@a2) (gop10 <- gop9@a1 spendPR9@a2) (gop11 <- gop10@a1 spendPR10@a2) (gop12 <- gop11@a1 spendPR11@a2) (gop13 <- gop12@a1 spendPR12@a2) (gop14 <- gop13@a1 spendPR13@a2) (gop15 <- gop14@a1 spendPR14@a2)(gop16 <- gop15@a1 spendPR15@a2) (gop17 <- gop16@a1 spendPR16@a2) (gop18 <- gop17@a1 spendPR17@a2) (gop19 <- gop18@a1 spendPR18@a2) (gop20 <- gop19@a1 spendPR19@a2) (gop21 <- gop20@a1 spendPR20@a2)(gop22 <- gop21@a1 spendPR21@a2) (gop23 <- gop22@a1 spendPR22@a2) (gop24 <- gop23@a1 spendPR23@a2) (gop25 <- gop24@a1 spendPR24@a2) (gop26 <- gop25@a1 spendPR25@a2) (gop27 <- gop26@a1 spendPR26@a2)(gop28 <- gop27@a1 spendPR27@a2) (gop29 <- gop28@a1 spendPR28@a2) (gop30 <- gop29@a1 spendPR29@a2) (gop31 <- gop30@a1 spendPR30@a2) (gop32 <- gop31@a1 spendPR31@a2) (gop33 <- gop32@a1 spendPR32@a2)(gop34 <- gop33@a1 spendPR33@a2) (gop35 <- gop34@a1 spendPR34@a2) (gop36 <- gop35@a1 spendPR35@a2) (gop37 <- gop36@a1 spendPR36@a2) (gop38 <- gop37@a1 spendPR37@a2) (gop39 <- gop38@a1 spendPR38@a2)(gop40 <- gop39@a1 spendPR39@a2) (gop41 <- gop40@a1 spendPR40@a2) (gop42 <- gop41@a1 spendPR41@a2) (gop43 <- gop42@a1 spendPR42@a2) (gop44 <- gop43@a1 spendPR43@a2)

estat gof
est store m1
*Model 2 – constrained
sem (spendPR2 <- spendPR1 gop1) (spendPR3 <- spendPR2 gop2) (spendPR4 <- spendPR3 gop3) (spendPR5 <- spendPR4 gop4) (spendPR6 <- spendPR5 gop5) (spendPR7 <- spendPR6 gop6) (spendPR8 <- spendPR7 gop7) (spendPR9 <- spendPR8 gop8) (spendPR10 <- spendPR9 gop9) (spendPR11 <- spendPR10 gop10) (spendPR12 <- spendPR11 gop11) (spendPR13 <- spendPR12 gop12) (spendPR14 <- spendPR13 gop13) (spendPR15 <- spendPR14 gop14)(spendPR16 <- spendPR15 gop15) (spendPR17 <- spendPR16 gop16) (spendPR18 <- spendPR17 gop17) (spendPR19 <- spendPR18 gop18) (spendPR20 <- spendPR19 gop19) (spendPR21 <- spendPR20 gop20)(spendPR22 <- spendPR21 gop21) (spendPR23 <- spendPR22 gop22) (spendPR24 <- spendPR23 gop23) (spendPR25 <- spendPR24 gop24) (spendPR26 <- spendPR25 gop25) (spendPR27 <- spendPR26 gop26)(spendPR28 <- spendPR27 gop27) (spendPR29 <- spendPR28 gop28) (spendPR30 <- spendPR29 gop29) (spendPR31 <- spendPR30 gop30) (spendPR32 <- spendPR31 gop31) (spendPR33 <- spendPR32 gop32)(spendPR34 <- spendPR33 gop33) (spendPR35 <- spendPR34 gop34) (spendPR36 <- spendPR35 gop35) (spendPR37 <- spendPR36 gop36) (spendPR38 <- spendPR37 gop37) (spendPR39 <- spendPR38 gop38)(spendPR40 <- spendPR39 gop39) (spendPR41 <- spendPR40 gop40) (spendPR42 <- spendPR41 gop41) (spendPR43 <- spendPR42 gop42) (spendPR44 <- spendPR43 gop43)(gop2 <- gop1 spendPR1) (gop3 <- gop2 spendPR2) (gop4 <- gop3 spendPR3) (gop5 <- gop4 spendPR4) (gop6 <- gop5 spendPR5) (gop7 <- gop6 spendPR6) (gop8 <- gop7 spendPR7) (gop9 <- gop8 spendPR8) (gop10 <- gop9 spendPR9) (gop11 <- gop10 spendPR10) (gop12 <- gop11 spendPR11) (gop13 <- gop12 spendPR12) (gop14 <- gop13 spendPR13) (gop15 <- gop14 spendPR14)(gop16 <- gop15 spendPR15) (gop17 <- gop16 spendPR16) (gop18 <- gop17 spendPR17) (gop19 <- gop18 spendPR18) (gop20 <- gop19 spendPR19) (gop21 <- gop20 spendPR20)(gop22 <- gop21 spendPR21) (gop23 <- gop22 spendPR22) (gop24 <- gop23 spendPR23) (gop25 <- gop24 spendPR24) (gop26 <- gop25 spendPR25) (gop27 <- gop26 spendPR26)(gop28 <- gop27 spendPR27) (gop29 <- gop28 spendPR28) (gop30 <- gop29 spendPR29) (gop31 <- gop30 spendPR30) (gop32 <- gop31 spendPR31) (gop33 <- gop32 spendPR32)(gop34 <- gop33 spendPR33) (gop35 <- gop34 spendPR34) (gop36 <- gop35 spendPR35) (gop37 <- gop36 spendPR36) (gop38 <- gop37 spendPR37) (gop39 <- gop38 spendPR38)(gop40 <- gop39 spendPR39) (gop41 <- gop40 spendPR40) (gop42 <- gop41 spendPR41) (gop43 <- gop42 spendPR42) (gop44 <- gop43 spendPR43)
estat gof
est store m2

*Panel Fixed-Effects Regression
*(Allison, Williams, & Moral-Benito, 2017)
*First run gave matsize error
xtset cat counter
set matsize 10000
xtdpdml spendPR L1.gop, std
 
*Something did not converge, must adjust settings. Allison warned that this model is best suited to many unites and few periods.
*Try the alternative model (the older type)





*Used to display command but not run
xtdpdml spendPR L1.gop, dryrun std showcmd

*See Mplus User’s Guide 8 Chapter 6.25 example to get a first-order VAR
*See xtdpdml forthcoming Stata Journal article

*VAR
var spendPR gop if cat==2, lag(1)
 
*Two-Wave Panel Design (without a panel)
*Potential in cross-national/cross-sectional research, many countries with only two observational waves
use "C:\data\recipess.dta", clear
drop cyear
reshape wide govold govun govchild gdp socx, i(countryx) j(year)


sem (GOV08 -> govold2008 govun2008 govchild2008)(GOV16 -> govold2016 govun2016 govchild2016)(GOV16 <- GOV08), latent(GOV16 GOV08) iter(100)
sem (GOV08 -> govold2008 govun2008 govchild2008)(GOV16 -> govold2016 govun2016 govchild2016)(GOV16 <- GOV08)(socx2016 <- socx2008)(socx2016 <- GOV08)(GOV16 <- socx2008) , latent(GOV08 GOV16) iter(100)

*There is a problem with convergence because of the childcare question in 2016. Here’s a cheat to reduce the problematic variance a bit.
reg govchild2016 govchild2008
predict govchild2016i
reg govchild2016 govchild2008
predict govchild2016r, residual
sum govchild2016r
gen r = govchild2016r/3
gen govchild2016ir = govchild2016i + r
*And it finally converges
sem (GOV16 -> govold2016 govun2016 govchild2016ir), latent(GOV16)

sem (GOV08 -> govold2008 govun2008 govchild2008)(GOV16 -> govold2016 govun2016 govchild2016ir)(GOV16 <- GOV08)(socx2016 <- socx2008)(socx2016 <- GOV08)(GOV16 <- socx2008) , latent(GOV08 GOV16) iter(200)
*There’s just not enough cases

