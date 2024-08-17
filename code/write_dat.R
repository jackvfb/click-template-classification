suppressPackageStartupMessages(library("PAMpal"))
suppressPackageStartupMessages(library("readr"))

study <- readRDS(commandArgs(T)[1])
dat <- getClickData(study)
write_csv(dat, commandArgs(T)[2])