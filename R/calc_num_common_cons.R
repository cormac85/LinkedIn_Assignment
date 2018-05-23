calc_num_common_conns <- function(member, f_of_f, member_conns) {
  sum(member_conns[member_id == member]$connected_member_id %in%
        member_conns[member_id == f_of_f]$connected_member_id,
      na.rm = TRUE)
}
