#!/usr/bin/env Rscript

library(PAMpal)
#library(stringr)
#library(ggplot2)

# studies <- list.files("data/processed", full.names = TRUE, pattern = "*.study")
# studies <- sapply(studies, readRDS, USE.NAMES = TRUE)
# names(studies) <- str_extract(names(studies), "[:lower:]{2}(?=\\.)")

plot_wrapper <- function(study, which_plot) {
  calculateAverageSpectra(study,
                          evNum=1:length(events(study)), plot=which_plot,
                          sort=TRUE, showBreaks = FALSE, title="",
                          filterfrom_khz = 100, filterto_khz = 160,
                          ylim = c(-25, 0), flim=c(100000,160000),
                          norm=TRUE)
}

plotter <- function(outfile, width, height, study) {
  png(filename = outfile, width = width, height = height,
      units = "in", res = 300)
  par(mfrow=c(1,2))
  plot_wrapper(study, which_plot = c(TRUE, FALSE))
  plot_wrapper(study, which_plot = c(FALSE, TRUE))
  dev.off()
}


args <- commandArgs(T)
plotter(args[1], args[2], args[3], readRDS(args[4]))
