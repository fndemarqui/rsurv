# Random generation from Yang and Prentice models

Function to generate a random sample of survival data from Yang and
Prentice models.

## Usage

``` r
rypreg(
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

  vector of short-term regression coefficients.

- phi:

  vector of long-term regression coefficients.

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
    t = rypreg(runif(n), ~ age+sex, beta = c(1, 2), phi = c(-1, 2),
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
#> $ t      <dbl> 1.42670348, 0.17547254, 1.41589476, 0.15204544, 0.35032244, 0.4…
#> $ c      <dbl> 3.04464185, 8.32818782, 5.93647508, 8.07196641, 2.94050778, 1.4…
#> $ time   <dbl> 1.42670348, 0.17547254, 1.41589476, 0.15204544, 0.35032244, 0.4…
#> $ status <dbl> 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
```
