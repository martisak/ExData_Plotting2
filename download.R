data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
filename <- "exdata_data_FNEI.zip"

if (!file.exists(filename)){
  cat("File did not exist, downloading...\n")
  download.file(data_url, filename, method="curl")
  unzip(filename)
}

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

a <- aggregate(data=NEI, Emissions~year+Pollutant, FUN=sum)

png('plot1.png', width=480, height=480, units="px", pointsize=20)

plot(a$year, a$Emissions, 
	xlab="Year", 
	ylab="PM2.5 emission", 
	main="Total PM2.5 emission from all sources",
	pty=2)

dev.off()

b <- aggregate(data=NEI[NEI$fips == "24510",], Emissions~year+Pollutant, FUN=sum)

png('plot2.png', width=480, height=480, units="px", pointsize=20)

plot(b$year, b$Emissions, 
	xlab="Year", 
	ylab="PM2.5 emission in Baltimore", 
	main="Total PM2.5 emission from all sources",
	pty=2)

dev.off()


