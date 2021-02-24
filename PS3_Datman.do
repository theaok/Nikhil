// Nikkhil Dev Murthy //
// Data Management in STATA // 
// Public Affairs and Community Development //
// Problem Set 3 //
// Spring 2021 //


/* The purpose of this project is to identify the factors most useful for 
understanding voting behavior in presidenital elections in the United States. 
In this part of the project, I am focusing on the 1980 United States 
Presidential Election. I aim to find new empirical evidence to explain the 
results of the 1980 election by studying and testing a variety of factor from 
education spending to immigration against the results (popular vote). */ 


 
cd /Users/nikhildev/Desktop/Data_Management        

set matsize 800 
version 16
set more off
clear


use http://www.stata-press.com/data/r8/census.dta 

// I was unable to find 1980 Census data, which is why I am still using the above dataset // 

replace state = "South Carolina" in 40
replace state = "South Dakota" in 41
replace state = "West Virginia" in 48  
replace state = "North Carolina" in 33
replace state = "North Dakota" in 34


save test_8, replace

clear

insheet using https://raw.githubusercontent.com/nikhildevmurthy/Nikhil/main/carter_v_reagan.csv
// Source: New York Times/ Politico and https://www.presidency.ucsb.edu/statistics/elections/1980//

rename v1 state

rename v2 winner

// Replace // 

replace winner= "1" if winner=="Reagan" 

replace winner= "0" if winner=="Carter"

destring winner, generate(winner_n) force //destrings the winner variable// 
replace state = strtrim(state) 

// First Merge //

merge 1:1 state using /Users/nikhildev/Desktop/Data_Management/test_8.dta
// "Test_8" is the edited version of the 1980 census data //

tab _merge 

/* Two obeservations in the master did not match because one is labeled "State" 
and the other is "District of Columbia" */  

summarize // Reagan won 8 out of the 9 states in the northeast //

// Second Merge // 

drop _merge

merge 1:1 state using /Users/nikhildev/Desktop/Data_Management/test10.dta

/*Test10 is a dataset with a collection of spending by the Department of 
Education by state. Source: https://www2.ed.gov/about/overview/budget/history/index.html */ 

tab _merge 

/* There are 10 unmatched from using. This is because the data from the Department 
of Education has data on United States territories and a few options like "others", which
is absent from the data in the master */

drop _merge

save prob_set_3_1, replace 

clear

// Third Merge // 

insheet using https://raw.githubusercontent.com/nikhildevmurthy/Nikhil/main/Book3.csv

/* Voter turnout data from the University of Florida. Source https://docs.google.com/spreadsheets/d/1or-N33CpOZYQ1UfZo0h8yGPSyz0Db-xjmZOXg3VJi-Q/edit#gid=1670431880
*/  

merge 1:1 state using /Users/nikhildev/Desktop/Data_Management/prob_set_3_1.dta 

/* From master: United States is an observation. And from using: US Territories */

tab _merge 

save prob_set_3_2, replace

// Fourth Merge // 

use test_8

decode region, generate(region_n)

save 1980_edited_census, replace 

clear

insheet using https://raw.githubusercontent.com/nikhildevmurthy/Nikhil/main/Book6.csv


/* The above dataset consists of immigration data in major metro areas and regions
source: https://www.issuelab.org/resources/7352/7352.pdf */ 

rename region region_n

merge 1:m region_n using 1980_edited_census 

/* From master 2 unmatched because regions like "midwest" is not avialabe is using. 
And for using 21 were not mathched because regions like N Central are not available in master */

drop _merge

save merge4, replace

// Fifth Merge // // Reshape // 

clear

insheet using https://raw.githubusercontent.com/nikhildevmurthy/Nikhil/main/Book7.csv


/* education data for 1981 from the Department of Education 
source: https://www2.ed.gov/about/overview/budget/history/index.html */ 

save fin_merge, replace

use prob_set_3_2
drop _merge

merge 1:1 state using fin_merge

/* Three unmatched from Master because of obervations like "other" "United States"
and "State" */

rename education_spending education_spending_1980

rename educ_spending_1981 education_spending_1981

reshape long education_spending_, i(state) j(population_year)


////////////////////////END OF DO FILE /////////////////////////////////////////
