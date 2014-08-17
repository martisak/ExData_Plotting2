# Download (if needed) and read data.
source('download.R')

## Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

# Merge the two datasets to get the names for each SCC.
data <- merge(NEI, SCC, by="SCC")

# Pick out all rows of column Short.Name that contain "comb" (as in combustion) and "coal"
# Save this as a logical vector. Ignore case.
coalcomb <-  grepl("comb",data$Short.Name, ignore.case = TRUE) &
 	grepl("coal",data$Short.Name, ignore.case = TRUE)

# Subset data
coalcombdaata <- data[coalcomb,]

# Aggregate to get total emissions per year.
aggdata <- aggregate(data=coalcombdaata, Emissions~year, FUN=sum)

# Plot points, add smooth (linear)
plot4 <- ggplot(data=aggdata, aes(x=year, y=Emissions)) +
	geom_point() +
	geom_smooth(method="lm", se=FALSE) +
	xlab("Time [year]") +
	ylab(expression(paste(PM[2.5]," emission [tons]"))) + 
	ggtitle("Total PM2.5 emission\nfrom coal combustion in USA") +
	scale_x_continuous(breaks=aggdata$year)

# Write to file
png('plot4.png', width=640, height=640, units="px", pointsize=20)
print(plot4)
dev.off()