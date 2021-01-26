library(tidyverse)
library(dplyr)
library(RColorBrewer)

#download data set
if(!file.exists("data")){dir.create("data")}
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileurl, destfile = "./data/emissions.zip")

#unzip file
unzip(zipfile = "./data/emissions.zip", exdir = "./data")

#read in data
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

#subset Batlimore data
baltimore <- NEI %>% filter(fips == "24510")

#aggreate total emissions by year- aggregate function splits the data into subsets and computes summary statistics for each
totalbaltimore <- aggregate(Emissions ~ year, baltimore, sum)

#create graphing device
png(file ="plot2.png")
par(mar = c(6,7,5,4))

#plot total emissions per year
barplot(height=totalbaltimore$Emissions, 
        names = totalbaltimore$year, 
        xlab = "Years", 
        ylab = expression("Total PM" [2.5]* " Emissions in Tons"),
        main = expression("Total PM" [2.5]* " Emissions in Baltimore City, Maryland"),
        col = rev(brewer.pal(4,"Blues")), #reverse the color order of the Reds Sequential color palette
        text(x = totalbaltimore$year, y = round(totalbaltimore$Emissions,2), label = round(totalbaltimore$balEmissions,2), pos = 3, cex = 0.8, col = "black")
)

#close graphing device
dev.off()
