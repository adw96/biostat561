#!/bin/sh

qsub -t 1-15 -cwd -e iotrash/ -o iotrash/ -shell no -b yes -m e ./call_ex2_once.sh
