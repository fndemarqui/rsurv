
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rsurv

<!-- badges: start -->

[![R-CMD-check](https://github.com/fndemarqui/rsurv/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/fndemarqui/rsurv/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The R package rsurv is aimed for general survival data simulation
purposes. The package is built under a new approach to simulate survival
data that depends deeply on the use of dplyr verbs. The proposed package
allows simulations of survival data from a wide range of regression
models, including accelerated failure time (AFT), proportional hazards
(PH), proportional odds (PO), accelerated hazard (AH), Yang and Prentice
(YP), and extended hazard (EH) models. The package rsurv also stands out
by its ability to generate survival data from an unlimited number of
baseline distributions provided that an implementation of the quantile
function of the chosen baseline distribution is available in R. Another
nice feature of the package rsurv lies in the fact that linear
predictors are specified via a formula-based approach, facilitating the
inclusion of categorical variables and interaction terms. The functions
implemented in the package rsurv can also be employed to simulate
survival data with more complex structures, such as survival data with
different types of censoring mechanisms, survival data with cure
fraction, survival data with random effects (frailties), multivariate
survival data, and competing risks survival data. Details about the R
package rsurv can be found in Demarqui (2024)
\<doi.org/10.48550/arXiv.2406.01750\>.

## Installation

You can install the released version of rsurv from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("rsurv")
```

You can install the development version of rsurv like so:

``` r
# install.packages("devtools")
devtools::install_github("fndemarqui/rsurv")
```
