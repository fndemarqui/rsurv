# Frailties random generation

The frailty function for adding a simple random effects term to the
linear predictor of a given survival regression model.

## Usage

``` r
rfrailty(
  cluster,
  frailty = c("gamma", "gaussian", "ps"),
  sigma = 1,
  alpha = NULL,
  ...
)
```

## Arguments

- cluster:

  a vector determining the grouping of subjects (always converted to a
  factor object internally.

- frailty:

  the frailty distribution; current implementation includes the gamma
  (default), lognormal and positive stable (ps) distributions.

- sigma:

  standard deviation assumed for the frailty distribution; sigma = 1 by
  default; this value is ignored for positive stable (ps) distribution.

- alpha:

  stability parameter of the positive stable distribution; alpha must
  lie in (0,1) interval and an NA is return otherwise.

- ...:

  further arguments passed to other methods.

## Value

a vector with the generated frailties.
