# dots and line plot
plot(1:10, type = "o")
hist(rnorm(1000))

# two y axes and saving original par
original_par <- par(mar = c(5, 4, 4, 4)) 
original_par
plot(1:10, type = "o", col = "blue", ylab = NA, xlab = NA)
par(new = TRUE)
plot(rnorm(10), type = "o", col = "red", axes = FALSE, ylab = NA)
axis(side = 4)
mtext(side = 4, line = 2.5, col = "red", "Stock1")
mtext(side = 2, line = 2.5, col = "blue", "Stock2")
par(original_par)

## saving save plots
# png, jpeg, tiff, pdf
?png
png("graphs/example.png")
plot(1:10)
dev.off()

pdf("graphs/example.pdf")
plot(1:10)
dev.off()

## importing tabular data into R
t1 <- read.table("data/test.tsv")
t1 <- read.table("data/test.tsv", header = T) # if you have col names
t1
read.table() # na.option= blank, NaN, NA
t2 <- read.csv("data/test.csv", header = T) 
t2
t3 <- read.csv2("data/test2.csv", header = T) # if decimals are commas ","
t3
t4 <- read.table("data/test2.csv", dec = ",", sep = ";", header = T,)
t4 # not correct
t5 <- read.csv("data/test2.csv", header = T, dec = ",", sep = ";") 
t5 # correct

# stringsAsFactors option
library(dplyr)
tbl_df(t5) # string are imported as factors!!!
t6 <- read.csv("data/test2.csv", 
               header = T, 
               dec = ",", sep = ";",
               stringsAsFactors = FALSE) 
t6 # correct
tbl_df(t6) #

# skip - if we want to skip lines
t7 <- read.csv("data/test2.csv", skip=1,
               dec = ",", sep = ";", header = F,
               stringsAsFactors = FALSE) 
t7
read.csv()# ok
# readr package
# read_csv() # much more strickter about options
# import excel files
install.packages("readxl")
library(readxl)
xlsfile <- "data/ECIS_140317_MFT_1.xls"
xlsfile
# display what sheets we have in our excel file
sheets <- excel_sheets(path = xlsfile)
sheets
sheets[3]
z <- read_excel(path = xlsfile, sheet = sheets[3])
dim(z)
z[1:6, 1:5]

# copy-pasted text
zz <- textConnection("1   0.00079444 22405.12 21916.50 21420.50 21100.00
2   0.27900694 22870.81 22201.26 21519.75 21266.26")
zz
scan(zz) 
