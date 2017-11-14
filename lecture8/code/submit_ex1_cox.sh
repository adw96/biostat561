#!/bin/sh

Rscript se_ex1.R > ex1_output_b5000_s147_n10_beta2.txt n=10 truebeta=2 seed=147 B=5000 &
Rscript se_ex1.R > ex1_output_b5000_s247_n100_beta2.txt n=100 truebeta=2 seed=247 B=5000 &
Rscript se_ex1.R > ex1_output_b5000_s347_n1000_beta2.txt n=1000 truebeta=2 seed=347 B=5000
