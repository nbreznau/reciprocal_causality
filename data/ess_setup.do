*Appendix C. ESS Data Set-Up

*Wave 4 – set up
use "ess4e04.dta", clear

gen countryx = .
replace countryx = 56 if cntry=="BE"
replace countryx = 100 if cntry=="BG"
replace countryx=756 if cntry=="CH"
replace countryx=196 if cntry=="CY"
replace countryx=203 if cntry=="CZ"
replace countryx=276 if cntry=="DE"
replace countryx=208 if cntry=="DK"
replace countryx=233 if cntry=="EE"
replace countryx=724 if cntry=="ES"
replace countryx=246 if cntry=="FI"
replace countryx=250 if cntry=="FR"
replace countryx=826 if cntry=="GB"
replace countryx=300 if cntry=="GR"
replace countryx=191 if cntry=="HR"
replace countryx=348 if cntry=="HU"
replace countryx=372 if cntry=="IE"
replace countryx=376 if cntry=="IL"
replace countryx=428 if cntry=="LV"
replace countryx=528 if cntry=="NL"
replace countryx=578 if cntry=="NO"
replace countryx=616 if cntry=="PL"
replace countryx=620 if cntry=="PT"
replace countryx=642 if cntry=="RO"
replace countryx=643 if cntry=="RU"
replace countryx=752 if cntry=="SE"
replace countryx=705 if cntry=="SI"
replace countryx=703 if cntry=="SK"
replace countryx=792 if cntry=="TR"
replace countryx=804 if cntry=="UA"
sort countryx
*Append Austrian Data
append using "C:\Data\ess4at_original.dta"
*E and W Germany
replace countryx=275 if intewde==1
label define c 40 "Austria" 56 "Belgium" 100 "Bulgaria" 756 "Switzerland" 372 "Ireland" 203  "Czech Rep" 275 "E.Germany" 276 "W.Germany" 208 "Denmark" 233 "Estonia" 300 "Greece" 191 "Croatia" 348 "Hungary" 428 "Latvia" 578 "Norway" 620 "Portugal" 703 "Slovakia" 250 "France" 826 "Britain" 376 "Israel" 528 "Netherlands" 752 "Sweden" 246 "Finland" 616 "Poland" 705 "Slovenia" 642 "Romania" 792 "Turkey" 804 "Ukraine" 643 "Russia" 196 "Cyprus" 724 "Spain"
label values countryx c

numlabel c, add

gen year=2008
keep countryx year gvslvol gvslvue gvcldcr
sort countryx
preserve
*Wave 8 – Set up
use "C:\data\ESS8e01.dta", clear
gen countryx = .
replace countryx = 40 if cntry=="AT"
replace countryx = 56 if cntry=="BE"
replace countryx = 100 if cntry=="BG"
replace countryx=756 if cntry=="CH"
replace countryx=196 if cntry=="CY"
replace countryx=203 if cntry=="CZ"
replace countryx=276 if cntry=="DE"
replace countryx=208 if cntry=="DK"
replace countryx=233 if cntry=="EE"
replace countryx=724 if cntry=="ES"
replace countryx=246 if cntry=="FI"
replace countryx=250 if cntry=="FR"
replace countryx=826 if cntry=="GB"
replace countryx=300 if cntry=="GR"
replace countryx=191 if cntry=="HR"
replace countryx=348 if cntry=="HU"
replace countryx=372 if cntry=="IE"
replace countryx=376 if cntry=="IL"
replace countryx=428 if cntry=="LV"
replace countryx=528 if cntry=="NL"
replace countryx=578 if cntry=="NO"
replace countryx=616 if cntry=="PL"
replace countryx=620 if cntry=="PT"
replace countryx=642 if cntry=="RO"
replace countryx=643 if cntry=="RU"
replace countryx=752 if cntry=="SE"
replace countryx=705 if cntry=="SI"
replace countryx=703 if cntry=="SK"
replace countryx=792 if cntry=="TR"
replace countryx=804 if cntry=="UA"
sort countryx
gen year=2016
replace countryx=275 if intewde==1
label define c 40 "Austria" 56 "Belgium" 100 "Bulgaria" 756 "Switzerland" 372 "Ireland" 203  "Czech Rep" 275 "E.Germany" 276 "W.Germany" 208 "Denmark" 233 "Estonia" 300 "Greece" 191 "Croatia" 348 "Hungary" 428 "Latvia" 578 "Norway" 620 "Portugal" 703 "Slovakia" 250 "France" 826 "Britain" 376 "Israel" 528 "Netherlands" 752 "Sweden" 246 "Finland" 616 "Poland" 705 "Slovenia" 642 "Romania" 792 "Turkey" 804 "Ukraine" 643 "Russia" 196 "Cyprus" 724 "Spain"
label values countryx c
numlabel c, add
sort countryx
drop if countryx==.
keep countryx year gvslvol gvslvue gvcldcr
save "recipess.dta", replace
*Merge
restore
append using "recipess.dta"
numlabel, add force
*Collapse/Merge
recode gvslvol gvslvue gvcldcr (88=4.5)(77 99=.), gen(govold govun govchild)
gen cyear = (countryx*10000)+(year)
*Remove countries not yet in both waves
bysort countryx: egen drop=mean(year)
drop if drop==2008
collapse countryx year govold govun govchild, by(cyear)
save "recipess.dta", replace
