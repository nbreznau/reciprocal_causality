*Convert to 2016 US$
*https://www.measuringworth.com/uscompare/relativevalue.php
*"economic power" in 2016 US$
*divide by 1k to switch from millions to billions

recode year (2016=1)(2015=0.97)(2014=0.94)(2013=0.9)(2012=0.87)(2011=0.83) ///
(2010=0.8)(2009=0.77)(2008=0.79)(2007=0.78)(2006=0.74)(2005=0.7)(2004=0.66) ///
(2003=0.62)(2002=0.59)(2001=0.57)(2000=0.55)(1999=0.52)(1998=0.49)(1997=0.46) ///
(1996=0.44)(1995=0.41)(1994=0.39)(1993=0.37)(1992=0.35)(1991=0.33)(1990=0.32) ///
(1989=0.3)(1988=0.28)(1987=0.26)(1986=0.25)(1985=0.23)(1984=0.22)(1983=0.2) ///
(1982=0.18)(1981=0.17)(1980=0.15)(1979=0.14)(1978=0.13)(1977=0.11)(1976=0.1) ///
(1975=0.09)(1974=0.08)(1973=0.08)(1972=0.07), gen(scale)

*Change to million $ as scale
replace defns_d = (defns_d/scale)/1000
replace fgnaid_d = (fgnaid_d/scale)/1000
replace space_d = (space_d/scale)/1000
replace envir_d = (envir_d/scale)/1000
replace welf_d = (welf_d/scale)/1000
replace cities_d = (cities_d/scale)/1000
replace cities2_d = (cities2_d/scale)/1000
replace educ_d = (educ_d/scale)/1000
replace health_d = (health_d/scale)/1000

*A “social” dimension of preferences
factor genvr gcity geduc ghealth
predict gsocial

order id_ year gblack gdefns gfaid groad gtrans gparks gspacey genvry gcityy gcrimy gdrugy geducy gblacky gdefnsy gfaidy geduc gdrug gcrim ghealth gwelf gsocs ghealthy gspace genvr gcity gpoory gsocial

*Collapse
collapse gblack-cci, by(year)


*Linear Interpolation
ipolate gblack year, g(gblacki)
ipolate gdefns year, g(gdefnsi)
ipolate gfaid year, g(gfaidi)
ipolate groad year, g(groadi)
ipolate gtrans year, g(gtransi)
ipolate gparks year, g(gparksi)
ipolate gspace year, g(gspacei)
ipolate gspacey year, g(gspaceyi)
ipolate genvr year, g(genvri)
ipolate genvry year, g(genviryi)
ipolate gcity year, g(gcityi)
ipolate gcityy year, g(gcityyi)
ipolate gcrim year, g(gcrimi)
ipolate gcrimy year, g(gcrimyi)
ipolate gdrug year, g(gdrugi)
ipolate gdrugy year, g(gdrugyi)
ipolate gwelf year, g(gwelfi)
ipolate geduc year, g(geduci)
ipolate geducy year, g(geducyi)
ipolate gblacky year, g(gblackyi)
ipolate gdefnsy year, g(gdefnsyi)
ipolate gfaidy year, g(gfaidyi)
ipolate ghealth year, g(ghealthi)
ipolate ghealthy year, g(ghealthyi)
ipolate gsocs year, g(gsocsi)
ipolate gpoory year, g(gpooryi)
ipolate gsocial year, g(gsociali)

// Create lagged variables

*** Opinion
*1 year
sort year
foreach var of varlist gblack - gsocial {
gen `var'lag1=`var'[_n-1]
}

sort year
foreach var of varlist gblacki - gsociali {
gen `var'lag1=`var'[_n-1]
}

*2 year
sort year
foreach var of varlist gblack - gsocial {
gen `var'lag2=`var'[_n-2]
}

sort year
foreach var of varlist gblacki - gsociali {
gen `var'lag2=`var'[_n-2]
}

*** Spending

*Add a social spending sum
gen social_d = health_d+envir_d+cities_d+educ_d

*1 year
sort year
foreach var of varlist defns_d - health_p{
gen `var'lag1=`var'[_n-1]
}

gen social_dlag1 = social_d[_n-1]
*2 year
sort year
foreach var of varlist defns_d - health_p {
gen `var'lag2=`var'[_n-2]
}

gen social_dlag2 = social_d[_n-2]

*Change score for DV
gen defnsD = defns_d-defns_dlag1
gen fgnaidD = fgnaid_d-fgnaid_dlag1
gen spaceD = space_d-space_dlag1
gen envirD = envir_d-envir_dlag1
gen welfD = welf_d-welf_dlag1
gen citiesD = cities_d-cities_dlag1
gen cities2D = cities2_d-cities2_dlag1
gen educD = educ_d-educ_dlag1
gen healthD = health_d-health_dlag1
gen socialD = social_d-social_dlag1

*Lag partisan vars
clonevar rpc_cong = cpds_lcon
drop cpds_lcon

gen rpc_execlag1 = rpc_exec[_n-1]
gen rpc_conglag1 = rpc_cong[_n-1]

*Combined Republican Control
egen rpc_totlag1 = rowmean(rpc_execlag1 rpc_conglag1)
label variable rpc_totlag1 "Avg strength of Republicans - exec & cong"

*Counter
gen counter = year-1971
gen counter2 = (year-1971)^2

*Social Spending as %
gen social_p = health_p+envir_p+cities_p+educ_p
sort year
gen social_plag1 = social_p[_n-1]

*Labels
label var gdefns "Spend on military, armaments and defense"
label var gdefnsy "Spend on national defense"
label var gspace "Spend on the space exploration program"
label var gspacey "Spend on space exploration"
label var gcity "Spend on assistance to big cities"
label var gcityy "Spend on solving the problems of big cities"
label var genvr "Spend on improving and protecting the environment"
label var genvry "Spend on the environment"
label var ghealth "Spend on improving and protecting nat's health"
label var ghealthy "Spend on health"
label var gcrim "Spend on halting rising crime rate"
label var gcrimy "Spend on law enforcement"
label var geduc "Spend on improving nat's education system"
label var geducy "Spend on education"
label var gwelf "Spend on welfare"
label var gpoory "Spend on assisting the poor"
label var gsocs "Spend on social security"
label var gfaid "Spend on foreign aid"
label var gfaidy "Spend on assistance to other countries"
label var gsocial "Spend on envir, health, cities and ed scale"
label var cci "Consumer confidence index"
label var social_p "Social spending scale (envir, cities, education)"
label var gsocial "Public social spending prefs scale"


label var gsociali "Social Spending Preferences"
label var gsocialilag1 "Social Spending Preferences, t-1"

label var social_p "Social Spending as % of Total Budget"
label var social_plag1 "Social Spending as % of Budget, t-1"



save "data/recip.dta", replace
