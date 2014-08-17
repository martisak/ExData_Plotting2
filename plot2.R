# Download (if needed) and read data.
source('download.R')

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.

# Aggregate total emissions per year for Baltimore City (fips = 24510).
aggdata <- aggregate(data=NEI[NEI$fips == "24510",], Emissions~year, FUN=sum)

# Open png file
png('plot2.png', width=640, height=640, units="px", pointsize=20)

plot(aggdata$year, aggdata$Emissions,
	xlab="Time [Year]", 
	ylab=expression(paste(PM[2.5]," emission [tons]")), 
	main="Total PM2.5 emission in\n Baltimore from all sources",
	pch=19,
	xaxt="n")

# Add regression line
abline(lm(aggdata$Emissions ~ aggdata$year))

# Make sure the x-axis only contains the years 1999, 2002, 2005 and 2008.
axis(1,at=aggdata$year)

dev.off()