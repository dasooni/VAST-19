library(bayestestR)
library(ggplot2)

data <- read.csv("./MC1/mc1-reports-data.csv")


loc <- data$location
power <- data[c("power", "location")]
sewer <- data[c("sewer_and_water", "location")]

z <- 1.960

x <- mean(data$power)
s <- sd(data$power)
n <- 83070

lower <- x - z * (s / sqrt(n))
upper <- x + z * (s / sqrt(n))

c_plot <- ggplot(power, aes(location, power))
c_plot + geom_point()
c_plot + geom_errorbar(aes(ymin = lower, ymax = upper))

plot(c_plot)