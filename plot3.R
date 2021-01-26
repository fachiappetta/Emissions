library(dplyr)
library(ggplot2)

#download data set
if(!file.exists("data")){dir.create("data")}
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileurl, destfile = "./data/emissions.zip")

#unzip file
unzip(zipfile = "./data/emissions.zip", exdir = "./data")

#read in data
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds") 

#subset baltimore
baltimore <- NEI %>% filter(fips == "24510")

#aggreate total emissions by year- aggregate function splits the data into subsets and computes summary statistics for each
baltimore_by_type <- aggregate(Emissions ~ year + type, baltimore, sum)

#create graphing device
png("plot3.png")


#create barplot
g = ggplot(data=baltimore_by_type,
           aes(x = year, y = Emissions, color = type))
g = g + geom_line() +  
      xlab("year") +
      ylab(expression('Total PM'[2.5]*" Emissions")) +
      ggtitle('Total Emissions in Baltimore City, Maryland from 1999 to 2008 by type') +
      theme(axis.title.x=element_text(vjust=-2)) +
      theme(axis.title.y=element_text(angle=90, vjust=-0.5)) +
      theme(plot.title=element_text(size=12, vjust=3)) +
      theme(plot.margin = unit(c(1,1,1,1), "cm"))
print(g)

#turn off graphing device
dev.off()





