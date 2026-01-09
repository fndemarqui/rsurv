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
#> $ age <dbl> 0.255317055, -2.437263611, -0.005571287, 0.621552721, 1.148411606,…
#> $ sex <chr> "male", "female", "female", "male", "male", "male", "male", "male"…
#> $ lp  <dbl> 3.4787219, -0.7060845, 0.9961001, 3.7350869, 4.1038881, 2.0247276,…
```
