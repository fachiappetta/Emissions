library(dplyr)
library(ggplot2)

#Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in 
#Los Angeles County, California (fips == "06037"). 
#Which city has seen greater changes over time in motor vehicle emissions?

#download data set
if(!file.exists("data")){dir.create("data")}
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileurl, destfile = "./data/emissions.zip")

#unzip file
unzip(zipfile = "./data/emissions.zip", exdir = "./data")

#read in data
NEI <- readRDS("./data/summarySCC_PM25.rds")

#subset two municipaliries and on-road vehicles
baltimore_LA_onroad <- NEI %>% filter(fips == "24510" | fips == "06037") %>% filter(type == "ON-ROAD")

#aggregate data sets
total_baltimore_LA_onroad <- aggregate(Emissions ~ year + fips, baltimore_LA_onroad, sum)
total_baltimore_LA_onroad$fips[total_baltimore_LA_onroad$fips == "24510"] <- "Baltimore City, MD"
total_baltimore_LA_onroad$fips[total_baltimore_LA_onroad$fips == "06037"] <- "Los Angeles County, CA"

#open graphing device
png("plot6.png", height = 600, width = 900)

#create ggplot
g <- ggplot(total_baltimore_LA_onroad, 
            aes(x = factor(year), y = Emissions, fill = fips, label = round(Emissions,2)))
g <- g + 
      geom_bar(stat = "identity") +
      facet_grid (. ~ fips, scales="free") +
      xlab("year") +
      ylab(expression("total PM"[2.5]*" emissions in tons")) +
      ggtitle("Emissions from on-road vehicles from 1999-2008 in Baltimore City and LA County") +
      geom_label(aes(fill = fips), col = "white", fontface = "bold") +
      theme(legend.position = "none") +
      theme(axis.title.x=element_text(vjust=-2)) +
      theme(axis.title.y=element_text(angle=90, vjust=-0.5)) +
      theme(plot.title=element_text(size=20, vjust=3)) +
      theme(plot.margin = unit(c(1,1,1,1), "cm"))
show(g)

#close graphing device
dev.off()



