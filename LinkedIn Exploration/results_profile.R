times <- tibble::tribble(
  ~n,       ~t_load,  ~t_friend_of_friend, ~t_calc_num_common,
  1000,     11.55,    1.09,                0.09,
  10000,    11.56,    15.07,               7.82,
  50000,    13.02,    176.39,              194.65,  # 27370 --- 181110 	                   n =  114
  100000,   13.79,    546.19 ,             811.50,  # 27370 --- 181110 	121254 --- 132521  n =  114
  500000,   15.11,    1167.94,             3321.11, # 107795 --- 132521 	                 n =  127
  1000000,  NA,     NA,                NA,
  10000000, NA,     NA,                NA
)


p <- ggplot2::ggplot(
  tidyr::gather(na.omit(times), calculation, seconds, t_load, t_friend_of_friend, t_calc_num_common),
  ggplot2::aes(n, seconds, group = calculation, colour = calculation)) +
  ggplot2::geom_line() +
  ggplot2::geom_smooth(se = FALSE, linetype = 2, span = 3)

linear_model <- lm(t_calc_num_common ~ poly(n,2), na.omit(times))
lm_predictions <- data.frame(
  n = seq(0, 10e6, 10000),
  t_calc_num_common_pred = predict(linear_model, newdata = data.frame(n = seq(0, 10e6, 10000)))
  )

plot(lm_predictions[1:100,])
