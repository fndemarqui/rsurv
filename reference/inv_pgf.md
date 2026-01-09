# Inverse of the probability generating function

This function is used to specify different link functions for the count
component of the promotion time cure rate model

## Usage

``` r
inv_pgf(formula, incidence = "bernoulli", kappa = NULL, zeta = NULL, data, ...)
```

## Arguments

- formula:

  formula specifying the linear predictor for the incidence sub-model.

- incidence:

  the desired incidence model.

- kappa:

  vector of regression coefficients associated with the incidence
  sub-model.

- zeta:

  extra negative-binomial parameter.

- data:

  a data.frame containing the explanatory covariates passed to the
  formula.

- ...:

  further arguments passed to other methods.

## Value

A vector with the values of the inverse of the desired probability
generating function.
