// Nikkhil Dev Murthy //
// Data Management in STATA // 
// Public Affairs and Community Development //
// Problem Set 2 //
// Spring 2021 //

cd /Users/nikhildev/Desktop/Data_Management        

set matsize 800 
version 16
set more off
clear

// This portion is to formate and edit the data to merge properly // 

use http://www.stata-press.com/data/r8/census.dta
replace state = "South Carolina" in 40
replace state = "South Dakota" in 41
replace state = "West Virginia" in 48  
replace state = "North Carolina" in 33
replace state = "North Dakota" in 34


save test_8, replace

clear

import delimited "/Users/nikhildev/Desktop/Data_Management/carter_v_reagan.csv", encoding(UTF-8) 

rename v1 state

rename v2 winner

// Replace // 

replace winner= "1" if winner=="Reagan" 

replace winner= "0" if winner=="Carter"

destring winner, generate(winner_n) force //destrings the winner variable// 
replace state = strtrim(state) 

merge 1:1 state using /Users/nikhildev/Desktop/Data_Management/test_8.dta

// Recode // 

recode winner_n (.=0)
recode pop (.=0)

tab region

describe
summarize
codebook

// Drop // 

drop if region==2|region==3|region==4

summarize // Reagan won 8 out of the 9 states in the northeast //

drop pop5_17

save "/Users/nikhildev/Desktop/Data_Management/northeast_1980.dta", replace
 
clear


import delimited "/Users/nikhildev/Desktop/Data_Management/carter_v_reagan.csv", encoding(UTF-8) 

rename v1 state

rename v2 winner

replace winner= "1" if winner=="Reagan"

replace winner= "0" if winner=="Carter"

destring winner, generate(winner_n) force //destrings the winner variable// 
replace state = strtrim(state) 

merge 1:1 state using /Users/nikhildev/Desktop/Data_Management/test_8.dta

recode winner_n (.=0)
recode pop (.=0)

// Collapse //

collapse (mean) pop, by(state winner_n)

// Egen // 

egen avg_pop=mean(pop) // Average population = 4344375 // 

bys winner_n: egen avg_popm=mean(pop) 

/*  Average population of a state in which Reagan won is 4733862 and for Carter
is 2202193 */ 


tab avg_popm

// End of Do File // 









