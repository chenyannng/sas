/* import csv data, which has been uploaded to SAS Studio server */

/* %let path=~/Insurance; */
/* libname proj_ins "&path/data"; */


proc import dbms=csv out=insurance  replace
  datafile='/home/u62058430/Insurance/data/insurance.csv';
  getnames=YES;
run;

/* a quick look at the raw data, examining basic descriptives of variables by getting frequency and histogram */
proc print data=insurance (obs=10);

run;

proc freq data=insurance;
	tables sex*(children smoker region);
run;

proc univariate data=insurance;
	var age bmi charges;
	hist age bmi charges;
run;

/* Check out the correlation among continous variables. 
We see that each pair has a significant positive correlation */
proc corr data=insurance;
	var age bmi charges;
run;

/* To find out what determines insurance charges, we run a linear regression on charges over continous variables, age and bmi. */
proc reg data=insurance;
	model charges = bmi;
run;
