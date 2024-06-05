
library(rsurv)

n <-  1000
simdata <- data.frame(
  age = rnorm(n),
  sex = sample(c("f", "m"), size = n, replace = TRUE)
) |>
  mutate(
    aft = raftreg(runif(n), ~ age*sex, beta = c(1, 2, -0.5), dist = "lnorm", meanlog = 0, sdlog = 1),
    ph = rphreg(runif(n), ~ age*sex, beta = c(1, 2, -0.5), dist = "lnorm", meanlog = 0, sdlog = 1),
    po = rporeg(runif(n), ~ age*sex, beta = c(1, 2, -0.5), dist = "lnorm", meanlog = 0, sdlog = 1),
    ah = rahreg(runif(n), ~ age*sex, beta = c(1, 2, -0.5), dist = "lnorm", meanlog = 0, sdlog = 1),
    yp = rypreg(runif(n), ~ age*sex, beta = c(1, 2, -0.5), phi = c(-1, -2, 0.5), dist = "lnorm", meanlog = 0, sdlog = 1),
    eh = rehreg(runif(n), ~ age*sex, beta = c(1, 2, -0.5), phi = c(-0.8, -1, 0.2), dist = "lnorm", meanlog = 0, sdlog = 1),
  )

