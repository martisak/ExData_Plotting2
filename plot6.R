# Download (if needed) and read data.
source('download.R')


# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

# Choose all rows of column Short Name that contains "Highway Veh". This would perhaps 
# not capture lawn mowers, but I am assuming that the emission from the non-highway motor vehicles is
# much less than the highway vehicles.

# Merge the two datasets to get the names for each SCC.
data <- merge(NEI, SCC, by="SCC")

# Logical vector
vehicles = grepl("Highway Veh", data$Short.Name)

# Subset data, get Baltimore City and Los Angeles County.
vehiclesdata <- data[vehicles & (data$fips == "24510" | data$fips == "06037"),]

# Aggregate emissions per year and fips.
aggdata <- aggregate(data=vehiclesdata, Emissions~year+fips, FUN=sum)

# Add a column with names for the fips
aggdata[aggdata$fips == "24510","city"] <- "Baltimore City"
aggdata[aggdata$fips == "06037","city"] <- "Los Angeles County"

# Add a column called "relative" with the emission relative 1999.
# I.e. 1999 will have 0 tons relative emissions to 1999.
# aggdata[aggdata$city == city & year ==1999,"Emissions"] is the emissions
# from 1999 for that city.

aggdata <- ddply(aggdata, .(Emissions), transform, relative=Emissions-aggdata[aggdata$city == city & aggdata$year == 1999,"Emissions"])

# Stupid bug doesn't let me do titles on two rows with expressions.
plot6 <- ggplot(data=aggdata, aes(x=year, y=relative)) +
	geom_point() +
	geom_smooth(method="lm", se=FALSE) +
	scale_x_continuous(breaks=unique(aggdata$year)) +
	xlab("Time [year]") +
	ylab(expression(paste(PM[2.5]," emission, [tons relative 1999]"))) + 
	ggtitle("PM2.5 emission from motor vehicle sources\n in Baltimore City and Los Angeles County") +
	facet_grid(city~., scales="free")

png('plot6.png', width=480, height=480, units="px", pointsize=20)
print(plot6)
dev.off()