

## Types of join
# Mutating joins
# Mutating joins allow you to combine variables from multiple tables. 

library(dplyr)
# install.packages("nycflights13")
library("nycflights13")

# Drop unimportant variables so it's easier to understand the join results.
flights2 <- select(flights, year:day, hour, origin, dest, tailnum, carrier)
flights2 # flights with carrier abbreviations

airlines # carriers full names

left_join(flights2, airlines)

## Controlling joins: 
# default. dplyr will will use all variables that appear in both tables 
weather
left_join(flights2, weather)

## ------------------------------------------------------------------------
# A character vector, by = "x". Like a natural join, but uses only some of the common variables.
flights2 %>% left_join(planes, by = "tailnum")


## Types of join ------------------------------------------------------------------------
(df1 <- data_frame(x = c(1, 2), y = 2:1))
(df2 <- data_frame(x = c(1, 3), a = 10, b = "a"))

## ------------------------------------------------------------------------
df1 %>% inner_join(df2) %>% knitr::kable()

## ------------------------------------------------------------------------
df1 %>% left_join(df2)

## ------------------------------------------------------------------------
df1 %>% right_join(df2)
df2 %>% left_join(df1)

## ------------------------------------------------------------------------
df1 %>% full_join(df2)

## ------------------------------------------------------------------------
# Observations
# While mutating joins are primarily used to add new variables, they can also 
# generate new observations. If a match is not unique, a join will add all
# possible combinations (the Cartesian product) of the matching observations:

df1 <- data_frame(x = c(1, 1, 2), y = 1:3)
df2 <- data_frame(x = c(1, 1, 2), z = c("a", "b", "a"))

df1 %>% left_join(df2)

## ------------------------------------------------------------------------
# Filtering joins match obserations in the same way as mutating joins, 
# but affect the observations, not the variables. There are two types:

library("nycflights13")
flights %>% 
  anti_join(planes, by = "tailnum") %>% 
  count(tailnum, sort = TRUE)

## ------------------------------------------------------------------------
# If you’re worried about what observations your joins will match, start with a semi_join() or 
# anti_join(). semi_join() and anti_join() never duplicate; they only ever remove observations.
df1 <- data_frame(x = c(1, 1, 3, 4), y = 1:4)
df2 <- data_frame(x = c(1, 1, 2), z = c("a", "b", "a"))

# Four rows to start with:
df1 %>% nrow()
# And we get four rows after the join
df1 %>% inner_join(df2, by = "x") %>% nrow()
# But only two rows actually match
df1 %>% semi_join(df2, by = "x") %>% nrow()

## Set operations -------------------------------------------------------
(df1 <- data_frame(x = 1:2, y = c(1L, 1L)))
(df2 <- data_frame(x = 1:2, y = 1:2))

## ------------------------------------------------------------------------
intersect(df1, df2)
# Note that we get 3 rows, not 4
union(df1, df2)
setdiff(df1, df2)
setdiff(df2, df1)

# Coersion rules
## ------------------------------------------------------------------------
# Factors with different levels are coerced to character with a warning:
df1 <- data_frame(x = 1, y = factor("a"))
df2 <- data_frame(x = 2, y = factor("b"))
full_join(df1, df2) %>% str()

## ------------------------------------------------------------------------
# Factors with the same levels in a different order are coerced to character with a warning:
df1 <- data_frame(x = 1, y = factor("a", levels = c("a", "b")))
df2 <- data_frame(x = 2, y = factor("b", levels = c("b", "a")))
full_join(df1, df2) %>% str()

## ------------------------------------------------------------------------
# Factors are preserved only if the levels match exactly:
df1 <- data_frame(x = 1, y = factor("a", levels = c("a", "b")))
df2 <- data_frame(x = 2, y = factor("b", levels = c("a", "b")))
full_join(df1, df2) %>% str()

## ------------------------------------------------------------------------
# A factor and a character are coerced to character with a warning:
df1 <- data_frame(x = 1, y = "a")
df2 <- data_frame(x = 2, y = factor("a"))
full_join(df1, df2) %>% str()

