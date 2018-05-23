#' Count Common Connections
#'
#' Counts the number of common connections that a vertex has with all its current connections.
#'
#' @param all_members The entire graph as a data frame of all edges.
#' @param member_name The current vertex for which you wish to calculate the number of common connections with each connection.
#'
#' @return A count of
#' @export
#'
#' @examples
#' g <- sample_(gnp(100, 2/100),
#'      with_vertex_(size = 3, label = ""),
#'      with_graph_(layout = layout_with_fr))
#'
#' count_common_connections(g, 1)
#'

count_common_connections <- function(all_members, member_name){

  current_member <-
    all_members %>% filter(member_id == member_name)

  print(current_member)

}
