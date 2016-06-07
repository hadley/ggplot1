#' ggsave
#' Save a ggplot with sensible defaults
#'
#' @param plot plot to save
#' @param filename file name/path of plot
#' @param device device to use, automatically extract from file name extension
#' @param scale scaling factor
#' @param width width (in inches)
#' @param height height (in inches)
#' @param grid grid to use, normal for white on pale grey, print for pale grey on white
#' @param dpi dpi to use for raster graphics
#' @param ... other arguments passed to device function
#' @export
ggsave <- function(plot, filename=default_name(plot), device=default_device(filename), scale=1, width=graphics::par("din")[1], height=graphics::par("din")[2], grid="normal", dpi=96, ...) {

	pdf <- function(..., version="1.4") grDevices::pdf(..., version=version)
	png <- function(..., width, height) grDevices::png(..., width=width*dpi, height=height*dpi)
	jpeg <- function(..., width, height) grDevices::jpeg(..., width=width*dpi, height=height*dpi)

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
	on.exit(grDevices::dev.off())
	print(plot)

}
