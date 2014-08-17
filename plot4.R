source('download.R')

## Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

# Merge the two datasets to get the names for each SCC.
data <- merge(NEI, SCC, by="SCC")

# Pick out all rows that contain "comb" (as in combustion) and "coal"
# Save this as a logical vector. Ignore case.
coalcomb <-  grepl("comb",data$Short.Name, ignore.case = TRUE) &
 	grepl("coal",data$Short.Name, ignore.case = TRUE)

# Subset data
coalcombdaata <- data[coalcomb,]

# Aggregate to get total emissions per year.
c <- aggregate(data=coalcombdaata, Emissions~year, FUN=sum)

# Plot points, add smooth (linear)
plot4 <- ggplot(data=c, aes(x=year, y=Emissions)) +
	geom_point() +
	geom_smooth(method="lm", se=FALSE) +
	xlab("Time [year]") +
	ylab(expression(paste(PM[2.5]," emission [tons]"))) + 
	ggtitle(expression(paste("Total ", PM[2.5]," emission in USA"))) +
	scale_x_continuous(breaks=c$year)

	#facet_grid(type~., scales="free")

# Write to file
png('plot4.png', width=640, height=640, units="px", pointsize=20)
print(plot4)
dev.off()