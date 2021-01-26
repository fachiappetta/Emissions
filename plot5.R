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

#merge data
NEI_SCC <- merge(NEI,SCC)

#subset baltimore
baltimore <- NEI %>% filter(fips == "24510")
