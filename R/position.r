# Position guides
# Create x or y axis depending on variable name.
# 
# @arguments scale
# @arguments not currently used
# @keyword hplot 
guides.position <- function(scale, ...) {
	#if (scale$visible == FALSE) return(NULL)
	position <- if(output(scale) == "x") "bottom" else "left"
	ggaxis(breaks(scale), labels(scale), position, range(scale))
}


# Map projection scale
# Map projections
# 
# This allows you to use map type projection.
# 
# @arguments projection to use, see \code{\link[mapproj]{mapproject}} for possible values
# @arguments list of parameters passed to \code{\link[mapproj]{mapproject}}
# @keyword hplot 
ps_map <- function(projection="mercator", params=NULL) {
	if (!require("mapproj")) stop("mapproj package required for projection transforms")
	structure(
		list(projection = projection, params = params), 
		class = c("ps_map", "ps_double", "position","scale")
	)
}

map_aesthetic.ps_map <- function(scale, data, ...) {
	proj <- do.call(mapproject, 
		list(data$x, data$y, projection=scale$projection, data$params)
	)
	data.frame(x=proj$x, y=proj$y)
}

"update<-.ps_map" <- function(x, value) {
	proj <- do.call(mapproject, list(value$x, value$y, projection=x$projection, x$params))
	x$range <- list(x=range(proj$x, na.rm=TRUE), y=range(proj$y, na.rm=TRUE))
	x
}

input.ps_double  <- function(scale) c("x","y")
output.ps_double <- function(scale) c("x","y")

breaks.ps_double <- function(scale, ...) {
	list(
		x = breaks.scale_position(range(scale)$x),
		y = breaks.scale_position(range(scale)$y)
	)
}

labels.ps_double <- function(object, ...) {
	list(
		x = as.character(breaks.scale_position(range(object)$x)),
		y = as.character(breaks.scale_position(range(object)$y))
	)
}

guides.ps_double <- function(scale, ...) {
	#if (scale$visible == FALSE) return()
	list(
		x = ggaxis(breaks(scale)$x, labels(scale)$x, "bottom", range(scale)$x),
		y = ggaxis(breaks(scale)$y, labels(scale)$y, "left",   range(scale)$y)
	)
}

range.ps_double <- function(x, ...) x$range

map_aesthetic.ps_double <- function(scale, data, ...) {
	data.frame(x=data$x, y=data$y)
}


# Equal scales
# Create a scale for axes with equal length on each
# 
# 
# @keyword hplot
ps_equal <- function() {
	structure(
		list(), 
		class = c("ps_equal", "ps_double", "position","scale")
	)	
}


"update<-.ps_equal" <- function(x, value) {
	xlim <- range(value$x, na.rm=TRUE)
  ylim <- range(value$y, na.rm=TRUE)
	ratio <- 1
	tol <- 0.04

  midx <- 0.5 * (xlim[2] + xlim[1])
  xlim <- midx + (1 + tol) * 0.5 * c(-1, 1) * (xlim[2] - xlim[1])
  midy <- 0.5 * (ylim[2] + ylim[1])
  ylim <- midy + (1 + tol) * 0.5 * c(-1, 1) * (ylim[2] - ylim[1])

  xlim <- midx + c(-1, 1) * diff(xlim) * 0.5
  ylim <- midy + ratio * c(-1, 1) * diff(ylim) * 0.5

	x$range <- list(x=xlim, y=ylim)
	x
}


# Expand range
# Convenience function for expanding a range with a multiplicative 
# or additive constant.
# 
# @arguments range of data
# @arguments multiplicative constract
# @arguments additive constant
# @keyword manip 
expand_range <- function(range, mul=0, add=0) {
	range + c(-1, 1) * (diff(range) * mul + add)
}