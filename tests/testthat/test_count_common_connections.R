testthat::context("Common Connections")

test_that("basic counting of common connections works",{
  edges_df <-
    tribble(
      ~member, ~member_connection,
      1, 2,
      1, 3,
      1, 4,
      2, 4,
      3, 4,
      4, 5)

  testthat::expect_equal()

})
