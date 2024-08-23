library(dplyr)
library(readr)
library(purrr)
library(ggplot2)
library(tidyr)

v_comp %>%
  ggplot(aes(x=Ksp_match))+
  geom_point()+
  facet_wrap(~species)
