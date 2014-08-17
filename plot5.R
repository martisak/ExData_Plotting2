# Download (if needed) and read data.
source('download.R')

# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

# Choose all rows of column Short Name that contains "Highway Veh". This would perhaps 
# not capture lawn mowers, but I am assuming that the emission from the non-highway motor vehicles is
# much less than the highway vehicles.

# Merge the two datasets to get the names for each SCC.
data <- merge(NEI, SCC, by="SCC")

# Logical vector
vehicles = grepl("Highway Veh", data$Short.Name)

# Subset data
vehiclesdata <- data[vehicles & data$fips == "24510",]

# Aggregate emissions per year.
aggdata <- aggregate(data=vehiclesdata, Emissions~year, FUN=sum)

plot5 <- ggplot(data=aggdata, aes(x=year, y=Emissions)) +
	geom_point() +
	scale_x_continuous(breaks=aggdata$year) +
	geom_smooth(method="lm", se=FALSE) +
	xlab("Time [year]") +
	ylab(expression(paste(PM[2.5]," emission [tons]"))) + 
	ggtitle(expression(paste("Total ", PM[2.5]," emission from motor vehicle sources in Baltimore City")))
	#facet_grid(type~., scales="free")

png('plot5.png', width=640, height=640, units="px", pointsize=20)
print(plot5)
dev.off()