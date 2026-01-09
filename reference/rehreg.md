# Random generation from extended hazard models

Function to generate a random sample of survival data from extended
hazard models.

## Usage

``` r
rehreg(
  u,
  formula,
  baseline,
  beta,
  phi,
  dist = NULL,
  package = NULL,
  lwr = 0,
  upr = Inf,
  data,
  ...
)
```

## Arguments

- u:

  a numeric vector of quantiles.

- formula:

  formula specifying the linear predictors.

- baseline:

  the name of the baseline survival distribution.

- beta:

  vector of regression coefficients.

- phi:

  vector of regression coefficients.

- dist:

  an alternative way to specify the baseline survival distribution.

- package:

  the name of the package where the assumed quantile function is
  implemented.

- lwr:

  left-truncation time (default to 0 in the absence of left-truncation).

- upr:

  right-truncation time (default to Inf in the absence of
  right-truncation).

- data:

  data frame containing the covariates used to generate the survival
  times.

- ...:

  further arguments passed to other methods.

## Value

a numeric vector containing the generated random sample.

## Examples

``` r
library(rsurv)
library(dplyr)
set.seed(123)
n <-  1000
simdata <- data.frame(
  age = rnorm(n),
  sex = sample(c("f", "m"), size = n, replace = TRUE)
) %>%
  mutate(
    t = rehreg(runif(n), ~ age+sex, beta = c(1, 2), phi = c(-1, 2),
                dist = "weibull", shape = 1.5, scale = 1),
    c = runif(n, 0, 10)
  ) %>%
  rowwise() %>%
  mutate(
    time = min(t, c),
    status = as.numeric(time == t)
  )
glimpse(simdata)
#> Rows: 1,000
#> Columns: 6
#> Rowwise: 
#> $ age    <dbl> -0.56047565, -0.23017749, 1.55870831, 0.07050839, 0.12928774, 1…
#> $ sex    <chr> "f", "f", "f", "m", "m", "f", "f", "f", "m", "f", "f", "f", "m"…
#> $ t      <dbl> 0.77474436, 0.12063547, 4.65511065, 0.33210000, 0.83078604, 3.1…
#> $ c      <dbl> 3.04464185, 8.32818782, 5.93647508, 8.07196641, 2.94050778, 1.4…
#> $ time   <dbl> 0.77474436, 0.12063547, 4.65511065, 0.33210000, 0.83078604, 1.4…
#> $ status <dbl> 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, …
```
