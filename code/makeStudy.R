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
  events(study) <- events_wo_dups(study)
  events(study) <- events_wo_detectors(study, detector_wanted)
  return(study)
}

# Usage: Process a PAMguard database with NBHF click detections
# Assumes sample rate is 384 kHz
maker <- function(db_filepath) {
  pps <- PAMpalSettings(db = db_filepath,
                        binaries = "data/bins",
                        sr_hz = 384000,
                        filterfrom_khz = 100,
                        filterto_khz = 160,
                        winLen_sec = 0.0025)
  
  study <- processPgDetections(pps = pps,
                               mode = "db")
  
  return(study)
}

# main
lapply(list.files("data/temp", full.names = TRUE),
       function (x) {
         saveRDS(cleaner(maker(x)), str_replace(x, ".sqlite3", ".study")
         )
       }
)
