/* import csv data, which has been uploaded to SAS Studio server */

/* %let path=~/Insurance; */
/* libname proj_ins "&path/data"; */

proc import dbms=csv out=work.insurance  replace
	datafile='/home/u62058430/Insurance/data/insurance.csv';
	getnames=YES;

run;

/* a quick look at the raw data, examining basic descriptives of variables by getting frequency and histogram */
proc contents data=insurance;
run;

proc print data=insurance (obs=10);
run;

proc freq data=insurance;
	tables sex children smoker region /nocum;
run;

proc univariate data=insurance;
	var age bmi charges;
	hist age bmi charges;
run;

/* Check out the correlation among continous variables. */
proc corr data=insurance;
	var age children bmi charges;
run;

/* Check out distributions of charges by region */
proc sgpanel data=insurance;
	title 'Insurance Charges by Patient Regions';
  	panelby region / layout=rowlattice;
  	histogram charges;
run; 
title;


/* To find out what determines insurance charges, we run a linear regression on charges over continous variables, age and bmi. */
proc reg data=insurance;
	model charges = age children bmi;
run;

/* Create dummy variables for categorical variables with 2 categories */
data copy_insurance;
	set insurance;
	if sex='male' then gender=1;
	else gender=0;
	if smoker='yes' then smoke_or_not=1;
	else smoke_or_not=0;
run;

/* Run a linear model on insurance charges over both continous and categorical variables.	 */
proc reg data=copy_insurance;
  model charges = age gender smoke_or_not children bmi;
run;
quit;
