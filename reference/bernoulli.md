# Implemented link functions for the mixture cure rate model

This function is used to specify different link functions for the count
component of the mixture cure rate model.

## Usage

``` r
bernoulli(link = "logit")
```

## Arguments

- link:

  desired link function; currently implemented links are: logit, probit,
  cloglog and cauchy.

## Value

A list containing the codes associated with the count distribution
assumed for the latent variable N and the chosen link.
