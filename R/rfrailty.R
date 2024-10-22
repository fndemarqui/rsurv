#' Frailties random generation
#' @export
#' @aliases rfrailty
#' @description The frailty function for adding a simple random effects term to the linear predictor of a given survival regression model.
#' @param cluster a vector determining the grouping of subjects (always converted to a factor object internally.
#' @param frailty the frailty distribution; current implementation includes the gamma (default), lognormal and positive stable (ps) distributions.
#' @param sigma standard deviation assumed for the frailty distribution; sigma = 1 by default; this value is ignored for positive stable (ps) distribution.
#' @param alpha stability parameter of the positive stable distribution; alpha must lie in (0,1) interval and an NA is return otherwise.
#' @param ... further arguments passed to other methods.
#' @return a vector with the generated frailties.

rfrailty <- function(cluster, frailty = c("gamma", "gaussian", "ps"), sigma = 1, alpha = NULL, ...){
  frailty <- match.arg(frailty)
  id <- as.numeric(as.factor(cluster))
  L <- length(unique(id))
  frail <- switch(frailty,
                  "gamma" = log(stats::rgamma(L, shape = 1/sigma^2, rate = 1/sigma^2)),  # in log-scale
                  "gaussian" = stats::rnorm(L, 0, sigma),
                  "ps" = stabledist::rstable(L, alpha = alpha, beta = 1, gamma = 1, delta = 0, pm=1)
  )
  frail <- frail[id]
  if(!is.null(alpha)){
    if(alpha < 0 | alpha > 1){
      warning("alpha must lie in (0,1]")
      frail <- NA
    }
  }
  return(frail)
}

