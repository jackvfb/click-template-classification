#!/usr/bin/env Rscript

# Bind studies and set species. Steps needed to make a "training" study
library("PAMpal")
args <- commandArgs(T)

sp <- args[1]
to_bind <- lapply(args[2:(length(args)-1)], readRDS)
output <- args[length(args)]

bound <- bindStudies(to_bind)
bound <- setSpecies(bound, method = "manual", value = sp)
saveRDS(bound, output)