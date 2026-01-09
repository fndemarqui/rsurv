# Introduction to the R package rsurv

In this document we show how to use the **rsurv** package to simulate
different types of right-censored survival data.

## Type I right-censored survival data

In the code below we show how to simulate a sample of Type I
right-censored survival data, assuming that the failure times are
generated from an accelerated failure time model with loglogistic
baseline distribution. In addition, assume that we wish to consider two
exploratory variables, say age and sex, and we want to include an
interaction effect between them. Such a task can be easily accomplished
by using the function
[`raftreg()`](https://fndemarqui.github.io/rsurv/reference/raftreg.md)
along with the function `qllogis()` available in the package
**flexsurv**.

``` r
library(rsurv)
library(dplyr)
library(survstan)

set.seed(1234567890)

n <-  1000
tau <- 10  # maximum follow up time
simdata <- data.frame(
  age = rnorm(n),
  sex = sample(c("f", "m"), size = n, replace = TRUE)
) %>%
  mutate(
    t = raftreg(runif(n), ~ age*sex, beta = c(1, 2, -0.5), 
                dist = "llogis", shape = 1.5, scale = 1, package = "flexsurv"),
  ) %>%
  rowwise() %>%
  mutate(
    time = min(t, tau),
    status = as.numeric(time == t)
  ) 

# visualizing the simulated data:
glimpse(simdata)
#> Rows: 1,000
#> Columns: 5
#> Rowwise: 
#> $ age    <dbl> 1.34592454, 0.99527131, 0.54622688, -1.91272392, 1.92128431, 1.…
#> $ sex    <chr> "m", "f", "f", "m", "m", "m", "m", "f", "f", "m", "f", "m", "m"…
#> $ t      <dbl> 15.2363453, 1.5259533, 2.1783746, 2.4354995, 58.7932958, 16.714…
#> $ time   <dbl> 10.0000000, 1.5259533, 2.1783746, 2.4354995, 10.0000000, 10.000…
#> $ status <dbl> 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, …

fit <- aftreg(
  Surv(time, status) ~ age*sex,
  data = simdata, dist = "loglogistic"
)
estimates(fit)
#>        age       sexm   age:sexm      alpha      gamma 
#>  0.9494630  2.0094422 -0.4812641  1.4946497  1.0226847
```

## Type II right-censored survival data

Suppose one wishes to simulate an accelerated failure test. In the
example presented below we consider $n = 20$ test units, with a
pre-specified number of $m = 15$ failures (Type II right-censoring). A
lognormal distributions with parameters $\mu = - 1$ and $\sigma = 1$ is
assumed for the baseline distribution. Temperature is considered as the
acceleration factor. Specifically, we consider 4 levels of temperature
(300, 350, 400, 500 Kelvin degrees), and the following linear predictor
is: $x\beta = - 0.05 \times \text{temperature}$.

``` r
library(rsurv)
library(dplyr)

set.seed(1234567890)
n <- 20 # number of test units
m <- 15 # number of failures

#simulating the failure times:
simdata <- data.frame(
  temperature = rep(c(300, 350, 400, 500), each = 5)    
) %>%                                                                   
  mutate(                                                            
    t = raftreg(runif(n), ~ 1/temperature, beta = 580, 
                dist = "lnorm", meanlog = 3, sdlog = 0.5)                                          
  ) %>%
  arrange(t) # sorting the generated data

# obtaining 15-th failure time:
tau <- simdata$t[m]

# including type II censoring:
simdata <- simdata %>%
  rowwise() %>%
  mutate(
    time = min(t, tau),
    status = as.numeric(time == t)
  )
simdata
#> # A tibble: 20 × 4
#> # Rowwise: 
#>    temperature     t  time status
#>          <dbl> <dbl> <dbl>  <dbl>
#>  1         350  6.56  6.56      1
#>  2         350  7.69  7.69      1
#>  3         350  8.99  8.99      1
#>  4         400 10.1  10.1       1
#>  5         300 10.2  10.2       1
#>  6         500 11.8  11.8       1
#>  7         300 12.2  12.2       1
#>  8         350 14.2  14.2       1
#>  9         300 14.4  14.4       1
#> 10         400 14.5  14.5       1
#> 11         300 15.3  15.3       1
#> 12         400 15.8  15.8       1
#> 13         500 21.2  21.2       1
#> 14         500 22.0  22.0       1
#> 15         300 23.2  23.2       1
#> 16         500 27.3  23.2       0
#> 17         400 35.1  23.2       0
#> 18         400 37.5  23.2       0
#> 19         500 47.2  23.2       0
#> 20         350 52.3  23.2       0
```

## Type III (random censoring) right-censored survival data

``` r
library(rsurv)
library(dplyr)

set.seed(1234567890)
n <- 20
covariates <- data.frame(
  stage = sample(c("I", "II", "III", "IV"), size = n, replace = TRUE)
) 

simdata1 <- covariates %>%
  mutate(
    t = rphreg(runif(n), ~stage, beta = c(0.2, 0.35, 1.2), dist = "weibull", shape = 2.3, scale = 1),
    c = rexp(n, rate = 0.1)
  ) %>%
  rowwise() %>%
  mutate(
    time = min(t, tau),
    status = as.numeric(time == t)
  ) %>%
  select(-c(t, c))
glimpse(simdata1)
#> Rows: 20
#> Columns: 3
#> Rowwise: 
#> $ stage  <chr> "I", "III", "IV", "II", "II", "I", "IV", "III", "IV", "III", "I…
#> $ time   <dbl> 1.4704064, 0.5454478, 0.6579358, 0.7999922, 0.8717459, 0.620011…
#> $ status <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1

att <- attributes(simdata1$time)
str(att)
#>  NULL
unique(att$model.matrix)
#> NULL
```
