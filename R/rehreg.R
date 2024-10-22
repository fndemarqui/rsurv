
rEH <- function(u, baseline, lp1, lp2, package, ...){
  k <- exp(lp1+lp2)
  v <- u^(1/k)
  time <- qsurv(v, baseline, package, ...)*exp(lp1)
  return(time)
}


#' Random generation from extended hazard models
#' @aliases rehreg
#' @export
#' @description Function to generate a random sample of survival data from extended hazard models.
#' @param u a numeric vector of quantiles.
#' @param formula formula specifying the linear predictors.
#' @param baseline the name of the baseline survival distribution.
#' @param beta vector of regression coefficients.
#' @param phi vector of regression coefficients.
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
#'     t = rehreg(runif(n), ~ age+sex, beta = c(1, 2), phi = c(-1, 2),
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
rehreg <- function(u, formula, baseline, beta, phi, dist = NULL, package = NULL, data, ...){
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
    lp1 <- as.numeric(X%*%beta)
    lp2 <- as.numeric(X%*%phi)
  }else{
    lp1 <- 0
    lp2 <- 0
  }

  off <- stats::model.offset(mf)
  if(!is.null(off)){
    lp1 <- lp1 + off
    lp2 <- lp2 + off
  }

  if(baseline == "exp"){
    warning("The EH model with exponential baseline distribution is non-identifiable!")
  }

  time <- rEH(u, baseline = baseline, lp1 = lp1, lp2 = lp2, package = package, ...)
  return(time)
}
