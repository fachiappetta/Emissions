library(dplyr)
library(ggplot2)

# Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?

#download data set
if(!file.exists("data")){dir.create("data")}
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileurl, destfile = "./data/emissions.zip")

#unzip file
unzip(zipfile = "./data/emissions.zip", exdir = "./data")

#read in data
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds") 

#merge data
NEI_SCC <- merge(NEI,SCC)

#find all cases where coal is in NEI_SCC$EI.SECTOR and subset data based on TRUE values
matches_coal <- grepl("coal", NEI_SCC$EI.Sector, ignore.case=TRUE)
coal_emissions <- NEI_SCC[matches_coal, ]

#aggreate total emissions by year- aggregate function splits the data into subsets and computes summary statistics for each
coal_emissions_year <- aggregate(Emissions ~ year, coal_emissions, sum)

#open graphing device
png("plot4.png", width = 800, height = 550)

#create ggplot
g <- ggplot(coal_emissions_year, 
            aes(x = factor(year), y = Emissions/1000, fill = year, label = round(Emissions/1000,2)))
x <- g + geom_bar(stat = "identity") +
      xlab("year") +
      ylab(expression("total PM"[2.5]*" emissions in kilotons")) +
      ggtitle("Emissions from coal combustion-related sources from 1999-2008 in the US") +
      geom_label(aes(fill = year), col = "white", fontface = "bold") +
      theme(legend.position = "none") +
      theme(axis.title.x=element_text(vjust=-2)) +
      theme(axis.title.y=element_text(angle=90, vjust=-0.5)) +
      theme(plot.title=element_text(size=20, vjust=3)) +
      theme(plot.margin = unit(c(1,1,1,1), "cm"))
show(x)

#close graphing device
dev.off()












