# Create guides for the given scale
guides <- function(scale, ...) UseMethod("guides")

# Map raw data to aesthetics using the provided scale
map_aesthetic <- function(scale, data, ...) UseMethod("map_aesthetic")
#' @export
map_aesthetic.scale <- function(scale, data, ...) data

# Return what input variable this scale uses
input <- function(scale) UseMethod("input", scale)
#' @export
input.scale  <- function(scale) scale$variable

# Return what output variables this scale produces
output <- function(scale) UseMethod("output", scale)
#' @export
output.scale <- function(scale) scale$variable

# Update a scale with data values.
"update<-" <- function(x, value) UseMethod("update<-")
#' @export
"update<-.scale" <- function(x, value) x

#' @export
range.scale <- function(x, ...) x$from

# Return the default grob to use for creating a legend
defaultgrob <- function(x) UseMethod("defaultgrob")
#' @export
defaultgrob.default <- function(x) function(x) grob_point(x, unique=FALSE)

# Compute breaks of scale object
breaks  <- function(scale, ...) UseMethod("breaks")

#' @export
print.scale <- function(x, ...) {
	cat(paste("Scale: ", scale_mapping(x), "\n", sep=""))
}

# Text string describing how the mapping of the scale works
scale_mapping <- function(x) {
	paste(paste(input(x), collapse=", "), "->", paste(output(x), collapse=","), sep="")
}


# Add (one) scale to the plot
add_scale <- function(p, scale) {
	replaced <- output(p$scales) %in% output(scale)
	p$scales <- do.call(scales, c(p$scales[!replaced, drop=FALSE], list(scale)))
	p
}

# Add postiion scales to a plot
add_position <- function(plot, pre, position) {
	if (!(position %in% unlist(input(plot$scales)))) {
		fac <- any(unlist(lapply(pre, function(x) lapply(x, function(x) is.factor(x[[position]])))))
		if (fac) {
			pscategorical(plot, variable=position)
		} else {
			pscontinuous(plot, variable=position)
		}
	} else {
		plot
	}
}
