source('download.R')

# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

vehicles = grepl("Highway Veh", data$Short.Name)
vehiclesdata <- data[vehiclesdata & data$fips == "24510",]
c <- aggregate(data=vehiclesdata, Emissions~year, FUN=sum)

plot5 <- ggplot(data=c, aes(x=year, y=Emissions)) +
	geom_point() +
	scale_x_continuous(breaks=c$year) +
	geom_smooth(method="lm", se=FALSE) +
	xlab("Time [year]") +
	ylab(expression(paste(PM[2.5]," emission [tons]"))) + 
	ggtitle(expression(paste("Total ", PM[2.5]," emission from motor vehicle sources in Baltimore City")))
	#facet_grid(type~., scales="free")

png('plot5.png', width=640, height=640, units="px", pointsize=20)
print(plot5)
dev.off()