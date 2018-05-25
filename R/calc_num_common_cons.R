#' Title
#'
#' @param member
#' @param f_of_f
#' @param member_conns
#'
#' @return something
#' @export
#' @import data.table
#'
#' @examples
calc_num_common_conns <- function(member, f_of_f, member_conns) {
  sum(
    c(member_conns[member_conns$member_id == member, ]$connected_member_id,
      member_conns[member_conns$connected_member_id == member, ]$member_id) %in%
      c(member_conns[member_conns$member_id == f_of_f, ]$connected_member_id,
        member_conns[member_conns$connected_member_id == f_of_f, ]$member_id),
    na.rm = TRUE)
}
