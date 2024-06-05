
#' Random generation from proportional hazards models
#' @aliases rphreg
#' @export
#' @description Function to generate a random sample of survival data from proportional hazards models.
#' @param u a numeric vector of quantiles.
#' @param formula formula specifying the linear predictors.
#' @param baseline the name of the baseline survival distribution.
#' @param beta vector of regression coefficients.
#' @param dist an alternative way to specify the baseline survival distribution
#' @param data data frame containing the covariates used to generate the survival times.
#' @param ... further arguments passed to other methods.
#' @return a numeric vector containing the generated random sample.
#'
#' @examples
#' \donttest{
#' library(rsurv)
#' n <-  1000
#' simdata <- data.frame(
#'   age = rnorm(n),
#'   sex = sample(c("f", "m"), size = n, replace = TRUE)
#' ) %>%
#'   mutate(
#'     t = rphreg(runif(n), ~ age+sex, beta = c(1, 2),
#'                 dist = "weibull", shape = 1.5, scale = 1),
#'     c = runif(n, 0, 10)
#'   ) %>%
#'   rowwise() %>%
#'   mutate(
#'     time = min(t, c),
#'     status = as.numeric(time == t)
#'   )
#' glimpse(simdata)
#' }
#'
rphreg <- function(u, formula, baseline, beta, dist = NULL, data, ...){
  if(!is.null(dist)){
    baseline <- dist
  }
  if(missing(data)){
    mf <- stats::model.frame(formula=formula)
  }else{
    mf <- stats::model.frame(formula=formula, data=data)
  }

  X <- stats::model.matrix(formula, data = mf, rhs = 1)[,-1, drop = FALSE]
  p <- ncol(X)

  if(p>0){
    lp <- as.numeric(X%*%beta)
  }else{
    lp <- 0
  }

  off <- stats::model.offset(mf)
  if(!is.null(off)){
    lp <- lp + off
  }

  time <- rYP(u, baseline = baseline, lp_short = lp, lp_long = lp, ...)
  return(time)
}
