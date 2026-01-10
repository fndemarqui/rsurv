#' The Log-Logistic Distribution (Internal Functions)
#'
#' Internal density and distribution functions for the log-logistic
#' distribution with shape and scale parameters. These are working
#' functions used internally by the package.
#'
#' @param x,q vector of quantiles.
#' @param shape shape parameter. Must be positive.
#' @param scale scale parameter. Must be positive.
#' @param log logical; if `TRUE`, densities are returned as log(density).
#' @param lower_tail logical; if `TRUE` (default), probabilities are
#'   \eqn{P[X \le x]}, otherwise, \eqn{P[X > x]}.
#' @param give_log logical; if `TRUE`, probabilities p are returned as log(p).
#'
#' @details
#' The log-logistic distribution is a continuous probability distribution
#' for a non-negative random variable. It is the probability distribution
#' of a random variable whose logarithm has a logistic distribution.
#'
#' The probability density function is given by:
#' \deqn{f(x) = \frac{(\alpha/\gamma)(x/\gamma)^{\alpha-1}}{(1+(x/\gamma)^\alpha)^2}}
#' for \eqn{x \geq 0}, where \eqn{\alpha} is the shape parameter and
#' \eqn{\gamma} is the scale parameter.
#'
#' The cumulative distribution function is:
#' \deqn{F(x) = \frac{1}{1+(x/\gamma)^{-\alpha}}}
#'
#' @return
#' `dloglogistic` returns the density and `ploglogistic` returns the
#' distribution function.
#'
#' @keywords internal
#' @noRd
dloglogistic <- function(x, shape, scale, log = FALSE) {
  if (length(x) == 0) return(numeric(0))
  if (length(x) == 0) return(numeric(0))

  n <- max(length(x), length(shape), length(scale))
  x <- rep_len(x, n)
  shape <- rep_len(shape, n)
  scale <- rep_len(scale, n)

  bad_mask <- shape <= 0 | scale <= 0
  if (any(shape < 0, na.rm = TRUE)) warning("Non-positive shape parameter")
  if (any(scale < 0, na.rm = TRUE)) warning("Non-positive scale parameter")

  log_dens <- log(shape) - log(scale) +
              (shape - 1) * (log(x) - log(scale)) -
              2 * log(1 + (x / scale)^shape)

  log_dens[x < 0] <- -Inf
  log_dens[bad_mask] <- NA

  if (log) return(log_dens) else return(exp(log_dens))
}

ploglogistic <- function(q, shape, scale, lower_tail = TRUE, give_log = FALSE) {
  if (length(q) == 0) return(numeric(0))

  n <- max(length(q), length(shape), length(scale))
  q <- rep_len(q, n)
  shape <- rep_len(shape, n)
  scale <- rep_len(scale, n)

  bad_mask <- shape <= 0 | scale <= 0

  p <- stats::plogis(log(q), location = log(scale), scale = 1/shape,
              lower.tail = lower_tail, log.p = give_log)

  if (give_log) {
    p[q < 0] <- if (lower_tail) -Inf else 0
  } else {
    p[q < 0] <- if (lower_tail) 0 else 1
  }

  p[bad_mask] <- NA
  return(p)
}

#' Check Log-Logistic Parameters
#'
#' Internal function to check if log-logistic parameters are valid.
#'
#' @param shape shape parameter.
#' @param scale scale parameter.
#'
#' @return Logical vector indicating whether parameters are valid (`TRUE`)
#'   or invalid (`FALSE`).
#'
#' @keywords internal
#' @noRd
check_llogis <- function(shape, scale) {
  if (length(shape) == 0 && length(scale) == 0) return(logical(0))

  n <- max(length(shape), length(scale))
  shape <- rep_len(shape, n)
  scale <- rep_len(scale, n)

  return(!(shape <= 0 | scale <= 0))
}