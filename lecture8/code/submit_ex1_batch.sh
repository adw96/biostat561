#!/bin/sh

B=5000
seed=47

for n in 100 300 500
do
for truebeta in {1..5}
do 
    qsub -cwd -e iotrash/ -o iotrash/ -q normal.q@b01.local ./call_ex1_once.sh $B $seed $n $truebeta
done
done