# The Rayleigh Distribution

Density, distribution function, quantile function and random generation
for the Rayleigh distribution with scale parameter `sigma`.

## Usage

``` r
drayleigh(x, sigma, log = FALSE)

prayleigh(q, sigma, lower.tail = TRUE, log.p = FALSE)

qrayleigh(p, sigma, lower.tail = TRUE, log.p = FALSE)

rrayleigh(n, sigma)
```

## Arguments

- x, q:

  vector of quantiles.

- sigma:

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

`drayleigh` gives the density, `prayleigh` gives the distribution
function, `qrayleigh` gives the quantile function, and `rrayleigh`
generates random deviates.

The length of the result is determined by `n` for `rrayleigh`, and is
the maximum of the lengths of the numerical arguments for the other
functions.

## Details

The Rayleigh distribution is a continuous probability distribution for
non-negative random variables. It arises as the distribution of the
magnitude of a two-dimensional vector whose components are independent,
identically distributed Gaussian random variables with zero mean.

The probability density function is given by: \$\$f(x) =
\frac{x}{\sigma^2} \exp\left(-\frac{x^2}{2\sigma^2}\right)\$\$ for \\x
\geq 0\\ and \\\sigma \> 0\\.

The cumulative distribution function is: \$\$F(x) = 1 -
\exp\left(-\frac{x^2}{2\sigma^2}\right)\$\$

## References

Rayleigh, Lord (1880). On the resultant of a large number of vibrations
of the same pitch and of arbitrary phase. *Philosophical Magazine*,
10(60), 73-78.

## Examples

``` r
# Density at x = 1 with sigma = 1
drayleigh(1, sigma = 1)
#> [1] 0.6065307

# CDF at x = 1
prayleigh(1, sigma = 1)
#> [1] 0.3934693

# Quantile for p = 0.5 (median)
qrayleigh(0.5, sigma = 1)
#> [1] 1.17741

# Generate 10 random values
rrayleigh(10, sigma = 1)
#>  [1] 0.8154869 0.9253405 1.6880767 2.2109872 1.5589187 1.1066728 0.7037479
#>  [8] 1.6140235 1.5154609 0.3279180
```
