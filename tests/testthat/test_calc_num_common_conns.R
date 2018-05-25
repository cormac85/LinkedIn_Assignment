testthat::context("Common Connections")

test_that("basic counting of common connections works",{
  edges_df <-
    tibble::tribble(
      ~member_id, ~connected_member_id,
      1, 2,
      1, 3,
      1, 7,
      6, 4,
      2, 4,
      3, 4,
      4, 5,
      7, 8,
      8, 6)

  edges_igraph <- igraph::graph_from_data_frame(edges_df, directed = FALSE)

  f_of_f_df <-
    linkedinAssignment::convert_fof_igraph_to_df(edges_igraph,
                                                 igraph::ego(edges_igraph, order = 2,
                                                             mindist = 2, mode = "out"))

  testthat::expect_equal(linkedinAssignment::calc_num_common_conns(1, 4, edges_df), 2)

})
