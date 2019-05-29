#!/bin/bash

## num_n is the number of unique ns for the simulation
num_n=3
njobs=`expr $2 / $3 \* $num_n`

qsub -cwd -e iotrash/ -o iotrash/ -t 1-$njobs ./call_sim_robust_se.sh $1 $2 $3