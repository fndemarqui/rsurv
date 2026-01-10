#' The Log-Logistic Distribution
#'
#' Density, distribution function, quantile function and random generation
#' for the log-logistic distribution with shape and scale parameters.
#'
#' @param x,q vector of quantiles.
#' @param p vector of probabilities.
#' @param n number of observations. If `length(n) > 1`, the length is taken to
#'   be the number required.
#' @param shape shape parameter. Must be positive.
#' @param scale scale parameter. Must be positive.
#' @param log,log.p logical; if `TRUE`, probabilities/densities p are returned
#'   as log(p).
#' @param lower.tail logical; if `TRUE` (default), probabilities are
#'   \eqn{P[X \le x]}, otherwise, \eqn{P[X > x]}.
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
#' `dloglogistic` gives the density, `ploglogistic` gives the distribution
#' function, `qloglogistic` gives the quantile function, and `rloglogistic`
#' generates random deviates.
#'
#' The length of the result is determined by `n` for `rloglogistic`, and is the
#' maximum of the lengths of the numerical arguments for the other functions.
#'
#' @examples
#' # Density at x = 1 with shape = 2 and scale = 1
#' dloglogistic(1, shape = 2, scale = 1)
#'
#' # CDF at x = 1
#' ploglogistic(1, shape = 2, scale = 1)
#'
#' # Quantile for p = 0.5 (median)
#' qloglogistic(0.5, shape = 2, scale = 1)
#'
#' # Generate 10 random values
#' rloglogistic(10, shape = 2, scale = 1)
#'
#' @name loglogistic
#' @aliases dloglogistic ploglogistic qloglogistic rloglogistic
#' @export
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

#' @rdname loglogistic
#' @export
ploglogistic <- function(q, shape, scale, lower.tail = TRUE, log.p = FALSE) {
  if (length(q) == 0) return(numeric(0))

  n <- max(length(q), length(shape), length(scale))
  q <- rep_len(q, n)
  shape <- rep_len(shape, n)
  scale <- rep_len(scale, n)

  bad_mask <- shape <= 0 | scale <= 0

  p <- stats::plogis(log(q), location = log(scale), scale = 1/shape,
              lower.tail = lower.tail, log.p = log.p)

  if (log.p) {
    p[q < 0] <- if (lower.tail) -Inf else 0
  } else {
    p[q < 0] <- if (lower.tail) 0 else 1
  }

  p[bad_mask] <- NA
  return(p)
}

#' @rdname loglogistic
#' @export
qloglogistic <- function(p, shape, scale, lower.tail = TRUE, log.p = FALSE) {
  if (length(p) == 0) return(numeric(0))

  if (log.p) p <- exp(p)
  if (!lower.tail) p <- 1 - p

  n <- max(length(p), length(shape), length(scale))
  p <- rep_len(p, n)
  shape <- rep_len(shape, n)
  scale <- rep_len(scale, n)

  bad_mask <- shape <= 0 | scale <= 0 | p < 0 | p > 1
  if (any(bad_mask, na.rm = TRUE)) warning("NaNs produced")

  q <- scale * (p / (1 - p))^(1 / shape)

  q[p == 0] <- 0
  q[p == 1] <- Inf
  q[bad_mask] <- NaN

  return(q)
}

#' @rdname loglogistic
#' @export
rloglogistic <- function(n, shape, scale) {
  if (length(n) > 1) n <- length(n)
  if (length(shape) == 0 || length(scale) == 0) {
    warning("NAs produced")
    return(rep(NA_real_, n))
  }

  if (any(shape <= 0 | scale <= 0)) warning("NAs produced")

  u <- stats::runif(n)
  q <- qloglogistic(u, shape = shape, scale = scale)

  return(q)
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