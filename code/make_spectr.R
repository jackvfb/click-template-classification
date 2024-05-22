#!/usr/bin/env Rscript

library(PAMpal)

# Helper plotter function
plotter <- function(study, which_plot) {
  calculateAverageSpectra(study,
                          evNum=1:length(events(study)), plot=which_plot,
                          sort=TRUE, showBreaks = FALSE, title="",
                          filterfrom_khz = 100, filterto_khz = 160,
                          ylim = c(-25, 0), flim=c(100000,160000),
                          norm=TRUE)
}

# Make figure with a concatenated spectrogram and mean spectra, side by side.
study <- readRDS(commandArgs(T)[1])
png(filename = commandArgs(T)[2], width = 6, height = 4, units = "in", res = 300)
par(mfrow=c(1,2))
plotter(study, which_plot = c(TRUE, FALSE))
plotter(study, which_plot = c(FALSE, TRUE))
dev.off()
