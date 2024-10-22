#' Implemented link functions for the mixture cure rate model
#' @export
#' @aliases bernoulli
#' @description This function is used to specify different link functions for the count component of the mixture cure rate model.
#' @param link desired link function; currently implemented links are: logit, probit, cloglog and cauchy.
#' @return A list containing the codes associated with the count distribution assumed for the latent variable N and the chosen link.
#'
bernoulli <- function(link = "logit"){
  out <- stats::binomial(link)
  out$family <- "bernoulli"
  return(out)
}


#' Implemented link functions for the promotion time cure rate model with negative binomial distribution
#' @export
#' @aliases negbin
#' @description This function is used to specify different link functions for the count component of the promotion time cure rate model.
#' @param zeta The known value of the additional parameter.
#' @param link desired link function; currently implemented links are: log, identity and sqrt.
#' @return A list containing the codes associated with the count distribution assumed for the latent variable N and the chosen link.
#'
negbin <- function(zeta = stop("'theta' must be specified"), link = "log"){
  out <- MASS::negative.binomial(theta = zeta, link = link)
  return(out)
}



probCure <- function(incidence, mu, zeta = NULL){
  prob <- switch (incidence$family,
                  "bernoulli" = 1-mu,
                  "poisson" = exp(-mu),
                  "negbin" = (1+zeta*mu)^(-1/zeta),
                  "bell" = exp(-exp(LambertW::W(mu))+1)
  )
  return(prob)
}

invAp <- function(u, incidence, mu, zeta = NULL){
  if(incidence$family == "bell"){
    theta <- LambertW::W(mu)
  }
  inv <- switch (incidence$family,
                 "bernoulli" = (u - 1 + mu)/mu,
                 "poisson" = (log(u) + mu)/mu,
                 "negbin" = 1 - (u^(-zeta) - 1)/(zeta*mu),
                 "bell" = log(log(u) + exp(theta))/theta
  )
  return(inv)
}


#' Inverse of the probability generating function
#' @export
#' @aliases inv_pgf
#' @description This function is used to specify different link functions for the count component of the promotion time cure rate model
#' @param formula formula specifying the linear predictor for the incidence sub-model.
#' @param incidence the desired incidence model.
#' @param kappa vector of regression coefficients associated with the incidence sub-model.
#' @param zeta extra negative-binomial parameter.
#' @param data a data.frame containing the explanatory covariates passed to the formula.
#' @param ... further arguments passed to other methods.
#' @return A vector with the values of the inverse of the desired probability generating function.
#'
inv_pgf <- function(formula,
                      incidence = "bernoulli",
                      kappa = NULL, zeta = NULL, data, ...){
  if(missing(data)){
    mf <- stats::model.frame(formula=formula)
  }else{
    mf <- stats::model.frame(formula=formula, data=data)
  }
  if(is.character(incidence)){
    incidence <- get(incidence, mode = "function")
    incidence <- incidence()
  }
  X <- stats::model.matrix(formula, data = mf, rhs = 1, ...)
  n <- nrow(X)
  u <- stats::runif(n)
  lp <- as.numeric(X%*%kappa)
  off <- stats::model.offset(mf)
  if(!is.null(off)){
    lp <- lp + off
  }
  mu <- incidence$linkinv(lp)
  pcure <- probCure(incidence, mu = mu, zeta = zeta)
  is_cured <- u <= pcure
  v <- suppressWarnings(invAp(u, incidence = incidence, mu = mu, zeta = zeta))
  v[is_cured] <- 0
  return(v)
}
