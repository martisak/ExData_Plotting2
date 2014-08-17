source('download.R')


# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

vehicles = grepl("Highway Veh", data$Short.Name)
vehiclesdata <- data[vehicles & (data$fips == "24510" | data$fips == "06037"),]

h <- aggregate(data=vehiclesdata, Emissions~year+fips, FUN=sum)
h[c$fips == "24510","city"] <- "Baltimore City"
h[c$fips == "06037","city"] <- "Los Angeles County"

h <- ddply(h, .(Emissions), transform, relative=Emissions-h[h$city == city,"Emissions"][1])

# Stupid bug doesn't let me do titles on two rows with expressions.
plot6 <- ggplot(data=h, aes(x=year, y=relative)) +
	geom_point() +
	geom_smooth(method="lm", se=FALSE) +
	scale_x_continuous(breaks=unique(c$year)) +
	xlab("Time [year]") +
	ylab(expression(paste(PM[2.5]," emission, [tons relative 1999]"))) + 
	ggtitle("PM2.5 emission from motor vehicle sources\n in Baltimore City and Los Angeles County") +
	facet_grid(city~., scales="free")

png('plot6.png', width=480, height=480, units="px", pointsize=20)
print(plot6)
dev.off()