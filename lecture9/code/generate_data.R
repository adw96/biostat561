generate_data <- function(n, beta) {
    x <- rnorm(n, 0, 1)
    u <- rnorm(n, 0, 1)
    eps <- abs(x)*u
    beta0 <- 1
    y <- beta0 + beta*x + eps  
    return(data.frame(y = y, x = x))
}
  