
# Generic quantile function
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

# Generic survival function for YP model
surv_yp <- function(time, lp_short, lp_long, baseline, package, ...){
  H0 <- bchaz(time, baseline, package, ...)
  ratio <- exp(lp_short - lp_long)
  Rt = expm1(H0)*ratio
  theta <- exp(lp_long)
  surv <- exp(-theta*log1p(Rt))
  return(surv)
}

# Generic survival function for EH model
surv_eh <- function(time, lp1, lp2, baseline, package, ...){
  time <- time/exp(lp1)
  H0 <- bchaz(time, baseline, package, ...)
  surv <- exp(- H0*exp(lp1+lp2))
  return(surv)
}


# Generic random generation for YP model
rYP <- function (u, baseline, lp_short, lp_long, package, lwr, upr, ...){
  # lp_short = lp_long: PH
  # lp_long = 0: PO
  # lp_short != lp_long: YP

  #-----------------------------------------------------------------------------
  # to handle truncation:
  SL <- 1
  SR <- 0
  if(lwr>0){
    SL <- surv_yp(lwr, lp_short, lp_long, baseline, package, ...)
  }
  if(lwr<Inf){
    SR <- surv_yp(upr, lp_short, lp_long, baseline, package, ...)
  }
  u <- SL - (1-u)*(SL - SR) # truncation adjustment
  ratio <- exp(lp_long - lp_short)
  kappa <- exp(lp_long)
  w <- (u^(-1/kappa) - 1) * ratio
  v <- 1/(1 + w)
  time <- qsurv(v, baseline, package, ...)
  return(time)
}

# Generic random generation for EH model
rEH <- function(u, baseline, lp1, lp2, package, lwr, upr, ...){
  #-----------------------------------------------------------------------------
  # to handle truncation:
  SL <- 1
  SR <- 0
  if(lwr>0){
    SL <- surv_eh(lwr, lp1, lp2, baseline, package, ...)
  }
  if(lwr<Inf){
    SR <- surv_eh(upr, lp1, lp2, baseline, package, ...)
  }
  u <- SL - (1-u)*(SL - SR) # truncation adjustment
  #-----------------------------------------------------------------------------
  k <- exp(lp1+lp2)
  v <- u^(1/k)
  time <- qsurv(v, baseline, package, ...)*exp(lp1)
  return(time)
}


# Generic cumulative hazard function
bchaz <- function (x, baseline, package = NULL, ...){
  if(is.null(package)){
    pfunc <- base::get(paste("p", baseline, sep = ""), mode = "function")
  }else{
    baseline <- paste0("p", baseline)
    pfunc <- utils::getFromNamespace(baseline, package)
  }
  H <- -pfunc(x, lower.tail = FALSE, log.p = TRUE, ...)
  return(H)
}
