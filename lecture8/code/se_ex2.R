#!/usr/local/bin/Rscript


#########################################################################
##
## FILE: se_ex2.R
##
## CREATED: 27 October 2016 by Brian Williamson
##
## PURPOSE: Robust SE example for BIOST 561
##
## UPDATES:
## DDMMYY INIT COMMENTS
## ------ ---- --------
#########################################################################

## Function to run the simulation once
doOne <- function(n, beta) {
  ## create the data
  x <- rnorm(n, 0, 1)
  u <- rnorm(n, 0, 1)
  eps <- abs(x)*u
  beta0 <- 1
  y <- beta0 + beta*x + eps
  
  ## fit the linear regression model
  mod <- lm(y ~ x)
  
  ## extract model coefficients and SEs
  est <- coefficients(mod)[2]
  se <- vector("numeric", 2)
  se[1] <- sqrt(diag(vcov(mod)))[2]
  se[2] <- sqrt(diag(vcovHC(mod, "HC0")))[2]
  
  ## Create CIs
  ci <- est + se %o% qnorm(c(0.025, 0.975))
  cover <- beta > ci[, 1] & beta < ci[, 2]
  names(cover) <- c("Model", "Sandwich")
  
  ## return
  return(c(est, cover))
}

## get the array task id
job.id <- as.numeric(Sys.getenv("SGE_TASK_ID"))

## set up simulation parameters
ns <- c(50, 300, 500)
B <- 1000 # note this is because I submit 5 jobs for each setting, 15 total jobs
truebeta <- 2

## set up parameter grid
param.grid <- expand.grid(ns, truebeta)
param.grid$B <- B
param.grid$seed <- param.grid[, 1] + param.grid[, 2] + job.id
names(param.grid) <- c("n", "truebeta", "B", "seed")

## grab the current settings
## if 1, 4, 7, 10, 13 then use n = 50
## if 2, 5, 8, 11, 14 then use n = 300
## if 3, 6, 9, 12, 15 then use n = 500
current <- param.grid[ifelse(job.id %% 3 == 0, 3, job.id %% 3), ]
library(sandwich)
set.seed(current$seed)
system.time(output <- replicate(B, doOne(n = current$n, 
                                         beta = current$truebeta)))
save(output, file = paste("ex2_output_b_", current$B, "_s_", 
                          current$seed, "_n_", current$n, 
                          "_beta_", current$truebeta, 
                          "_t_", job.id, ".Rdata", sep = ""))