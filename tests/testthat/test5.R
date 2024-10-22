
library(rsurv)
set.seed(1234567890)


u <- runif(5)
x1 <- qexp(u, rate = 1, lower.tail = FALSE)
x2 <- qsurv(u, baseline = "exp", rate = 1)
x3 <- qsurv(u, baseline = "exp", rate = 1, package = "stats")
x4 <- qsurv(u, baseline = "gengamma.orig", shape=1, scale=1, k=1, package = "flexsurv")

cbind(x1, x2, x3, x4)

