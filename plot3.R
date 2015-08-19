##################################################################################
## The data for this assignment are available from here
## https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
##        (save to your working directory)
##
## The zip file contains two files:
##
## PM2.5 Emissions Data (summarySCC_PM25.rds): This file contains a data frame with
##  all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year,
##  the table contains number of tons of PM2.5 emitted from a specific type of
##  source for the entire year. Here are the first few rows.
##
##      fips      SCC Pollutant Emissions  type year
##  4  09001 10100401  PM25-PRI    15.714 POINT 1999
##  8  09001 10100404  PM25-PRI   234.178 POINT 1999
##  12 09001 10100501  PM25-PRI     0.128 POINT 1999
##  16 09001 10200401  PM25-PRI     2.036 POINT 1999
##  20 09001 10200504  PM25-PRI     0.388 POINT 1999
##  24 09001 10200602  PM25-PRI     1.490 POINT 1999
##
##    *fips: A five-digit number (represented as a string) indicating the U.S. county
##    *SCC: The name of the source as indicated by a digit string (see source code
##            classification table)
##    *Pollutant: A string indicating the pollutant
##    *Emissions: Amount of PM2.5 emitted, in tons
##    *type: The type of source (point, non-point, on-road, or non-road)
##    *year: The year of emissions recorded
##
##  Required packages:
##    install.packages("ggplot2")
##    library(ggplot2)
##################################################################################

## Set file path to the Source_Clasification_Code.rds file
##  This table provides a mapping from the SCC digit strings
##  in the Emissions table to the actual name of the PM2.5 source.
##  The sources are categorized in a few different ways from more
##  general to more specific and you may choose to explore whatever
##  categories you think are most useful. For example, source "10100101"
##  is known as "Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal".
file_code <- "./exdata_data_NEI_data/Source_Classification_Code.rds"
file_data <- "./exdata_data_NEI_data/summarySCC_PM25.rds"

## Read data set into environment
SCC <- readRDS(file_code)
NEI <- readRDS(file_data)

## Make Emissions column data numbers
NEI$Emissions <- as.numeric(NEI$Emissions)

## Subset data on the city of Baltimore (fips=='24510')
baltimore_NEI <- NEI[NEI$fips=='24510',]

## Sum total polutants by year
x_baltimore_NEI <- aggregate(Emissions ~ year + type, data=baltimore_NEI, sum)

## Save the file
png(file="plot3.png", width=480, height=480)

types <- c(x_baltimore_NEI$year, x_baltimore_NEI$Emissions)

## Plot PM2.5 for Baltimore City, Maryland on type c('point','nonpoint','onroad','nonroad')
ggplot(x_baltimore_NEI, aes(x=types, color=type)) + geom_bar()

g <- ggplot(x_baltimore_NEI, aes(year, Emissions, color = type))
g <- g + geom_line() +
  xlab("year") +
  ylab(expression('Total PM'[2.5]*" Emissions")) +
  ggtitle('Total Emissions in Baltimore City, Maryland (fips == "24510") from 1999 to 2008')
print(g)

## required to close connection
dev.off()