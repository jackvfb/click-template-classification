#!/usr/bin/env Rscript

library(PAMpal)

sp <- commandArgs(T)[1]
outfile <- commandArgs(T)[2]

to_bind <- lapply(list.files("data/temp",
                             full.names = TRUE,
                             pattern = "*.study"),
                  readRDS
                  )

bound <- bindStudies(to_bind)

bound <- setSpecies(bound, method = "manual", value = sp)

saveRDS(bound, outfile)