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

#aggreate total emissions by year- aggregate function splits the data into subsets and computes summary statistics for each
total <- aggregate(Emissions ~ year, NEI, sum)

#create graphing device
png(file ="plot1.png")
par(mar = c(6,7,5,4))

#plot total emissions per year
plot <- barplot(height=total$Emissions/1000, 
        names = total$year, 
        xlab = "Years", 
        ylab = expression("Total PM" [2.5]* " Emissions in Kilotons"),
        ylim = c(0,8000),
        main = expression("Total PM" [2.5]* " Emissions in the US"),
        col = rev(brewer.pal(6,"Blues")), #reverse the color order of the Reds Sequential color palette
        border = NA
)

#add text on top of bars
text(x = plot, y = round(total$Emissions/1000,2), label = round(total$Emissions/1000,2), pos = 3, cex = 0.8, col = "black")

#close graphing device
dev.off()
