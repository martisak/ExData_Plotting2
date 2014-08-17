# Download (if needed) and read data.
source('download.R')

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

# Aggregate total emissions per year
aggdata <- aggregate(data=NEI, Emissions~year, FUN=sum)

# Open png file
png('plot1.png', width=640, height=640, units="px", pointsize=20)

plot(aggdata$year, aggdata$Emissions, 
	xlab="Time [Year]", 
	ylab=expression(paste(PM[2.5]," emission [tons]")), 
	main=expression(bold(paste("Total ", PM[2.5]," emission from all sources"))),
	pch=19,
	xaxt="n")

# Add regression line
abline(lm(aggdata$Emissions ~ aggdata$year))

# Make sure the x-axis only contains the years 1999, 2002, 2005 and 2008.
axis(1,at=aggdata$year)

dev.off()