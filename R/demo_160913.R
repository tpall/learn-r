# Base R graphics
a <- rnorm(100, mean = 0, sd =1) # random normal distribution
a
plot(a) # most basic plot
# two numeric vectors
b <- rnorm(100, mean = 1, sd =1)
plot(x = a, y = b) # seems that we created scatterplot
# factor on the x axis
d <- rep(c("m","f"), each =50)
d
d <- as.factor(d) # convert charcter vector into factor
d # factors
plot(x = d, y = a) # now we get boxplot
# lets plot this factor vector
plot(d)
# lets put factor into y axis
plot(y = d, x = b) # f = 1 and m = 2 

# more than 2 numeric vectors
e <- runif(29) # random uniform distribution
e <- runif(100)
plot(a,b,e) # ups, nothing happens
library(dplyr)
df <- data_frame(a,b,e)
df
plot(df)
# tuning basic plots
par()
# iris datasat
head(iris)
plot(iris$Sepal.Length)
# scatterplot to explore relationship between sep.length and width
plot(iris$Sepal.Length, iris$Sepal.Width)

plot(iris$Sepal.Length, iris$Sepal.Width, 
     col = iris$Species)
legend("topright", legend = iris$Species) # ups


# legend need to be colored by factor levels
levels(iris$Species)
plot(iris$Sepal.Length, iris$Sepal.Width, 
     col = iris$Species,
     pch = 16, # symbol/shape
     main = "Iris dataset",  # main title
     ylab = "Sepal width", # y axis label
     xlab = "Sepal length", # x axis label
     las = 1) # horizontal y axis labels 
legend("topright", 
       legend = levels(iris$Species), # legend labes
       pch = 16, # add symbols to legend
       col = 1:3) # ok, colors 1:3 from default pallette

# and pallette is
palette() # default palette

?legend
# legend outside of the plot..is complicated
par(mar()) # you have to specify extra space outside of your plot
plot(iris$Sepal.Length, iris$Sepal.Width, 
     col = iris$Species,
     pch = 16, # symbol/shape
     main = "Iris dataset",  # main title
     ylab = "Sepal width", # y axis label
     xlab = "Sepal length", # x axis label
     las = 1) # horizontal y axis labels 
legend(c(7, 4), # 
       legend = levels(iris$Species), # legend labes
       pch = 16, # add symbols to legend
       col = 1:3) # ok, colors 1:3 from default pallette

# again, matrix of scatterplots 
plot(iris[,1:4])

# what if we want to display relationship between independent and dependent variable
head(CO2)
plot(x = CO2$conc, y = CO2$uptake,
     pch = 16,
     col = "blue",
     main = " CO2 uptake in grass plants",
     las = 1)
# lets add linear regression line
linm <- lm(uptake~conc, data = CO2) 
linm
abline(linm, col = "red")
# lets add formula  y = b + ax

coefs <- coef(linm) # extracted lin mod coeficents
coefs
b0 <- round(coefs[1], digits = 2) # intercept
b0 # rounding is necessary only for nice plotting
b1 <- round(coefs[2], digits = 2) # slope
b1
summary(linm) # linear model summary contains r-sqared value
str(summary(linm)) # this is a list
r2 <- summary(linm)$r.squared # extract r-sqared or any other object from summary
r2
r2 <- round(r2, digits = 2)
r2
# now we have to create the formula
eqn <- bquote(italic(y) == .(b0) + .(b1)*italic(x))
# after creating equation, we add this thing into our plot
text(750, 25, labels = eqn)  # place formula into plot
text(750, 20, labels = bquote(r^2 == .(r2))) # add r-squared to plot

# add non-lin fit to your plot
plot(x = CO2$conc, y = CO2$uptake,
     pch = 16,
     col = "blue",
     main = " CO2 uptake in grass plants",
     las = 1)
predict(linm) # predict using provided x values
lines(x = CO2$conc, 
      y = predict(linm), 
      col = "red",
      lty = 2)
nlfit <- nls(uptake~SSlogis(conc, Asym, xmid, scal), data = CO2)
nlfit
xvals <- seq(from = 95, to = 1000, by = 3) # sequence of x-s
lines(x = xvals, 
      y = predict(nlfit, list(conc = xvals)),
      col = "green",
      lty = 2)
legend("bottomright", 
       legend = c("linear model", "exponential model"),
       col = c("red", "green"),
       lty = 2)
# Histogram 
"data/Tartu_Maraton_2013.RData"
save(tm_2013, file = "data/Tartu_Maraton_2013.RData")
load("data/Tartu_Maraton_2013.RData")
head(tm_2013)

install.packages("lubridate")
library(lubridate)
times <- hms(tm_2013$Aeg[-1]) # 
head(times) # times as hours, min and seconds
# we need to convert h:m:s into decimal hours
as.duration(times[1:5]) # times as duration 
times <- unclass(as.duration(times))/3600 # unclass stript off unnecessary attributes and we get seconds and 1hour == 3600s
head(times) # now we have decimal hours to plot on histogram

# where am I?
tp <- tm_2013[tm_2013$Nimi=="Päll, Taavi", ]$Aeg # TPs time in H:M.S
tp_dec <- unclass(as.duration(hms(tp)))/3600

# lets make hitogram, finally
hist(times, breaks = 100, 
     main = "TM 2013\n63 km distance", # \n split long line
     xlab = "Time, h",
     las = 1)
abline(v = tp_dec, col = "red")

# what if we want to split our histogram after every 15 min?
hist(times, breaks = seq(2, 10, by = 0.25), # specify custom bins
     main = "TM 2013\n63 km distance", # \n split long line
     xlab = "Time, h",
     las = 1)

# barplot
counts <- table(iris$Species)
barplot(counts) 

plot(iris$Species) # same as previous two lines

plot(sample(iris$Species, 45)) # same as previous ones

# combine multiple plots
linm <- lm(uptake~conc, data = CO2) 
plot(linm)

# we have to create graphics device with 4 slots
par(mfrow = c(2,2))
plot(linm) 
dev.off()

# layout() function can be used to create more complex plot arrengments
matrix(c(1,2,3,3),2,2)
layout(matrix(c(1,2,3,3), 2, 2))
plot(rnorm(1000))
hist(rnorm(1000))
barplot(1:10)
