# Download (if needed) and read data.
source('download.R')

# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

# Aggregate on year, and type for Baltimore City (fips = 24510)
aggdata <- aggregate(data=NEI[NEI$fips == "24510",], Emissions~year+type, FUN=sum)

# Plot and make a facet for each type. Share y-axis to aid 
# in comparison.

plot3 <- ggplot(data=aggdata, aes(x=year, y=Emissions)) +
	geom_point() +
	geom_smooth(method="lm", se=FALSE) +
	scale_x_continuous(breaks=unique(aggdata$year)) +
	facet_grid(.~type, scales="free") +
	xlab("Time [year]") +
	ylab(expression(paste(PM[2.5]," emission [tons]"))) + 
	ggtitle(expression(paste("Total ", PM[2.5]," emission per type in Baltimore"))) 

# Save to file
png('plot3.png', width=800, height=640, units="px", pointsize=20)
print(plot3)
dev.off()