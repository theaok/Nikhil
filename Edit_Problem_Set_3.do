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



********************************************************************************
****************************** References **************************************
********************************************************************************
/*http://www.stata-press.com/data/r8/census.dta
// New York Times/ Politico – Data on 1980 election results // 
https://www2.ed.gov/about/overview/budget/history/index.html // 1980 – 1981
https://docs.google.com/spreadsheets/d/1or-N33CpOZYQ1UfZo0h8yGPSyz0Db-xjmZOXg3VJi-Q/edit#gid=1670431880
https://www.issuelab.org/resources/7352/7352.pdf // I manually entered the data needed from the pdf // */


*************************** Introduction ***************************************
 
cd /Users/nikhildev/Desktop/Data_Management        

set matsize 800 
version 16
set more off
clear

********************************************************************************
****************** Editing and formatting the data for use later ****************
********************************************************************************

***** Code for formating "formatted_census_data" *******************************

use http://www.stata-press.com/data/r8/census.dta 
// I was unable to find 1980 Census data, which is why I am still using the above dataset // 
replace state = "South Carolina" if state=="S. Carolina"
replace state = "South Dakota" if state=="S. Dakota"
replace state = "West Virginia" if state=="W. Virginia"
replace state = "North Carolina" if state=="N. Carolina"
replace state = "North Dakota" if state=="N. Dakota" 
save formatted_census_data, replace
clear



*** Code for formatting "edu_1980_spend" ***************************************
import delimited "/Users/nikhildev/Desktop/Data_Management/Education_Spending.csv", encoding(UTF-8) 
drop in 1
rename v1 state
rename v2 education_spending
save educ_1980_spend, replace 
clear




****** Formatting for fourth Merge *********************************************
clear
use formatted_census_data.dta
decode region, generate(region_n)
save 1980_census_data, replace 
clear



****** Formatting for Fifth Merge **********************************************
insheet using https://raw.githubusercontent.com/nikhildevmurthy/Nikhil/main/Book7.csv
/* education data for 1981 from the Department of Education 
source: https://www2.ed.gov/about/overview/budget/history/index.html */ //1980 – 1981 dataset // 
save fifth_merge, replace





**** Code for formatting using dataset *****************************************
clear
insheet using https://raw.githubusercontent.com/nikhildevmurthy/Nikhil/main/carter_v_reagan.csv
/// Source: New York Times/ Politico and https://www.presidency.ucsb.edu/statistics/elections/1980/////
/*(I mannually entered most of the data since the data is not comprehensive.) In other words, I looked at the winners of each state and manually entered them */
rename v1 state
rename v2 winner
replace winner= "1" if winner=="Reagan" // I did this because I wanted to convert the winner variable from string to int // 
replace winner= "0" if winner=="Carter"
destring winner, generate(winner_n) force //destrings the winner variable// 
replace state = strtrim(state) 
drop in 1 // I did this because the first row had observations "State" and "winner" // 



********************************************************************************
************************** First Merge *****************************************
********************************************************************************

merge 1:1 state using formated_census_data 
tab _merge 
/* One obeservations in the master did not match because using does not have data on "District of Columbia" */
drop if _merge==1
drop _merge
/////////////////////////////// Analyzing the Data ////////////////////////////
//drop if region==2|region==3|region==4// //This is the code i used to get the below statistic // 
// summarize // Reagan won 8 out of the 9 states in the northeast //
////////////////////////////////////////////////////////////////////////////////
save firstmerge, replace



********************************************************************************
************************** Second Merge *****************************************
********************************************************************************

merge 1:1 state using educ_1980_spend 
/*edu_spend_1980 is a dataset with a collection of spending by the Department of 
Education by state. Source: https://www2.ed.gov/about/overview/budget/history/index.html */
tab _merge 
/* There are 11 unmatched from using. This is because the data from the Department 
of Education has data on United States territories and a few options like "others", which
is absent from the data in the master */ 

/////////////// Code for analysis //////////////////////////////////////////////
/* keep in 1/51
destring ed, gen(es)ignore(",")
format es %10.2f
sum es
di %12.0f `r(mean)'
sum es
di %12.2f `r(mean)'
sum es
di %12.0f `r(mean)'
In 1980 the federal government spend an average of 59788635 on education */
drop if _merge==2
drop _merge
save second_merge, replace
clear




********************************************************************************
************************** Third Merge *****************************************
********************************************************************************

insheet using https://raw.githubusercontent.com/nikhildevmurthy/Nikhil/main/Book3.csv
/* Voter turnout data from the University of Florida. Source https://docs.google.com/spreadsheets/d/1or-N33CpOZYQ1UfZo0h8yGPSyz0Db-xjmZOXg3VJi-Q/edit#gid=1670431880
*/  
merge 1:1 state using second_merge
tab _merge
/* From master 2 are missing because the United States is an observation and District of Columbia */
drop if _merge==1
save third_merge, replace






********************************************************************************
************************** Fourth Merge ****************************************
********************************************************************************
clear
insheet using https://raw.githubusercontent.com/nikhildevmurthy/Nikhil/main/Book6.csv
/* The above dataset consists of immigration data in major metro areas and regions
source: https://www.issuelab.org/resources/7352/7352.pdf */ 
rename region region_n
merge 1:m region_n using 1980_census_data
drop _merge
/* From master 2 unmatched because regions like "midwest" is not avialabe is using. 
And for using 21 unmathched because regions like N Central are not available in master */
save fourth_merge, replace 




********************************************************************************
************************** Fifth Merge / Reshape *******************************
********************************************************************************
clear
use third_merge
drop _merge
merge 1:1 state using fifth_merge
/* 10 unmatched from Using because using has data on US Territories */ 
rename education_spending education_spending_1980
rename educ_spending_1981 education_spending_1981
reshape long education_spending_, i(state) j(population_year)




////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
/////////////////////////////END OF DO-FILE/////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
