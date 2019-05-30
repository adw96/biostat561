## Generate data

## ARGS:    n - the sample size
##       beta - the true effect size
## RETURNS: a dataset (two columns, x and y; n rows)
generate_data <- function(n, beta) {
    ## generate x
    x <- rnorm(n, 0, 1)
    ## generate independent errors
    u <- rnorm(n, 0, 1)
    ## generate dependent errors for y
    eps <- abs(x)*u
    ## set the intercept (always 1)
    beta0 <- 1
    ## generate outcome data
    y <- beta0 + beta*x + eps  
    ## return a data.frame with x, y
    return(data.frame(y = y, x = x))
}
  