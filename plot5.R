library(dplyr)
library(ggplot2)

# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

#download data set
if(!file.exists("data")){dir.create("data")}
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileurl, destfile = "./data/emissions.zip")

#unzip file
unzip(zipfile = "./data/emissions.zip", exdir = "./data")

#read in data
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds") 


#subset baltimore and on-road vehicles
baltimore_onroad <- NEI %>% filter(fips == "24510") %>% filter(type == "ON-ROAD")

#aggreate total emissions of subset by year- aggregate function splits the data into subsets and computes summary statistics for each
baltimore_onroad_year <- aggregate(Emissions ~ year, baltimore_onroad, sum)

#open graphing device
png("plot5.png", width = 800, height = 550)

#create ggplot
g <- ggplot(baltimore_onroad_year, 
            aes(x = factor(year), y = Emissions, fill = year, label = round(Emissions,2)))
x <- g + geom_bar(stat = "identity") +
      xlab("year") +
      ylab(expression("total PM"[2.5]*" emissions in tons")) +
      ggtitle("Emissions from on-road vehicles from 1999-2008 in Baltimore City, Maryland") +
      geom_label(aes(fill = year), col = "white", fontface = "bold") +
      theme(legend.position = "none") +
      theme(axis.title.x=element_text(vjust=-2)) +
      theme(axis.title.y=element_text(angle=90, vjust=-0.5)) +
      theme(plot.title=element_text(size=20, vjust=3)) +
      theme(plot.margin = unit(c(1,1,1,1), "cm"))
show(x)

#close graphing device
dev.off()

