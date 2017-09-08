df <- data_frame(a=rnorm(6), b=rnorm(6,1))
df %>% melt %>% plot
library(reshape2)
df %>% melt %>% t.test(value~variable, data=.)
