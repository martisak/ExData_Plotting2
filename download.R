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

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

png('plot1.png', width=480, height=480, units="px", pointsize=20)

plot(a$year, a$Emissions, 
	xlab="Time [Year]", 
	ylab=expression(paste(PM[2.5]," emission [tons]")), 
	main=expression(bold(paste("Total ", PM[2.5]," emission from all sources"))),
	pch=19)

dev.off()

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.


b <- aggregate(data=NEI[NEI$fips == "24510",], Emissions~year+Pollutant, FUN=sum)

png('plot2.png', width=480, height=480, units="px", pointsize=20)

plot(b$year, b$Emissions, 
	xlab="Time [Year]", 
	ylab=expression(paste(PM[2.5]," emission [tons]")), 
	main=expression(bold(paste("Total ", PM[2.5]," emission in Baltimore from all sources"))),
	pch=19)

dev.off()

# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

c <- aggregate(data=NEI[NEI$fips == "24510",], Emissions~year+Pollutant+type, FUN=sum)

plot3 <- ggplot(data=c, aes(x=year, y=Emissions)) +
	geom_point() +
	geom_smooth(method="lm", se=FALSE) +
	facet_grid(type~., scales="free") +
	xlab("Time [year]") +
	ylab(expression(paste(PM[2.5]," emission [tons]"))) + 
	ggtitle(expression(paste("Total ", PM[2.5]," emission per type in Baltimore")))

png('plot3.png', width=480, height=480, units="px", pointsize=20)
print(plot3)
dev.off()

# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
data <- merge(NEI, SCC, by="SCC")
coalcomb <-  grepl("[cC]omb",data$Short.Name) & grepl("[cC]oal",data$Short.Name)
coalcombdaata <- data[coalcomb,]
c <- aggregate(data=coalcombdaata, Emissions~year, FUN=sum)

plot4 <- ggplot(data=c, aes(x=year, y=Emissions)) +
	geom_point() +
	geom_smooth(method="lm", se=FALSE) +
	xlab("Time [year]") +
	ylab(expression(paste(PM[2.5]," emission [tons]"))) + 
	ggtitle(expression(paste("Total ", PM[2.5]," emission in USA")))
	#facet_grid(type~., scales="free")

png('plot4.png', width=480, height=480, units="px", pointsize=20)
print(plot4)
dev.off()

# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

vehicles = grepl("Highway Veh", data$Short.Name)
vehiclesdata <- data[vehiclesdata & data$fips == "24510",]
c <- aggregate(data=vehiclesdata, Emissions~year, FUN=sum)

plot5 <- ggplot(data=c, aes(x=year, y=Emissions)) +
	geom_point() +
	geom_smooth(method="lm", se=FALSE) +
	xlab("Time [year]") +
	ylab(expression(paste(PM[2.5]," emission [tons]"))) + 
	ggtitle(expression(paste("Total ", PM[2.5]," emission from motor vehicle sources in Baltimore City")))
	#facet_grid(type~., scales="free")

png('plot5.png', width=480, height=480, units="px", pointsize=20)
print(plot5)
dev.off()

# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

vehicles = grepl("Highway Veh", data$Short.Name)
vehiclesdata <- data[vehicles & (data$fips == "24510" | data$fips == "06037"),]

h <- aggregate(data=vehiclesdata, Emissions~year+fips, FUN=sum)
h[c$fips == "24510","city"] <- "Baltimore City"
h[c$fips == "06037","city"] <- "Los Angeles County"

h <- ddply(h, .(Emissions), transform, relative=Emissions-h[h$city == city,"Emissions"][1])

# Stupid bug doesn't let me do titles on two rows with expressions.
plot5 <- ggplot(data=h, aes(x=year, y=relative)) +
	geom_point() +
	geom_smooth(method="lm", se=FALSE) +
	xlab("Time [year]") +
	ylab(expression(paste(PM[2.5]," emission, [tons relative 1999]"))) + 
	ggtitle("PM2.5 emission from motor vehicle sources\n in Baltimore City and Los Angeles County") +
	facet_grid(city~., scales="free")

png('plot5.png', width=480, height=480, units="px", pointsize=20)
print(plot5)
dev.off()