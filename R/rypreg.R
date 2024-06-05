
rYP <- function(u, baseline, lp_short, lp_long, ...){
  # lp_short = lp_long: PH
  # lp_long = 0: PO
  # lp_short != lp_long: YP
  ratio <- exp(lp_long - lp_short)
  kappa <- exp(lp_long)
  w <- (u^(-1/kappa ) - 1)*ratio
  v <- 1/(1 + w)
  time <- qsurv(v, baseline, ...)
  return(time)
}


#' Random generation from Yang and Prentice models
#' @aliases rypreg
#' @export
#' @description Function to generate a random sample of survival data from Yang and Prentice models.
#' @param u a numeric vector of quantiles.
#' @param formula formula specifying the linear predictors.
#' @param baseline the name of the baseline survival distribution.
#' @param beta vector of short-term regression coefficients.
#' @param phi vector of long-term regression coefficients.
#' @param dist an alternative way to specify the baseline survival distribution.
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
#'     t = rypreg(runif(n), ~ age+sex, beta = c(1, 2), phi = c(-1, 2),
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
rypreg <- function(u, formula, baseline, beta, phi, dist = NULL, data, ...){
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
    lp_short <- as.numeric(X%*%beta)
    lp_long <- as.numeric(X%*%phi)
  }else{
    lp_short <- 0
    lp_long <- 0
  }

  off <- stats::model.offset(mf)
  if(!is.null(off)){
    lp_short <- lp_short + off
    lp_long <- lp_long + off
  }

  time <- rYP(u, baseline = baseline, lp_short = lp_short, lp_long = lp_long, ...)
  return(time)
}
