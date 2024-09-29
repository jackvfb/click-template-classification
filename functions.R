library(PAMpal)
library(tidyverse)

# Returns events with duplicates removed
events_wo_dups <- function(study) { 
  evs <- names(events(study))
  keep <- !duplicated(evs)
  return(events(study)[keep])
}

# Returns events with all but the named detector "Click_Detector_101" removed
events_wo_detectors <- function(study) {
  evs <- events(study)
  for (i in seq_along(evs)) {
    e <- evs[[i]]
    choose <- grep("Click_Detector_101", names(detectors(e)))
    detectors(e) <- detectors(e)[choose]
    evs[[i]] <- e
  }
  return(evs)
}

# Usage:
# Process a PAMguard database with NBHF click detections
# 
# Arguments:
#    - path: connection to data file containing PAMguard database file and binaries
#    - bins: connection to PAMguard binaries file
#
# Parameters:
#    - sample rate is 384 kHz
#    - high-pass filter = 100 kHz,
#    - low-pass = 160 kHz
#    - window length = 0.25 ms
#    - mode = "recording" will process ALL detections in DB
make_study <- function(path, sp_id) {
  pps <- PAMpalSettings(db = dir(path, pattern = "\\.sqlite3", full.names = TRUE),
                        binaries = path,
                        sr_hz = 384000,
                        filterfrom_khz = 100,
                        filterto_khz = 160,
                        winLen_sec = 0.0025)
  
  study <- processPgDetections(pps = pps,
                               mode = "recording")
  
  study <- setSpecies(study, method = "manual", value = sp_id)
  return(study)
}

do_join <- function(path, clicks){
  tm <- readRDS(dir(path, pattern = "Template\\.rds", full.names = TRUE))
  clicks %>%
    distinct(UID, .keep_all = TRUE) %>%
    full_join(tm, by = "UID")
}
  