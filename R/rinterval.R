
#' Random generation of type I and type II interval censored survival data
#' @aliases rinterval
#' @export
#' @description Function to generate a random sample of type I and type II interval censored survival data.
#' @param time a numeric vector of survival times.
#' @param tau either a vector of censoring times (for type I interval-censored survival data) or time grid of scheduled visits (for type II interval censored survival data).
#' @param type type of interval-censored survival data (I or II).
#' @param prob = 0.5 attendance probability of scheduled visit; ignored when type = I.
#' @return a data.frame containing the generated random sample.
#'
rinterval <- function(time, tau, type = c("I", "II"), prob){
  type = match.arg(type)
  J <- length(tau)
  n <- length(time)
  left <- c()
  right <- c()

  if(type == "I"){
    left <- c()
    right <- c()
    df <- data.frame(
      left = ifelse(time < tau, 0, tau),
      right = ifelse(time < tau, tau, Inf)
    )
  }else{
    for(i in 1:n){
      xi <- c(1, stats::rbinom(J-1, size = 1, p = prob))
      if(sum(xi)>1){
        limits <- tau[xi==1]
        if(time[i] > max(limits)){
          left[i] <- max(limits)
          right[i] <- Inf
        }else{
          left[i] <- max(c(0, limits[limits < time[i]]))
          right[i] <- min(limits[limits > time[i]])
        }
      }else{
        left[i] = max(limits)
        right[i] = Inf
      }

    }
    df <- data.frame(
      left = left,
      right = right
    )
  }

  return(df)
}


