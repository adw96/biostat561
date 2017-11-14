#!/usr/local/bin/Rscript

## read in the parameter(s)
args <- commandArgs(TRUE)

if (length(args) == 0) {
  print("No arguments supplied.")
} else {
  for (i in 1:length(args)) {
    eval(parse(text = args[i]))
  }
}

if (!exists("myn")) {
  myn <- 300
  cat("Note: assuming n = 100")
} 
if (!exists("myseed")) {
  myseed <- 47
  cat("Note: setting seed to be 47")
} 
if (!exists("myB")) {
  myB <- 1000
  cat("Note: running 1000 replications")
} 

#################################################################################################################
##
## FILE: permutation_test_example_guiless.R
##
## CREATED: 22 October 2016 by Brian Williamson
##
## PURPOSE: Run a permutation test example for BIOST 561, Autumn 2016
##
## UPDATES:
## DDMMYY INIT COMMENTS
## ------ ---- --------
#################################################################################################################

## function to do one permutation test
## FUNCTION: do.one
## ARGS: x - the covariate
##       y - the outcome
## RETURNS: the results of one permutation test (i.e. difference in means, for us)
oneTest <- function(x, y) {
  ## get a new bootstrap sample of x
  xstar <- sample(x)
  
  ## return the difference in means
  ret <- mean(y[xstar == 1]) - mean(y[xstar == 0])
  
  return(ret)
}

## Function to do the permutation test, including generating data
## ARGS: n - sample size
##       B - number of MC reps
## RETURNS: the results of the permutation test (sampling distribution and p-value)
permTestSNP <- function(n, B) {
  ## make the genotypes (0/1)
  carrier <- rep(c(0, 1), c(n/3, 2*n/3)) 
  
  ## make y under the null hypothesis
  null.y <- rnorm(n) 
  
  ## make y under the alternative hypothesis
  alt.y <- rnorm(n, mean = carrier/2) 
  
  ## run the test B times
  output.truenull <- replicate(B, oneTest(carrier, null.y)) 
  output.falsenull <- replicate(B, oneTest(carrier, alt.y))
  
  ## get the observed difference in means
  null.diff <- mean(null.y[carrier == 1]) - mean(null.y[carrier == 0])
  alt.diff <- mean(alt.y[carrier == 1]) - mean(alt.y[carrier == 0])
  
  ## return the sampling distribution and the p-values
  return(list(samp.truenull = output.truenull, samp.falsenull = output.falsenull,
              p.truenull = mean(abs(output.truenull)) > abs(null.diff),
              p.falsenull = mean(abs(output.falsenull)) > abs(alt.diff))
  )
}

## actually run the simulation
set.seed(myseed)
system.time(output <- permTestSNP(n = myn, B = myB))
save(output, file = paste("perm_test_output_n_", myn, 
                   "_s_", myseed, "_B_", myB, ".Rdata", sep = ""))
