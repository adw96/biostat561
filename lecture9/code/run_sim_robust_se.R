#!/usr/local/bin/Rscript

## Run the simulation!

## -----------------------------------------
## load user-defined functions, packages
## -----------------------------------------
## make sure we have usual functions
library("methods")
## robust SEs
library("sandwich")
## get command line arguments
library("argparse")
## tidy stuff
library("dplyr")
library("tidyr")
## generate data
source("generate_data.R")
## run the simulation once
source("do_one.R")

## -----------------------------------------
## load any command line arguments
## -----------------------------------------
parser <- ArgumentParser()
parser$add_argument("--sim-name", default = "robust_ses",
                    help = "name of simulation")
parser$add_argument("--nreps-total", type = "double", default = 5000,
                    help = "number of replicates for each set of params")
parser$add_argument("--nreps-per-job", type = "double", default = 50,
                    help = "number of replicates per job")
args <- parser$parse_args()


## -----------------------------------------
## set up a grid of parameters to cycle over
## -----------------------------------------
## sample sizes
ns <- c(50, 300, 500)
## true effect size
truebeta <- 2
## number of monte-carlo iterations per job
nreps_per_combo <- args$nreps_total/args$nreps_per_job
## set up grid of parameters
param_grid <- expand.grid(mc_id = 1:nreps_per_combo, beta = truebeta, n = ns)

## -----------------------------------------
## get current dynamic arguments
## -----------------------------------------
## get job id from scheduler
job_id <- as.numeric(Sys.getenv("SGE_TASK_ID"))
## current args
current_dynamic_args <- param_grid[job_id, ]

## -----------------------------------------
## run the simulation nreps_per_job times
## -----------------------------------------
current_seed <- job_id + current_dynamic_args$n
set.seed(current_seed)
## save how long the sim took as well
system.time(output <- replicate(args$nreps_per_job,
                                do_one(n = current_dynamic_args$n,
                                       beta = current_dynamic_args$beta),
                                simplify = FALSE))
## make a nice tibble, with mc_id
sim_output <- lapply(as.list(1:length(output)), function(x) tibble::add_column(output[[x]]))
sim_output_tib <- do.call(rbind.data.frame, sim_output)
file_name <- paste0(args$sim_name, "_", job_id, ".rds")
saveRDS(sim_output_tib, file = file_name)