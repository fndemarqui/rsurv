# Implemented link functions for the promotion time cure rate model with negative binomial distribution

This function is used to specify different link functions for the count
component of the promotion time cure rate model.

## Usage

``` r
negbin(zeta = stop("'theta' must be specified"), link = "log")
```

## Arguments

- zeta:

  The known value of the additional parameter.

- link:

  desired link function; currently implemented links are: log, identity
  and sqrt.

## Value

A list containing the codes associated with the count distribution
assumed for the latent variable N and the chosen link.
