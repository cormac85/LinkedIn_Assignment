library(dplyr)
library(purrr)
library(data.table)
library(igraph)

get_common_connections <- function(sample_size, seed) {

  set.seed(seed)


  # Data import and setup
  members_df <-
    readr::read_csv("./linkedin_data/common_connection_200k.csv")
  members_df <- data.table::as.data.table(members_df)
  data.table::setkey(members_df, member_id)
  members_sample_df <- dplyr::sample_n(members_df, sample_size)
  members_sample_graph <- igraph::graph_from_data_frame(members_sample_df, directed = FALSE)

  # Friends of friends calculation.
  # Calculating the relationship going "out" or "in" shouldn't affect result.
  friends_of_friends_df <-
    linkedinAssignment::convert_fof_igraph_to_df(members_sample_graph,
                                                 igraph::ego(members_sample_graph, order = 2,
                                                             mindist = 2, mode = "out"))

  # Number of common connections calculation.
  friends_of_friends_df <-
    friends_of_friends_df %>%
    dplyr::mutate(count_common_connections =
                    purrr::map2_int(member_id, friend_of_friend,
                                    linkedinAssignment::calc_num_common_conns, members_df))

  return(friends_of_friends_df %>%
           arrange(count_common_connections) %>%
           top_n(10, count_common_connections))
}
