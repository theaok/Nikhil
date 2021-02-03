//Problem Set 1//
//Data Management, Spring//
//Nikkhil Dev Murthy, Public Affairs and Community Development// 

/* I am planning to study elections, however, I have not confirmed which one yet
but I am leaning toward the 1980 Presidenital Election. So for this problem set 
I am looking at 1980 Census Data
 */ 
 
 //like this cd at first; but should do like yanan that preamble, notably which version of stata
 cd /Users/nikhildev/Desktop/Data_Management
 
 use http://www.stata-press.com/data/r8/census.dta, clear
 describe
 list // Provides important statistics on each state in table format //
 summarize // I use this command to make sure the numeber of observations are equal //
 //i meant sth more substantive like what you see 
 
 export excel using "census_1980", firstrow(variables)
 export delimited using "census_1980", replace
 export sasxport8 "census_1980"
 
 save //???
 
 //pretty good!
 
 // End of Do File //
