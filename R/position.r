#' @export
guides.position <- function(scale, ...) {
	#if (scale$visible == FALSE) return(NULL)
	position <- if(output(scale) == "x") "bottom" else "left"
	ggaxis(breaks(scale), labels(scale), position, range(scale))
}


#' Map projection scale
#'
#' This allows you to use map type projection.
#'
#' @param projection projection to use, see \code{\link[mapproj]{mapproject}} for possible values
#' @param params list of parameters passed to \code{\link[mapproj]{mapproject}}
#' @export
ps_map <- function(projection="mercator", params=NULL) {
	if (!requireNamespace("mapproj")) stop("mapproj package required for projection transforms")
	structure(
		list(projection = projection, params = params),
		class = c("ps_map", "ps_double", "position","scale")
	)
}

#' @export
map_aesthetic.ps_map <- function(scale, data, ...) {
	proj <- do.call(mapproj::mapproject,
		list(data$x, data$y, projection=scale$projection, data$params)
	)
	data.frame(x=proj$x, y=proj$y)
}

#' @export
"update<-.ps_map" <- function(x, value) {
	proj <- do.call(mapproj::mapproject, list(value$x, value$y, projection=x$projection, x$params))
	x$range <- list(x=range(proj$x, na.rm=TRUE), y=range(proj$y, na.rm=TRUE))
	x
}

#' @export
input.ps_double  <- function(scale) c("x","y")
#' @export
output.ps_double <- function(scale) c("x","y")

#' @export
breaks.ps_double <- function(scale, ...) {
	list(
		x = breaks.continuous(range(scale)$x),
		y = breaks.continuous(range(scale)$y)
	)
}

#' @export
labels.ps_double <- function(object, ...) {
	list(
		x = as.character(breaks.continuous(range(object)$x)),
		y = as.character(breaks.continuous(range(object)$y))
	)
}

#' @export
guides.ps_double <- function(scale, ...) {
	#if (scale$visible == FALSE) return()
	list(
		x = ggaxis(breaks(scale)$x, labels(scale)$x, "bottom", range(scale)$x),
		y = ggaxis(breaks(scale)$y, labels(scale)$y, "left",   range(scale)$y)
	)
}

#' @export
range.ps_double <- function(x, ...) x$range

#' @export
map_aesthetic.ps_double <- function(scale, data, ...) {
	data.frame(x=data$x, y=data$y)
}


#' Equal scales
#' Create a scale for axes with equal length on each
#'
#' @export
ps_equal <- function() {
	structure(
		list(),
		class = c("ps_equal", "ps_double", "position","scale")
	)
}


#' @export
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

#' Expand range
#' Convenience function for expanding a range with a multiplicative
#' or additive constant.
#'
#' @param range range of data
#' @param mul multiplicative constract
#' @param add additive constant
#' @export
expand_range <- function(range, mul=0, add=0) {
	range + c(-1, 1) * (diff(range) * mul + add)
}
