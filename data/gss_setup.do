*Do-file syntax for importing GSS data
#delimit ;

   infix
      year     1 - 20
      natrace  21 - 40
      natarms  41 - 60
      nataid   61 - 80
      natroad  81 - 100
      natmass  101 - 120
      natpark  121 - 140
      natspacy 141 - 160
      natenviy 161 - 180
      natcityy 181 - 200
      natcrimy 201 - 220
      natdrugy 221 - 240
      nateducy 241 - 260
      natracey 261 - 280
      natarmsy 281 - 300
      nataidy  301 - 320
      nateduc  321 - 340
      natdrug  341 - 360
      natcrime 361 - 380
      id_      381 - 400
      natheal  401 - 420
      natfare  421 - 440
      natsoc   441 - 460
      nathealy 461 - 480
      spmentl  481 - 500
      govmentl 501 - 520
      sphlth   521 - 540
      spretire 541 - 560
      spunemp  561 - 580
      sphlthkd 581 - 600
      ballot   601 - 620
      natspac  621 - 640
      natenvir 641 - 660
      natcity  661 - 680
      natfarey 681 - 700
using GSS.dat;

label variable year     "Gss year for this respondent                       ";
label variable natrace  "Improving the conditions of blacks";
label variable natarms  "Military, armaments, and defense";
label variable nataid   "Foreign aid";
label variable natroad  "Highways and bridges";
label variable natmass  "Mass transportation";
label variable natpark  "Parks and recreation";
label variable natspacy "Space exploration -- version y";
label variable natenviy "The environment -- version y";
label variable natcityy "Assistance to big cities -- version y";
label variable natcrimy "Law enforcement -- version y";
label variable natdrugy "Drug rehabilitation -- version y";
label variable nateducy "Education -- version y";
label variable natracey "Assistance to blacks -- version y";
label variable natarmsy "National defense -- version y";
label variable nataidy  "Assistance to other countries -- ver y";
label variable nateduc  "Improving nations education system";
label variable natdrug  "Dealing with drug addiction";
label variable natcrime "Halting rising crime rate";
label variable id_      "Respondent id number";
label variable natheal  "Improving & protecting nations health";
label variable natfare  "Welfare";
label variable natsoc   "Social security";
label variable nathealy "Health -- version y";
label variable spmentl  "Govt spending on health";
label variable govmentl "Should govt provide health care for mental illness";
label variable sphlth   "Govt spending on health";
label variable spretire "Govt spending on retirement benefits";
label variable spunemp  "Govt spending on unemployment benefits";
label variable sphlthkd "Spending for health care";
label variable ballot   "Ballot used for interview";
label variable natspac  "Space exploration program";
label variable natenvir "Improving & protecting environment";
label variable natcity  "Solving problems of big cities";
label variable natfarey "Assistance to the poor -- version y";


label define gsp001x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp002x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp003x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp004x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp005x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp006x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp007x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp008x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp009x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp010x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp011x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp012x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp013x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp014x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp015x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp016x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp017x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp018x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp019x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp020x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp021x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp022x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp023x
   9        "No answer"
   8        "Cant choose"
   5        "Spend much less"
   4        "Spend less"
   3        "Spend the same as now"
   2        "Spend more"
   1        "Spend much more"
   0        "Not applicable"
;
label define gsp024x
   9        "No answer"
   8        "Cant choose"
   4        "Definitely should not be"
   3        "Probably should not be"
   2        "Probably should be"
   1        "Definitely should be"
   0        "Not applicable"
;
label define gsp025x
   9        "No answer"
   8        "Cant choose"
   5        "Spend much less"
   4        "Spend less"
   3        "Spend same"
   2        "Spend more"
   1        "Spend much more"
   0        "Not applicable"
;
label define gsp026x
   9        "No answer"
   8        "Cant choose"
   5        "Spend much less"
   4        "Spend less"
   3        "Spend same"
   2        "Spend more"
   1        "Spend much more"
   0        "Not applicable"
;
label define gsp027x
   9        "No answer"
   8        "Cant choose"
   5        "Spend much less"
   4        "Spend less"
   3        "Spend same"
   2        "Spend more"
   1        "Spend much more"
   0        "Not applicable"
;
label define gsp028x
   9        "No answer"
   8        "Cant choose"
   5        "Spend much less"
   4        "Spend less"
   3        "Spend same"
   2        "Spend more"
   1        "Spend much more"
   0        "Iap-no issp"
;
label define gsp029x
   4        "Ballot d"
   3        "Ballot c"
   2        "Ballot b"
   1        "Ballot a"
   0        "Not applicable"
;
label define gsp030x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp031x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp032x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;
label define gsp033x
   9        "No answer"
   8        "Don't know"
   3        "Too much"
   2        "About right"
   1        "Too little"
   0        "Not applicable"
;


label values natrace  gsp001x;
label values natarms  gsp002x;
label values nataid   gsp003x;
label values natroad  gsp004x;
label values natmass  gsp005x;
label values natpark  gsp006x;
label values natspacy gsp007x;
label values natenviy gsp008x;
label values natcityy gsp009x;
label values natcrimy gsp010x;
label values natdrugy gsp011x;
label values nateducy gsp012x;
label values natracey gsp013x;
label values natarmsy gsp014x;
label values nataidy  gsp015x;
label values nateduc  gsp016x;
label values natdrug  gsp017x;
label values natcrime gsp018x;
label values natheal  gsp019x;
label values natfare  gsp020x;
label values natsoc   gsp021x;
label values nathealy gsp022x;
label values spmentl  gsp023x;
label values govmentl gsp024x;
label values sphlth   gsp025x;
label values spretire gsp026x;
label values spunemp  gsp027x;
label values sphlthkd gsp028x;
label values ballot   gsp029x;
label values natspac  gsp030x;
label values natenvir gsp031x;
label values natcity  gsp032x;
label values natfarey gsp033x;

save "data/gss_cleaned.dta"
