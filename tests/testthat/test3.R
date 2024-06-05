library(rsurv)


kappa <- c(0.25, 0.5, -1.1)
n <- 1000

# generating the set of explanatory variables:
simdata <- data.frame(
  trt = sample(c("A", "B"), size = n, replace = TRUE),
  age = rnorm(n)
)

# generating the data set:
v <- inv_pgf(
  ~ trt + age,
  incidence = poisson("log"),
  kappa = kappa,
  data = simdata
)

simdata <- simdata |>
  mutate(
    t = qexp(v, rate = 1, lower.tail = FALSE),
    c = rexp(n, rate = 1)
  ) |>
  rowwise() |>
  mutate(
    time = min(t, c),
    status = as.numeric(time == t)
  ) |>
  select(-c(t, c))

