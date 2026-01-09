# The Birnbaum-Saunders (Fatigue Life) Distribution

Density, distribution function, quantile function and random generation
for the Birnbaum-Saunders distribution with shape parameter `alpha`,
scale parameter `gamma`, and location parameter `mu`.

## Usage

``` r
dfatigue(x, alpha, gamma, mu = 0, log = FALSE)

pfatigue(q, alpha, gamma, mu = 0, lower.tail = TRUE, log.p = FALSE)

qfatigue(p, alpha, gamma, mu = 0, lower.tail = TRUE, log.p = FALSE)

rfatigue(n, alpha, gamma, mu = 0)
```

## Arguments

- x, q:

  vector of quantiles.

- alpha:

  shape parameter. Must be positive.

- gamma:

  scale parameter. Must be positive.

- mu:

  location parameter (default is 0).

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

`dfatigue` gives the density, `pfatigue` gives the distribution
function, `qfatigue` gives the quantile function, and `rfatigue`
generates random deviates.

The length of the result is determined by `n` for `rfatigue`, and is the
maximum of the lengths of the numerical arguments for the other
functions.

## Details

The Birnbaum-Saunders distribution, also known as the fatigue life
distribution, is commonly used in reliability and survival analysis. It
was originally proposed to model fatigue failure times of materials
subjected to cyclic stress.

The probability density function is given by: \$\$f(x) =
\frac{\sqrt{(x-\mu)/\gamma} + \sqrt{\gamma/(x-\mu)}}{2\alpha(x-\mu)}
\phi\left(\frac{\sqrt{(x-\mu)/\gamma} -
\sqrt{\gamma/(x-\mu)}}{\alpha}\right)\$\$ for \\x \> \mu\\, where
\\\phi\\ is the standard normal density function.

## References

Birnbaum, Z. W., & Saunders, S. C. (1969). A new family of life
distributions. *Journal of Applied Probability*, 6(2), 319-327.

## Examples

``` r
# Density at x = 2 with alpha = 0.5 and gamma = 1
dfatigue(2, alpha = 0.5, gamma = 1)
#> [1] 0.1556653

# CDF at x = 2
pfatigue(2, alpha = 0.5, gamma = 1)
#> [1] 0.9213504

# Quantile for p = 0.5 (median)
qfatigue(0.5, alpha = 0.5, gamma = 1)
#> [1] 1

# Generate 10 random values
rfatigue(10, alpha = 0.5, gamma = 1)
#>  [1] 1.1360667 0.3155010 0.9972182 1.3627969 1.7622587 0.4139388 0.8837474
#>  [8] 0.8851271 0.8682850 0.7588334
```
