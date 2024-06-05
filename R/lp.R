
#' Linear predictors
#' @aliases lp
#' @export
#' @description Function to construct linear predictors.
#' @param formula formula specifying the linear predictors.
#' @param coefs vector of regression coefficients.
#' @param data data frame containing the covariates used to construct the linear predictors.
#' @param ... further arguments passed to other methods.
#' @return a vector containing the linear predictors
#'
#' @examples
#' \donttest{
#' library(rsurv)
#'
#' n <- 100
#' coefs <- c(1, 0.7, 2.3)
#'
#' simdata <- data.frame(
#'   age = rnorm(n),
#'   sex = sample(c("male", "female"), size = n, replace = TRUE)
#' ) |>
#'   mutate(
#'     lp = lp(~age+sex, coefs)
#'   )
#' glimpse(simdata)
#' }
#'

lp <- function(formula, coefs, data, ...){
  if(missing(data)){
    mf <- stats::model.frame(formula=formula)
  }else{
    mf <- stats::model.frame(formula=formula, data=data)
  }
  X <- stats::model.matrix(mf)
  lp <- as.numeric(X%*%coefs)
  return(lp)
}
