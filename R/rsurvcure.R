#' Implemented link functions for the mixture cure rate model
#' @export
#' @aliases bernoulli
#' @description This function is used to specify different link functions for the count component of the mixture cure rate model.
#' @param link desired link function; currently implemented links are: logit, probit, cloglog and cauchy.
#' @return A list containing the codes associated with the count distribution assumed for the latent variable N and the chosen link.
#'
bernoulli <- function(link = c("logit", "probit", "cloglog", "cauchy")){
  link <- match.arg(link)
  link <- switch(link,
                 logit = 1,
                 probit = 2,
                 cloglog = 3,
                 cauchy = 4
  )
  out <- list(count_dist = 1, link = link)
  return(out)
}



#' Implemented link functions for the promotion time cure rate model with Poisson distribution.
#' @export
#' @aliases poisson
#' @description This function is used to specify different link functions for the count component of the promotion time cure rate model.
#' @param link desired link function; currently implemented links are: log, identity and sqrt.
#' @return A list containing the codes associated with the count distribution assumed for the latent variable N and the chosen link.
#'
poisson <- function(link = c("log", "identity", "sqrt")){
  link <- match.arg(link)
  link <- switch(link,
                 log = 1,
                 identity = 2,
                 sqrt = 3
  )
  out <- list(count_dist = 2, link = link)
  return(out)
}

#' Implemented link functions for the promotion time cure rate model with negative binomial distribution.
#' @export
#' @aliases negbin
#' @description This function is used to specify different link functions for the count component of the promotion time cure rate model.
#' @param link desired link function; currently implemented links are: log, identity and sqrt.
#' @return A list containing the codes associated with the count distribution assumed for the latent variable N and the chosen link.
#'
negbin <- function(link = c("log", "identity", "sqrt")){
  link <- match.arg(link)
  link <- switch(link,
                 log = 1,
                 identity = 2,
                 sqrt = 3
  )
  out <- list(count_dist = 3, link = link)
  return(out)
}

#' Implemented link functions for the promotion time cure rate model with Bell distribution.
#' @export
#' @aliases bell
#' @description This function is used to specify different link functions for the count component of the promotion time cure rate model.
#' @param link desired link function; currently implemented links are: log, identity and sqrt.
#' @return A list containing the codes associated with the count distribution assumed for the latent variable N and the chosen link.
#'
bell <- function(link = c("log", "identity", "sqrt")){
  link <- match.arg(link)
  link <- switch(link,
                 log = 1,
                 identity = 2,
                 sqrt = 3
  )
  out <- list(count_dist = 4, link = link)
  return(out)
}


extract_incidence <- function(incidence = c("bernoulli", "poisson", "negbin",  "bell")){
  if(is.character(incidence[1])){
    count_dist <- match.arg(incidence)
    count_dist <- switch(count_dist,
                         bernoulli = 1,
                         poisson = 2,
                         negbin = 3,
                         bell = 4,)
    incidence <- list(count_dist = count_dist,
                      link = 1)
  }
  return(incidence)
}

invlinks <- function(incidence, lp){
  incidence <- extract_incidence(incidence)
  dist <- incidence$count_dist
  link <- incidence$link
  if(dist == 1){
    mu <- switch (link,
                  "1" = 1/(1+exp(-lp)),
                  "2" = stats::pnorm(lp),
                  "3" = 1 - exp(-exp(lp))
    )
  }else{
    mu <- switch (link,
                  "1" = exp(lp),
                  "2" = lp,
                  "3" = sqrt(lp)
    )
  }
}


probCure <- function(incidence, mu, zeta = NULL){
  prob <- switch (incidence[[1]],
                  "1" = 1-mu,
                  "2" = exp(-mu),
                  "3" = (1+zeta*mu)^(-1/zeta),
                  "4" = exp(-exp(LambertW::W(mu))+1)
  )
  return(prob)
}

invAp <- function(u, incidence, mu, zeta = NULL){
  if(incidence[[1]] == "4"){
    theta <- LambertW::W(mu)
  }
  inv <- switch (incidence[[1]],
                 "1" = (u - 1 + mu)/mu,
                 "2" = (log(u) + mu)/mu,
                 "3" = 1 - (u^(-zeta) - 1)/(zeta*mu),
                 "4" = log(log(u) + exp(theta))/theta
  )
  return(inv)
}


#' Inverse of the probability generating function
#' @export
#' @aliases inv_pgf
#' @description This function is used to specify different link functions for the count component of the promotion time cure rate model.
#' @param formula formula specifying the linear predictor for the incidence sub-model.
#' @param incidence the desired incidence model.
#' @param kappa vector of regression coefficients associated with the incidence sub-model.
#' @param zeta extra negative-binomial parameter.
#' @param data a data.frame containing the explanatory covariates passed to the formula.
#' @param ... further arguments passed to other methods.
#' @return A vector with the values of the inverse of the desired probability generating function.
#'
inv_pgf <- function(formula,
                      incidence = c("bernoulli", "poisson", "negbin",  "bell"),
                      kappa = NULL, zeta = NULL, data, ...){
  incidence <- extract_incidence(incidence)
  if(missing(data)){
    mf <- stats::model.frame(formula=formula)
  }else{
    mf <- stats::model.frame(formula=formula, data=data)
  }
  X <- stats::model.matrix(formula, data = mf, rhs = 1)
  n <- nrow(X)
  u <- stats::runif(n)
  lp <- as.numeric(X%*%kappa)
  off <- stats::model.offset(mf)
  if(!is.null(off)){
    lp <- lp + off
  }
  mu <- invlinks(incidence, lp)
  pcure <- probCure(incidence, mu = mu, zeta = zeta)
  is_cured <- u <= pcure
  v <- suppressWarnings(invAp(u, incidence = incidence, mu = mu, zeta = zeta))
  v[is_cured] <- 0
  return(v)
}
