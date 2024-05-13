#!/usr/bin/env Rscript

library(PAMpal)
library(stringr)

# Returns events with duplicates removed
events_wo_dups <- function(study) { 
  evs <- names(events(study))
  keep <- !duplicated(evs)
  return(events(study)[keep])
}

# Returns events with all but the named detector_wanted removed
events_wo_detectors <- function(study, detector_wanted) {
  evs <- events(study)
  for (i in seq_along(evs)) {
    e <- evs[[i]]
    choose <- grep(detector_wanted, names(detectors(e)))
    detectors(e) <- detectors(e)[choose]
    evs[[i]] <- e
  }
  return(evs)
}

# Cleaner function that returns cleaned study
cleaner <- function(study, detector_wanted = "Click_Detector_101") {
  s <- study
  events(s) <- events_wo_dups(s)
  events(s) <- events_wo_detectors(s, detector_wanted)
  return(s)
}

# main
lapply(list.files("data/temp", pattern = "*.study", full.names = TRUE),
       function (x) {
         saveRDS(cleaner(readRDS(x)), str_replace(x, ".study", ".clean")
                 )
         }
       )
