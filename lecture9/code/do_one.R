do_one <- function(n, beta) {
  df <- generate_data(n, beta)
  
  mod <- lm(y ~ x, data = df)
  
  est <- coefficients(mod)[2]
  se <- vector("numeric", 2)
  se[1] <- sqrt(diag(vcov(mod)))[2]
  se[2] <- sqrt(diag(sandwich::vcovHC(mod, "HC0")))[2]
  
  ci <- est + se %o% qnorm(c(0.025, 0.975))
  
  ## return
  output <- tibble::tibble(n = rep(n, 2), beta = rep(beta, 2), 
                           est = rep(est, 2), 
                           cil = ci[, 1], ciu = ci[, 2],
                           type = c("Model", "Sandwich"))
  return(c(est, ci))
}