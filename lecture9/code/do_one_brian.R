## run the simulation one time:
## (1) generate data
## (2) compute the estimator
## (3) compute a confidence interval
## (4) return the estimator and confidence interval

## ARGS:    n - the sample size
##       beta - the true effect size
## RETURNS: a vector with the estimate of beta and a CI for beta
do_one <- function(n, beta) {
  ## generate data
  df <- generate_data(n, beta)
  
  ## fit the linear regression model
  mod <- lm(y ~ x, data = df)
  
  ## extract model coefficients and SEs
  est <- coefficients(mod)[2]
  se <- vector("numeric", 2)
  ## model-based SEs
  se[1] <- sqrt(diag(vcov(mod)))[2]
  ## robust SEs
  se[2] <- sqrt(diag(sandwich::vcovHC(mod, "HC0")))[2]
  
  ## Create CIs
  ci <- est + se %o% qnorm(c(0.025, 0.975))
  
  ## return
  output <- tibble::tibble(n = rep(n, 2), beta = rep(beta, 2), 
                           est = rep(est, 2), 
                           cil = ci[, 1], ciu = ci[, 2],
                           type = c("Model", "Sandwich"))
  return(output)
}