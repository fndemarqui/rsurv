
library(rsurv)

n <- 100
simdata <- data.frame(
  age = rnorm(n),
  sex = sample(c("f", "m"), size = n, replace = TRUE)
) |>
  mutate(
    time = rphreg(u = runif(n), ~ age+sex, beta = c(1, 0.5), dist = "weibull", scale = 2, shape = 1.5),
    rinterval(time, tau = seq(0, 5, by = 1), type = "II", prob = 0.7)
  )

