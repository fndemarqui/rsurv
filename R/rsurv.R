

qsurv <- function(p, baseline, ...){
  qfunc <- get(paste("q", baseline, sep = ""), mode = "function")
  x <- qfunc(p, lower.tail = FALSE, ...)
  return(x)
}


