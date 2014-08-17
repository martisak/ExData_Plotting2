# Run each file, but clear memory first to make sure there are no bugs.
for (n in 1:6) {

	cat(paste("Plot", n, "\n")) 

	# Remove everything except n
	rm(list=setdiff(ls(), "n"))

	# Run file
	source(paste("plot", n, ".R", sep=""))
}