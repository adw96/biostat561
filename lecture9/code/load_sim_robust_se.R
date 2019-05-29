#!/usr/local/bin/Rscript

## load results, make nice plots

## ----------------------------------------
## load packages and user-defined functions
## ----------------------------------------
## nice plots
library("ggplot2")
library("cowplot")
## tidy stuff
library("dplyr")
library("tidyr")
## command line args (if specified)
library("argparse")

## ----------------------------------------
## read in command line args (if any)
## ----------------------------------------
parser <- ArgumentParser()
parser$add_argument("--sim-name", default = "robust_ses",
                    help = "name of simulation")
parser$add_argument("--nreps-total", type = "double", default = 5000,
                    help = "number of replicates for each set of params")
parser$add_argument("--nreps-per-job", type = "double", default = 50,
                    help = "number of replicates per job")
args <- parser$parse_args()

## set up directories for output, plots
if (!is.na(Sys.getenv("RSTUDIO", unset = NA))) { # if running locally
  output_dir <- "output/"
  plots_dir <- "plots/"
} else {
  output_dir <- "output/"
  plots_dir <- "plots/"
}

## set up parameter grid
## sample sizes
ns <- c(50, 300, 500)
## true effect size
truebeta <- 2
## number of monte-carlo iterations per job
nreps_per_combo <- args$nreps_total/args$nreps_per_job
## set up grid of parameters
param_grid <- expand.grid(mc_id = 1:nreps_per_combo, beta = truebeta, n = ns)

## ----------------------------------------
## load the results
## ----------------------------------------
## names of files to read in
output_nms <- paste0(args$sim_name, "_", 1:dim(param_grid)[1], ".rds")
## list of output
output_lst <- lapply(paste0(output_dir, output_nms), read_func)
## make it a matrix
output_tib <- do.call(rbind.data.frame, output_lst)

## compute performance metrics:
## bias, variance, mse, coverage
raw_performance <- output_tib %>%
    mutate(bias = est - beta,
           mse = (est - beta)^2,
           cover = cil <= beta & ciu >= beta)
## average over everything for a given sample size
average_performance <- raw_performance %>%
    group_by(n, type) %>%
    summarize(bias = mean(bias),
              var = var(est),
              mse = mean(mse),
              cover = mean(cover),
              sd = sd(est)) %>%
    ungroup()

## ----------------------------------------
## make plots
## ----------------------------------------
point_size <- 3
text_size <- 20
y_lim_bias <- c(-0.5, 0.5)
y_lim_mse <- c(0, 2)
y_lim_var <- c(0, 2)
dodge_x <- 175
dodge_x_large <- 400
point_vals <- c(16, 13)
color_vals <- c("black", "blue")
legend_pos <- c(0.1, 0.325)
fig_width <- 30
fig_height <- 23

bias_plot <- average_performance %>%
    ggplot(aes(x = n, y = bias, group = factor(paste(n, type, sep = "_")),
           shape = type, color = type)) +
    geom_point(position = position_dodge(width = dodge_x), size = point_size) +
    geom_errorbar(aes(ymin = bias - 1.96*sd, ymax = bias + 1.96*sd), width = rep(50, dim(average_performance)[1]),
                position = position_dodge(width = dodge_x), size = 0.3*point_size) +
    ylim(y_lim_bias) +
    ylab("Estimated bias") +
    xlab("n") +
    ggtitle("Estimated bias versus n") +
    scale_color_manual(name = "Type of SEs", values = color_vals) +
    scale_shape_manual(name = "Type of SEs", values = point_vals) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
    guides(color = FALSE, shape = FALSE) +
    theme(text = element_text(size = text_size), axis.text = element_text(size = text_size),
        plot.margin = unit(c(0, 0, 0, 0), "mm"))

cover_plot <- average_performance %>%
    ggplot(aes(x = n, y = cover, group = factor(paste(n, type, sep = "_")),
           shape = type, color = type)) +
    geom_point(position = position_dodge(width = dodge_x), size = point_size) +
    ylim(c(0,1)) +
    ylab("Coverage") +
    xlab("n") +
    ggtitle("Coverage of nominal 95% CIs") +
    scale_color_manual(name = "Type of SEs", values = color_vals) +
    scale_shape_manual(name = "Type of SEs", values = point_vals) +
    geom_hline(yintercept = 0.95, linetype = "dashed", color = "red") +
    theme(legend.position = legend_pos, legend.box.background = element_rect(colour = "black"),
        text = element_text(size = text_size), axis.text = element_text(size = text_size),
        legend.text = element_text(size = text_size),
        plot.margin = unit(c(0, 0, 0, 0), "mm"))

## save the plot
full_plot <- plot_grid(bias_plot, cover_plot)
file_name <- paste0(plot_dir, args$sim_name, "_bias_cover.png")
ggsave(file_name, plot = full_plot, 
         device = "png",
         height = fig_height, width = fig_width,
         units = "cm", dpi = 300)