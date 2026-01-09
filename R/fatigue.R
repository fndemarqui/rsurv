#' The Birnbaum-Saunders (Fatigue Life) Distribution
#'
#' Density, distribution function, quantile function and random generation
#' for the Birnbaum-Saunders distribution with shape parameter `alpha`,
#' scale parameter `gamma`, and location parameter `mu`.
#'
#' @param x,q vector of quantiles.
#' @param p vector of probabilities.
#' @param n number of observations. If `length(n) > 1`, the length is taken to
#'   be the number required.
#' @param alpha shape parameter. Must be positive.
#' @param gamma scale parameter. Must be positive.
#' @param mu location parameter (default is 0).
#' @param log,log.p logical; if `TRUE`, probabilities/densities p are returned
#'   as log(p).
#' @param lower.tail logical; if `TRUE` (default), probabilities are
#'   \eqn{P[X \le x]}, otherwise, \eqn{P[X > x]}.
#'
#' @details
#' The Birnbaum-Saunders distribution, also known as the fatigue life
#' distribution, is commonly used in reliability and survival analysis.
#' It was originally proposed to model fatigue failure times of materials
#' subjected to cyclic stress.
#'
#' The probability density function is given by:
#' \deqn{f(x) = \frac{\sqrt{(x-\mu)/\gamma} + \sqrt{\gamma/(x-\mu)}}{2\alpha(x-\mu)}
#' \phi\left(\frac{\sqrt{(x-\mu)/\gamma} - \sqrt{\gamma/(x-\mu)}}{\alpha}\right)}
#' for \eqn{x > \mu}, where \eqn{\phi} is the standard normal density function.
#'
#' @return
#' `dfatigue` gives the density, `pfatigue` gives the distribution function,
#' `qfatigue` gives the quantile function, and `rfatigue` generates random
#' deviates.
#'
#' The length of the result is determined by `n` for `rfatigue`, and is the

#' maximum of the lengths of the numerical arguments for the other functions.
#'
#' @references
#' Birnbaum, Z. W., & Saunders, S. C. (1969). A new family of life
#' distributions. *Journal of Applied Probability*, 6(2), 319-327.
#'
#' @examples
#' # Density at x = 2 with alpha = 0.5 and gamma = 1
#' dfatigue(2, alpha = 0.5, gamma = 1)
#'
#' # CDF at x = 2
#' pfatigue(2, alpha = 0.5, gamma = 1)
#'
#' # Quantile for p = 0.5 (median)
#' qfatigue(0.5, alpha = 0.5, gamma = 1)
#'
#' # Generate 10 random values
#' rfatigue(10, alpha = 0.5, gamma = 1)
#'
#' @name fatigue
#' @aliases dfatigue pfatigue qfatigue rfatigue
#' @export
dfatigue <- function(x, alpha, gamma, mu = 0, log = FALSE) {
  # Handle parameter validation (mimics throw_warning)
  if (any(alpha <= 0 | gamma <= 0)) {
    warning("NaNs produced")
  }

  # Logic: (zb+bz)/(2*alpha*z) * phi((zb-bz)/alpha)
  z_val <- x - mu
  # Standardized components
  zb <- sqrt(z_val / gamma)
  bz <- sqrt(gamma / z_val)

  # Log-density calculation
  # lphi is log(dnorm(...))
  log_pdf <- log(zb + bz) - log(2) - log(alpha) - log(z_val) +
    stats::dnorm((zb - bz) / alpha, log = TRUE)

  # Handle support (x > mu)
  log_pdf[x <= mu] <- -Inf
  # Handle invalid parameters
  log_pdf[alpha <= 0 | gamma <= 0] <- NaN

  if (log) log_pdf else exp(log_pdf)
}

#' @rdname fatigue
#' @export
pfatigue <- function(q, alpha, gamma, mu = 0, lower.tail = TRUE, log.p = FALSE) {
  if (any(alpha <= 0 | gamma <= 0)) warning("NaNs produced")

  z_val <- q - mu
  zb <- sqrt(z_val / gamma)
  bz <- sqrt(gamma / z_val)

  # Phi is pnorm
  p <- stats::pnorm((zb - bz) / alpha, lower.tail = lower.tail, log.p = log.p)

  # Handle support
  p[q <= mu] <- if (log.p) -Inf else 0
  p[alpha <= 0 | gamma <= 0] <- NaN

  return(p)
}

#' @rdname fatigue
#' @export
qfatigue <- function(p, alpha, gamma, mu = 0, lower.tail = TRUE, log.p = FALSE) {
  if (log.p) p <- exp(p)
  if (!lower.tail) p <- 1 - p

  if (any(alpha <= 0 | gamma <= 0 | p < 0 | p > 1)) warning("NaNs produced")

  # InvPhi is qnorm
  zp <- stats::qnorm(p)

  # Inverse CDF formula from the C++ code
  term <- (alpha / 2 * zp)
  res <- (term + sqrt(term^2 + 1))^2 * gamma + mu

  # Boundary case p = 0
  res[p == 0] <- mu
  res[alpha <= 0 | gamma <= 0 | p < 0 | p > 1] <- NaN

  return(res)
}

#' @rdname fatigue
#' @export
rfatigue <- function(n, alpha, gamma, mu = 0) {
  if (length(alpha) == 0 || length(gamma) == 0 || length(mu) == 0) {
    warning("NAs produced")
    return(rep(NA_real_, n))
  }

  # R handles recycling automatically, but we ensure n length
  z <- stats::rnorm(n)

  # Use the same logic as invcdf but with random normal z
  term <- (alpha / 2 * z)
  res <- (term + sqrt(term^2 + 1))^2 * gamma + mu

  if (any(alpha <= 0 | gamma <= 0)) {
    warning("NAs produced")
    res[alpha <= 0 | gamma <= 0] <- NA
  }

  return(res)
}
