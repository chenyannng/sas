/* Create dummy variables with glmselect*/
%let DSIn    = insurance;     /* name of input data set */
%let VarList = sex smoker; /* name of categorical variables */

proc freq data=&DSIn;
    tables &VarList /nocum;
run;
 
/* 1. add a fake response variable */
data AddFakeY / view=AddFakeY;
set &DSIn;
_Y = 0;
run;
 
/* 2. Create the dummy variables as a GLM design matrix. Include the original variables, if desired */
proc glmselect data=AddFakeY NOPRINT outdesign(addinputvars)=Want(drop=_Y);
class      &VarList;   /* list the categorical variables here */
model _Y = &VarList /  noint selection=none;
run;

/* show the names of the dummy variables */
proc contents varnum data=Want(keep=&_GLSMOD);
ods select Position;
run;
