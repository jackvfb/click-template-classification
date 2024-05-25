#!/usr/bin/env Rscript

suppressPackageStartupMessages(library("PAMpal"))
suppressPackageStartupMessages(library("stringr"))

# Lookup species ID code based on pattern matching with input file
patterns <- c(pd="Dalls", ks="Ksp", pp ="Harbor")
id <- names(patterns[sapply(patterns, grepl, commandArgs(T)[1])])

study <- readRDS(commandArgs(T)[1])
study <- setSpecies(study, method = "manual", value = id)

saveRDS(study, commandArgs(T)[2])