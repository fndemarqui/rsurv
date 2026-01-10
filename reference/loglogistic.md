# The Log-Logistic Distribution

Density, distribution function, quantile function and random generation
for the log-logistic distribution with shape and scale parameters.

## Usage

``` r
dloglogistic(x, shape, scale, log = FALSE)

ploglogistic(q, shape, scale, lower.tail = TRUE, log.p = FALSE)

qloglogistic(p, shape, scale, lower.tail = TRUE, log.p = FALSE)

rloglogistic(n, shape, scale)
```

## Arguments

- x, q:

  vector of quantiles.

- shape:

  shape parameter. Must be positive.

- scale:

  scale parameter. Must be positive.

- log, log.p:

  logical; if `TRUE`, probabilities/densities p are returned as log(p).

- lower.tail:

  logical; if `TRUE` (default), probabilities are \\P\[X \le x\]\\,
  otherwise, \\P\[X \> x\]\\.

- p:

  vector of probabilities.

- n:

  number of observations. If `length(n) > 1`, the length is taken to be
  the number required.

## Value

`dloglogistic` gives the density, `ploglogistic` gives the distribution
function, `qloglogistic` gives the quantile function, and `rloglogistic`
generates random deviates.

The length of the result is determined by `n` for `rloglogistic`, and is
the maximum of the lengths of the numerical arguments for the other
functions.

## Details

The log-logistic distribution is a continuous probability distribution
for a non-negative random variable. It is the probability distribution
of a random variable whose logarithm has a logistic distribution.

The probability density function is given by: \$\$f(x) =
\frac{(\alpha/\gamma)(x/\gamma)^{\alpha-1}}{(1+(x/\gamma)^\alpha)^2}\$\$
for \\x \geq 0\\, where \\\alpha\\ is the shape parameter and \\\gamma\\
is the scale parameter.

The cumulative distribution function is: \$\$F(x) =
\frac{1}{1+(x/\gamma)^{-\alpha}}\$\$

## Examples

``` r
# Density at x = 1 with shape = 2 and scale = 1
dloglogistic(1, shape = 2, scale = 1)
#> [1] 0.5

# CDF at x = 1
ploglogistic(1, shape = 2, scale = 1)
#> [1] 0.5

# Quantile for p = 0.5 (median)
qloglogistic(0.5, shape = 2, scale = 1)
#> [1] 1

# Generate 10 random values
rloglogistic(10, shape = 2, scale = 1)
#>  [1] 7.0983521 1.6937515 0.2328874 1.0623661 1.5124712 1.4868928 0.1795469
#>  [8] 0.5396849 0.6559489 1.3231672
```
