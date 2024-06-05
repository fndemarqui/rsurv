library(rsurv)

n <- 1000
L <- 100
simdata <- data.frame(
  id = rep(1:L, each = n/L),
  age = rnorm(n),
  sex = sample(c("f", "m"), size = n, replace = TRUE)
) |>
  mutate(
    frailty = rfrailty(id, "gamma", sigma = 0.5),
    t = rphreg(u = runif(n), ~ age*sex + offset(frailty) , beta = c(1, 2, -0.5), dist = "exp", rate = 1),
    c = runif(n, 0, 5)
  ) |>
  rowwise() |>
  mutate(
    time = min(t, c),
    status = as.numeric(t<c)
  ) |>
  select(-c(t, c))
