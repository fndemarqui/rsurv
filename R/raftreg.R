
#' Random generation from accelerated failure time models
#' @aliases raftreg
#' @export
#' @description Function to generate a random sample of survival data from accelerated failure time models.
#' @param u a numeric vector of quantiles.
#' @param formula formula specifying the linear predictors.
#' @param baseline the name of the baseline survival distribution.
#' @param beta vector of regression coefficients.
#' @param dist an alternative way to specify the baseline survival distribution.
#' @param package the name of the package where the assumed quantile function is implemented.
#' @param data data frame containing the covariates used to generate the survival times.
#' @param ... further arguments passed to other methods.
#' @return a numeric vector containing the generated random sample.
#'
#' @examples
#' library(rsurv)
#' library(dplyr)
#' n <-  1000
#' simdata <- data.frame(
#'   age = rnorm(n),
#'   sex = sample(c("f", "m"), size = n, replace = TRUE)
#' ) %>%
#'   mutate(
#'     t = raftreg(runif(n), ~ age+sex, beta = c(1, 2),
#'                 dist = "weibull", shape = 1.5, scale = 1),
#'     c = runif(n, 0, 10)
#'   ) %>%
#'   rowwise() %>%
#'   mutate(
#'     time = min(t, c),
#'     status = as.numeric(time == t)
#'   )
#' glimpse(simdata)
#'
raftreg <- function(u, formula, baseline, beta, dist = NULL, package = NULL, data, ...){
  if(!is.null(dist)){
    baseline <- dist
  }
  if(missing(data)){
    mf <- stats::model.frame(formula=formula)
  }else{
    mf <- stats::model.frame(formula=formula, data=data)
  }

  Terms <- stats::terms(mf)
  contrast.arg <- NULL
  has.intercept <- attr(Terms, "intercept")
  attr(Terms, "intercept") <- 1
  X <- stats::model.matrix(Terms, mf, constrasts.arg=contrast.arg)
  Xatt <- attributes(X)
  adrop <- 0
  if(has.intercept == 0){
    warning("Provided formula not allowed! Using ", stats::update.formula(formula,  ~ . +1), " instead. Please, review the choice of your regression coefficients accordingly.")
  }
  xdrop <- Xatt$assign %in% adrop  #columns to drop (always the intercept)
  X <- X[, !xdrop, drop=FALSE]
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

  time <- rEH(u, baseline = baseline, lp1 = lp, lp2 = -lp, package = package, ...)
  return(time)
}
