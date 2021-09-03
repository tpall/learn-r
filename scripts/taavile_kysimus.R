nimi <- c("a","b","c", "d")
v1 <- c(1,2,3,60)
v2 <- c(2,3,4,2)
v3 <- c(1,40,2,3)
v4 <- c("g","b","g", "d")
df <- data.frame(nimi, v1, v2, v3, v4)

# does not work
apply(df, 2, function(x) is.numeric(x)) # apply coerces numeric to character, hence all FALSE

# works
df[,sapply(df, function(x) any(x>10))]

# evaluates only numeric cols
any_numeric_bigger_than_thresh <- function(x, threshold) ifelse(is.numeric(x), any(x>threshold), TRUE)
col_index <- sapply(df, any_numeric_bigger_than_thresh, 10)
df[,col_index] # returns character cols and cols with any value bigger than ten


