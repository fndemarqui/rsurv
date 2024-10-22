
#' Generic quantile function
#' @export
#' @aliases qsurv
#' @description
#' Generic quantile function used internally to simulating from an arbitrary baseline survival distribution.
#'
#' @param p vector of quantiles associated with the right tail area of the baseline survival distribution.
#' @param baseline the name of the baseline distribution.
#' @param package the name of the package where the baseline distribution is implemented. It ensures that the right quantile function from the right package is found, regardless of the current R search path.
#' @param ... further arguments passed to other methods.
#' @return a vector of quantiles.
#' @examples
#'
#' library(rsurv)
#' set.seed(1234567890)
#'
#'
#' u <- sort(runif(5))
#' x1 <- qexp(u, rate = 1, lower.tail = FALSE)
#' x2 <- qsurv(u, baseline = "exp", rate = 1)
#' x3 <- qsurv(u, baseline = "exp", rate = 1, package = "stats")
#' x4 <- qsurv(u, baseline = "gengamma.orig", shape=1, scale=1, k=1, package = "flexsurv")
#'
#' cbind(x1, x2, x3, x4)
#'
qsurv <- function (p, baseline, package = NULL, ...){
  if(is.null(package)){
    qfunc <- base::get(paste("q", baseline, sep = ""), mode = "function")
  }else{
    baseline <- paste0("q", baseline)
    qfunc <- utils::getFromNamespace(baseline, package)
  }
  x <- qfunc(p, lower.tail = FALSE, ...)
  return(x)
}


