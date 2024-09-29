library(targets)
library(tarchetypes)
library(future)

source("functions.R")

plan(multisession, workers = 8)

values <- tibble(
  path = list.dirs("data", recursive = FALSE),
  sp_id = c("pd", "pd", "pp", "pp", "pp", "pd", "ks", "ks"),
  drift = basename(path)
)

list(tar_map(
  values = values,
  names = "drift",
  tar_target(study, make_study(path, sp_id), deployment = "worker"
             ),
  tar_target(clicks, PAMpal::getClickData(study)),
  tar_target(join, do_join(path, clicks), deployment = "worker")
  )
)       

