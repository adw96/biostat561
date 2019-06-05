library(microbenchmark)

t.test.me <- function(x1, x2) {
    n1 <- length(x1)
    n2 <- length(x2)
    # Generate numerator and denominator
    nume <- mean(x1) - mean(x2)
    denom <- sqrt(var(x1)/n1 + var(x2)/n2)
    
    return(nume/denom)
}

Rcpp::sourceCpp("2017-cpp/code/t_test_cpp.cpp")
set.seed(1)
x1 <- rnorm(30)
x2 <- rnorm(50)
obj <- microbenchmark(
    t.test.me(x1, x2),
    t_test_cpp(x1, x2))
print(obj, digits = 2)


Rcpp::sourceCpp("t_test_cpp.cpp")
set.seed(1)
x1 <- rnorm(30)
x2 <- rnorm(50)
t_test_cpp(x1, x2)
t.test.me(x1, x2)
