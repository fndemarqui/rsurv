#' The Rayleigh Distribution
#'
#' Density, distribution function, quantile function and random generation
#' for the Rayleigh distribution with scale parameter `sigma`.
#'
#' @param x,q vector of quantiles.
#' @param p vector of probabilities.
#' @param n number of observations. If `length(n) > 1`, the length is taken to
#'   be the number required.
#' @param sigma scale parameter. Must be positive.
#' @param log,log.p logical; if `TRUE`, probabilities/densities p are returned
#'   as log(p).
#' @param lower.tail logical; if `TRUE` (default), probabilities are
#'   \eqn{P[X \le x]}, otherwise, \eqn{P[X > x]}.
#'
#' @details
#' The Rayleigh distribution is a continuous probability distribution for
#' non-negative random variables. It arises as the distribution of the
#' magnitude of a two-dimensional vector whose components are independent,
#' identically distributed Gaussian random variables with zero mean.
#'
#' The probability density function is given by:
#' \deqn{f(x) = \frac{x}{\sigma^2} \exp\left(-\frac{x^2}{2\sigma^2}\right)}
#' for \eqn{x \geq 0} and \eqn{\sigma > 0}.
#'
#' The cumulative distribution function is:
#' \deqn{F(x) = 1 - \exp\left(-\frac{x^2}{2\sigma^2}\right)}
#'
#' @return
#' `drayleigh` gives the density, `prayleigh` gives the distribution function,
#' `qrayleigh` gives the quantile function, and `rrayleigh` generates random
#' deviates.
#'
#' The length of the result is determined by `n` for `rrayleigh`, and is the
#' maximum of the lengths of the numerical arguments for the other functions.
#'
#' @references
#' Rayleigh, Lord (1880). On the resultant of a large number of vibrations
#' of the same pitch and of arbitrary phase. *Philosophical Magazine*,
#' 10(60), 73-78.
#'
#' @examples
#' # Density at x = 1 with sigma = 1
#' drayleigh(1, sigma = 1)
#'
#' # CDF at x = 1
#' prayleigh(1, sigma = 1)
#'
#' # Quantile for p = 0.5 (median)
#' qrayleigh(0.5, sigma = 1)
#'
#' # Generate 10 random values
#' rrayleigh(10, sigma = 1)
#'
#' @name rayleigh
#' @aliases drayleigh prayleigh qrayleigh rrayleigh
#' @export
drayleigh <- function(x, sigma, log = FALSE) {
  # Parameter validation
  if (any(sigma <= 0)) warning("NaNs produced")

  # Logic: x/sigma^2 * exp(-x^2 / (2*sigma^2))
  # Using log-scale for better numerical stability as seen in C++
  log_pdf <- log(x) - 2 * log(sigma) - (x^2 / (2 * sigma^2))

  # Handle support and non-finite values
  log_pdf[x <= 0 | !is.finite(x)] <- -Inf
  log_pdf[sigma <= 0] <- NaN

  if (log) log_pdf else exp(log_pdf)
}

#' @rdname rayleigh
#' @export
prayleigh <- function(q, sigma, lower.tail = TRUE, log.p = FALSE) {
  if (any(sigma <= 0)) warning("NaNs produced")

  # Logic: 1 - exp(-x^2 / (2*sigma^2))
  # For numerical precision with lower.tail = FALSE, we use the exp directly
  if (lower.tail) {
    p <- 1 - exp(-(q^2) / (2 * sigma^2))
  } else {
    p <- exp(-(q^2) / (2 * sigma^2))
  }

  # Handle support
  p[q < 0] <- if (lower.tail) 0 else 1
  p[!is.finite(q) & q > 0] <- if (lower.tail) 1 else 0
  p[sigma <= 0] <- NaN

  if (log.p) log(p) else p
}

#' @rdname rayleigh
#' @export
qrayleigh <- function(p, sigma, lower.tail = TRUE, log.p = FALSE) {
  if (log.p) p <- exp(p)
  if (!lower.tail) p <- 1 - p

  if (any(sigma <= 0 | p < 0 | p > 1)) warning("NaNs produced")

  # Logic: sigma * sqrt(-2 * log(1-p))
  res <- sigma * sqrt(-2 * log(1 - p))

  # Handle invalid parameters or probabilities
  res[sigma <= 0 | p < 0 | p > 1] <- NaN

  return(res)
}

#' @rdname rayleigh
#' @export
rrayleigh <- function(n, sigma) {
  if (length(sigma) < 1) {
    warning("NAs produced")
    return(rep(NA_real_, n))
  }

  if (any(sigma <= 0)) warning("NAs produced")

  # Inversion method as used in the C++ rng_unif logic
  u <- stats::runif(n)
  res <- sigma * sqrt(-2 * log(u))

  res[sigma <= 0] <- NA
  return(res)
}
