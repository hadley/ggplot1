# ggsave
# Save a ggplot with sensible defaults
# 
# @arguments plot to save
# @arguments file name/path of plot
# @arguments device to use, automatically extract from file name extension
# @arguments scaling factor
# @arguments width (in inches)
# @arguments height (in inches)
# @arguments grid to use, normal for white on pale grey, print for pale grey on white
# @arguments dpi to use for raster graphics
# @arguments other arguments passed to device function
# @keyword file 
ggsave <- function(plot = .PLOT, filename=default_name(plot), device=default_device(filename), scale=1, width=par("din")[1], height=par("din")[2], grid="normal", dpi=96, ...) {

	pdf <- function(..., version="1.4") grDevices:::pdf(..., version=version)
	png <- function(..., width, height) grDevices:::png(..., width=width*dpi, height=height*dpi)
	jpeg <- function(..., width, height) grDevices:::jpeg(..., width=width*dpi, height=height*dpi)
	
	default_name <- function(plot) { 
		title <- if (is.null(plot$title) || nchar(plot$title) == 0) "ggplot" else plot$title
		clean <- tolower(gsub("[^a-zA-Z]+", "_", title))
		paste(clean, ".pdf", sep="")
	}
	
	default_device <- function(filename) {
		ext <- tolower(strsplit(filename, "\\.")[[1]][2])
		match.fun(ext)
	}

	width <- width * scale
	height <- height * scale
	
	if (grid != "normal") {
		plot$grid.colour = "grey80"
		plot$grid.fill = "white"
	}
	
	device(file=filename, width=width, height=height, ...)
	print(plot)
	dev.off()
	
}