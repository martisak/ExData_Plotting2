source('download.R')

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

a <- aggregate(data=NEI, Emissions~year, FUN=sum)

png('plot1.png', width=640, height=640, units="px", pointsize=20)

plot(a$year, a$Emissions, 
	xlab="Time [Year]", 
	ylab=expression(paste(PM[2.5]," emission [tons]")), 
	main=expression(bold(paste("Total ", PM[2.5]," emission from all sources"))),
	pch=19,
	xaxt="n")
abline(lm(a$Emissions ~ a$year))

axis(1,at=a$year)

dev.off()