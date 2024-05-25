#!/usr/bin/env Rscript

suppressPackageStartupMessages(library("PAMpal"))
suppressPackageStartupMessages(library("readr"))

gps <- read_csv(commandArgs(T)[1], col_select = c("Latitude", "Longitude", "UTC"))
study <- readRDS(commandArgs(T)[2])
study <- addGps(study, gps = gps, thresh = 20000)

saveRDS(study, commandArgs(T)[3])