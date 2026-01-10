# Changelog

## rsurv 0.0.1

CRAN release: 2024-06-06

- Initial CRAN submission.

## rsurv 0.0.2

CRAN release: 2024-10-25

- dplyr package has been moved from Depends to Imports field;
- Package argument has been added to the function qsurv() to ensure that
  the right function from the right package is found depending on the
  search path;
- Function inv_pgf() was reimplemented to allow the use of the
  stats::poisson() function in the the incidence argument;
- the r\*reg() functions now make sure that there is always a baseline
  distribution, like in the function survival::coxph().

## rsurv 0.0.3

- The functions `r*reg()` now returns the vector of failure times
  accompanied by a set of attributes (call, model.matrix, and vector of
  regression coefficients);
- The functions `r*reg()` now can simulate left, right and
  double-truncated survival data.
- Implementation of fatigue (Birnbaum-Saunders), Rayleigh, and
  loglogistic distributions.
