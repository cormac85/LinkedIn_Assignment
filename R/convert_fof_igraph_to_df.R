#' Convert Friend of Friend igraph Object to Data Frame
#'
#' @param igraph_connections
#' @param friends_of_friends_vertices
#'
#' @return a data frame
#' @export
#'
#' @examples
convert_fof_igraph_to_df <- function(igraph_connections, friends_of_friends_vertices) {
  # takes an igraph object of all connections and a list of vertices of all friends of friends
  # calculated by e.g., igraph::ego(igraph_obj, order = 2, mindist = 2, mode = "all")
  friends_of_friends_df <-
    tibble::tibble(member_id = igraph::V(igraph_connections)$name,
           friend_of_friend = purrr::map(friends_of_friends_vertices, function(x) x$name))

  friends_of_friends_df <- tidyr::unnest(friends_of_friends_df, friend_of_friend)

  friends_of_friends_df %>%
    dplyr::mutate(sorted_set = purrr::map2_chr(member_id, friend_of_friend,
                                 function(x, y) paste(sort(c(x, y)), collapse = ""))) %>%
    dplyr::distinct(sorted_set, .keep_all = TRUE) %>%
    dplyr::select(-sorted_set) %>%
    dplyr::mutate_all(as.integer)
}
