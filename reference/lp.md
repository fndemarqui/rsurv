# Linear predictors

Function to construct linear predictors.

## Usage

``` r
lp(formula, coefs, data, ...)
```

## Arguments

- formula:

  formula specifying the linear predictors.

- coefs:

  vector of regression coefficients.

- data:

  data frame containing the covariates used to construct the linear
  predictors.

- ...:

  further arguments passed to other methods.

## Value

a vector containing the linear predictors.

## Examples

``` r
library(rsurv)
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union

n <- 100
coefs <- c(1, 0.7, 2.3)

simdata <- data.frame(
  age = rnorm(n),
  sex = sample(c("male", "female"), size = n, replace = TRUE)
) %>%
  mutate(
    lp = lp(~age+sex, coefs)
  )
glimpse(simdata)
#> Rows: 100
#> Columns: 3
#> $ age <dbl> 2.06502490, -1.63098940, 0.51242695, -1.86301149, -0.52201251, -0.…
#> $ sex <chr> "male", "male", "male", "male", "male", "male", "male", "female", …
#> $ lp  <dbl> 4.74551743, 2.15830742, 3.65869886, 1.99589196, 2.93459124, 3.2631…
```
