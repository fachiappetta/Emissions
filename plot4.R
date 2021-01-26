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

#