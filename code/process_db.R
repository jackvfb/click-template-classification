suppressPackageStartupMessages(library("PAMpal"))

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
#    - db: connection to PAMguard database file
#    - bins: connection to PAMguard binaries file
#
# Parameters:
#    - sample rate is 384 kHz
#    - high-pass filter = 100 kHz,
#    - low-pass = 160 kHz
#    - window length = 0.25 ms
maker <- function(db, bins) {
  pps <- PAMpalSettings(db = db,
                        binaries = bins,
                        sr_hz = 384000,
                        filterfrom_khz = 100,
                        filterto_khz = 160,
                        winLen_sec = 0.0025)
  
  study <- processPgDetections(pps = pps,
                                mode = "recording")

  return(study)
}

# Process database into AcousticStudy, and clean
study <- maker(commandArgs(T)[1], commandArgs(T)[2])
#events(study) <- events_wo_dups(study)
#events(study) <- events_wo_detectors(study)
saveRDS(study, commandArgs(T)[3])