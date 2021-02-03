//Problem Set 1//
//Data Management, Spring//
//Nikkhil Dev Murthy, Public Affairs and Community Development// 

/* I am planning to study elections, however, I have not confirmed which one yet
but I am leaning toward the 1980 Presidenital Election. So for this problem set 
I am looking at 1980 Census Data
 */ 
 
 cd /Users/nikhildev/Desktop/Data_Management
 
 use http://www.stata-press.com/data/r8/census.dta
 describe
 list // Provides important statistics on each state in table format //
 summarize // I use this command to make sure the numeber of observations are equal //
 
 
 export excel using "census_1980", firstrow(variables)
 export delimited using "census_1980", replace
 export sasxport8 "census_1980"
 
 save
 
 // End of Do File //
