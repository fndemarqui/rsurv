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
#> $ age <dbl> 0.54299634, -0.91407483, 0.46815442, 0.36295126, -1.30454355, 0.73…
#> $ sex <chr> "female", "female", "female", "male", "male", "female", "female", …
#> $ lp  <dbl> 1.38009744, 0.36014762, 1.32770809, 3.55406588, 2.38681952, 1.5164…
```
