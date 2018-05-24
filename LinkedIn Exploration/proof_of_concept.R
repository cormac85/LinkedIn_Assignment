library(dplyr)
library(purrr)
library(data.table)

run_poc <- function(sample_size) {

  set.seed(314)

  #TODO: Fix this hack because I can't get the package to export properly!
  calc_common_conns <- function(member, f_of_f, member_conns) {
    sum(member_conns[member_id == member]$connected_member_id %in%
          member_conns[member_id == f_of_f]$connected_member_id,
        na.rm = TRUE)
  }

  print_timings <- function(tocs){
    print(map_dbl(tocs, function(x) x$toc - x$tic))
    print(paste("Total Time:", round(map_dbl(tocs, function(x) x$toc - x$tic) %>% sum(), 1), "s"))
  }

  timings <- list()

  tictoc::tic("Setup")
  members_df <-
    readr::read_csv("./linkedin_data/common_connection_200k.csv")
  members_df <- data.table::as.data.table(members_df)
  data.table::setkey(members_df, member_id)
  members_sample_df <- sample_n(members_df, sample_size)
  members_sample_graph <- igraph::graph_from_data_frame(members_sample_df, directed = FALSE)
  timings$setup <- tictoc::toc()

  tictoc::tic("Friends of Friends calculation")
  friends_of_friends_df <-
    linkedinAssignment::convert_fof_igraph_to_df(members_sample_graph,
                                                 igraph::ego(members_sample_graph, order = 2,
                                                             mindist = 2, mode = "out"))
  timings$friends_of_friends <- tictoc::toc()

  tictoc::tic("Calculate 1 common connection")
  calc_common_conns(friends_of_friends_df[1,]$member_id,
                    friends_of_friends_df[1,]$friend_of_friend,
                    members_df)
  tictoc::toc()

  tictoc::tic("Calculate all sampled common connections")
  friends_of_friends_df <-
    friends_of_friends_df %>%
    dplyr::mutate(count_common_connections =
                    purrr::map2_int(member_id, friend_of_friend,
                                    calc_common_conns, members_df))

  most_connections <-
    friends_of_friends_df %>%
    arrange(count_common_connections) %>%
    top_n(1, count_common_connections)

  paste("\n***\nMost Connections:",
        most_connections$member_id, "---", most_connections$friend_of_friend,
        "\tn = ", most_connections$count_common_connections,
        "\n***\n\n") %>%
    cat()
  timings$common_connections <- tictoc::toc()

  print_timings(timings)

  return(friends_of_friends_df %>%
           arrange(count_common_connections) %>%
           top_n(10, count_common_connections))
}
