library(tictoc)
library(tidyverse)
library(igraph)
library(data.table)

members_df <-
  read_csv("./linkedin_data/common_connection_200k.csv")

members_sample_df <-
  members_df %>% sample_n(1000000) # take a sample

members_sample_graph <-
  members_sample_df %>%
  graph_from_data_frame(directed = FALSE)
