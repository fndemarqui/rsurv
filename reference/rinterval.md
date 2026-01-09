# Random generation of type I and type II interval censored survival data

Function to generate a random sample of type I and type II interval
censored survival data.

## Usage

``` r
rinterval(time, tau, type = c("I", "II"), prob)
```

## Arguments

- time:

  a numeric vector of survival times.

- tau:

  either a vector of censoring times (for type I interval-censored
  survival data) or time grid of scheduled visits (for type II interval
  censored survival data).

- type:

  type of interval-censored survival data (I or II).

- prob:

  = 0.5 attendance probability of scheduled visit; ignored when type =
  I.

## Value

a data.frame containing the generated random sample.
