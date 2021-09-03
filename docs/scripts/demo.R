# library(dplyr)
# library(tidyr)
# library(reshape2)
# library(ggplot2)
# library(tibble)

data() # dataset available
mtcars

head(mtcars, n = 6) # 
tail(mtcars, n = 6) # 

tail(mtcars, n = 1) # 
dim(mtcars)
LETTERS
letters
tail(LETTERS, n=1)

# data.frame 
vec1 <- c("a", 2.3, TRUE)
vec1
data.frame() # base R data frame 
library(tibble)
data_frame() # a 'tibble' data frame 
library(dplyr)
tbl_df(mtcars)

# here we used vectors inside data_frame call
n <- data_frame(height = c(187, 190, 165), name = c("Jim", "John", "Anu"), 
           sex = factor(c("M","M","F")))
# we created vectors first
height <- c(187, 190, 165)
name <- c("Jim", "John", "Anu") 
sex <- factor(c("M","M","F"))
n <- data_frame(a=name, b=height, d=sex) # you can give different names 
n <- data_frame(name, height, sex)
n

summary(n)
names(n) # in case of data.frame gives col names
colnames(n) # query col names
colnames(n) <- c("a","b","c") # set colnames  
colnames(n)
colnames(n)[2] <- "a" # change the name of the 2nd col
colnames(n)

rownames(n) # same applies for rownames
# how many rows and cols do we have?
nrow(n) # number of rows
ncol(n) # number of column
s <- dim(n)
s
s[1] # number of rows
s[2] # n of cols

dim(mtcars) # 32 rows and 11 columns
mtc <- tbl_df(mtcars)
mtc

# lets take smaller subset from out mtc data_frame
i <- sample(1:nrow(mtc), 6)
mtc <- mtc[i, ]

# select 2nd column from mtc
mtc[,2] # preferable; returns a data.frame 
mtc[3] # works too; returns a data.frame
mtc[,"drat"] #returns a data.frame
mtc$'wt' # returns vector!!!
colnames(mtc)[11] <- "car b"
colnames(mtc)
mtc$'car b' # weird col names; returns a vector

mtc2 <- tbl_df(mtcars)
# lets filter our rows!
mtc2[mtc2$cyl>4,] # bigger than
mtc2[mtc2$cyl>=6,] # bigger than or equal
mtc2[mtc2$cyl==6,] # equal to
mtc2[1:2, 3:4] # selects rows 1 to 2 and cols 3 to 4
mtc2[c(1,4,6),c(2,9)] # use vectors insde [,] for subsetting
mtc2[c(1,4,6),-c(2,9)] # use  minus sign befor indexing vector to drop columns or rows

mtc2[mtc2$cyl!=6,] # not equal to
!mtc2$cyl==6 # use ! to reverse logical evaluation
mtc2[mtc2$cyl!=6,] # not equal to
mtc2[!mtc2$cyl==6,] # not equal to

# duplicated row
df <- data_frame(M = c(2,3,4,3),
                 N = c(34,3,8,3),
                 L = c(TRUE,FALSE,FALSE,FALSE))
df
# remove duplicated rows
d <- duplicated(df)
sum(d) # nb! TRUE == 1 and FALSE == 0
df[!duplicated(df),] # drop duplicates, use '!'

# using several criteria to subset data_frame
mtcars[mtcars$hp>mean(mtcars$hp),] # cars with above average horsepower
mtcars[mtcars$hp>mean(mtcars$hp) & mtcars$cyl==6,] # above average hp and 6 cyl
mtcars[mtcars$hp<mean(mtcars$hp) | mtcars$cyl!=4,] # above average hp and 6 cyl

# simple statistics on filtered data
median(mtcars$hp[mtcars$hp>mean(mtcars$hp)])

# median horsepower
median(mtcars$hp)

# add column to data frame
df
df$new <- c(rnorm(4))
df
ncol(df)
df[,5] <- c(runif(4))
df
df[,7] <- c(runif(4)) # can't leave holes in data frame! 

# create new column by summing 
df$sum <- df$new + df$V5

### matrix
m <- matrix(rnorm(50), ncol = 10)
m
t(m)
t(as.data.frame(m)) # data.frame is converted to matrix in transpose

### list
df_list <- c(df)
df_list
names(df_list) # vector of names of our list object

df_list[[2]] # values in the second element
df_list[2] # values in the second element
class(df_list[[2]]) # numeric
class(df_list[2]) # list
df_list$L # values in the element called L. NB! list elem. must have names

# recursive indexing
# what if we want to get third element from second elemnt of list
a<-df_list[2]

a
a[[1]][4]

# values from statistical tests
a <- rnorm(10) # random normal vector with mean 0
a
mean(a)
b <- rnorm(10,2) # random normal vector with mean 2
b
mean(b)
t.test(a, b)
t.result <- t.test(a, b) # t test
t.result
str(t.result) # str() displays the internal structure of an R object
pvalue <- t.result$p.value
pvalue
round(pvalue, 4)

