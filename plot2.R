source('download.R')

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.


b <- aggregate(data=NEI[NEI$fips == "24510",], Emissions~year, FUN=sum)

png('plot2.png', width=640, height=640, units="px", pointsize=20)

plot(b$year, b$Emissions,
	xlab="Time [Year]", 
	ylab=expression(paste(PM[2.5]," emission [tons]")), 
	main="Total PM2.5 emission in\n Baltimore from all sources",
	pch=19,
	xaxt="n")
abline(lm(b$Emissions ~ b$year))

axis(1,at=b$year)

dev.off()