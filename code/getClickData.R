#!/usr/bin/env Rscript

library(PAMpal)
library(purrr)

args <- commandArgs(T)
outfile <- args[length(args)]

clickdat <- list_rbind(lapply(args[1:length(args)-1], FUN = getClickData))
saveRDS(clickdat, outfile)
