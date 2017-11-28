#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double t_test_cpp(NumericVector x1, NumericVector x2) {
    int n1 = x1.size();
    int n2 = x2.size();
    
    // Generate numerator and denominator
    double nume = mean(x1) - mean(x2); 
    double denom = sqrt(var(x1)/n1 + var(x2)/n2);
    return nume/denom;
}

