# rsurv 0.0.1

* Initial CRAN submission.

# rsurv 0.0.2

* dplyr package has been moved from Depends to Imports field;
* package argument has been added to the function qsurv() to ensure that the right function from the right package is found depending on the search path;
* Function inv_pgf() was reimplemented to allow the use of the stats::poisson() function in the the incidence argument.
* the r*reg() functions now make sure that there is always a baseline distribution, like in the function survival::coxph().


