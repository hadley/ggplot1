# Scale methods
# 
# @keyword internal 
# @alias defaultgrob.manual
# @alias guides.manual
# @alias labels.categorical
# @alias labels.continuous
# @alias labels.gradient
# @alias labels.manual
# @alias labels.ps_double
# @alias labels.ps_map
# @alias position_categorical 
# @alias position_continuous 
# @alias print.continuous
# @alias print.gradient
# @alias range.categorical
# @alias range.continuous
# @alias range.ps_double
# @alias scale_colour
# @alias scale_fill
# @alias scale_fill_brewer 
# @alias scale_fill_hcl 
# @alias scale_fill_hsv
# @alias scale_fill_rgb
# @alias scale_gradient
# @alias scale_hcl
# @alias scale_hsv
# @alias scale_linetype
# @alias scale_manual
# @alias scale_rgb
# @alias scale_shape
# @alias scale_size
sc <- function() {}
 
# Guides
# Create guides for the given scale
# 
# @keyword hplot 
# @keyword internal 
# @alias guides.ps_double
# @alias guides.ps_map
# @alias guides.scale_cont_colour
guides <- function(scale, ...) UseMethod("guides")

# Map	
# Map raw data to aesthetics using the provided scale
# 
# @keyword hplot 
# @alias map_aesthetic.scale
# @keyword internal 
# @alias map_aesthetic.categorical 
# @alias map_aesthetic.continuous 
# @alias map_aesthetic.gradient
# @alias map_aesthetic.ps_double
# @alias map_aesthetic.ps_map
# @alias map_aesthetic.scale_cont_colour
# @alias map_aesthetic.manual
map_aesthetic <- function(scale, data, ...) UseMethod("map_aesthetic")
map_aesthetic.scale <- function(scale, data, ...) data

# Input
# Return what input variable this scale uses
# 
# @keyword hplot 
# @alias input.scale
# @keyword internal 
# @alias input.ps_double
# @alias input.ps_map
# @alias input.scale_cont_colour
input <- function(scale) UseMethod("input", scale)
input.scale  <- function(scale) scale$variable

# Output
# Return what output variables this scale produces
# 
# @keyword hplot 
# @alias output.scale
# @keyword internal 
# @alias output.ps_double
# @alias output.ps_map
# @alias output.scale_cont_colour
output <- function(scale) UseMethod("output", scale)
output.scale <- function(scale) scale$variable

# Update
# Update a scale with data values.
# 
# This is used to teach each scale about the full range of the data
# so that all panels share a common scale.
# 
# @keyword hplot 
# @alias update<-.scale
# @keyword internal 
# @alias update<-.categorical
# @alias update<-.continuous
# @alias update<-.gradient
# @alias update<-.ps_equal
# @alias update<-.ps_map
# @alias update<-.scale_cont_colour
# @alias update<-.manual
"update<-" <- function(x, value) UseMethod("update<-")
"update<-.scale" <- function(x, value) x

# Scale range
# Default method for all scales.
# 
# @arguments scale
# @arguments unused
# @keyword manip 
# @keyword internal 
range.scale <- function(x, ...) x$from


# Deafult grob
# Return the default grob to use for creating a legend
# 
# @arguments scale object
# @alias deafultgrob.scale
# @keyword hplot 
# @keyword internal 
# @alias defaultgrob.categorical
# @alias defaultgrob.gradient
# @alias defaultgrob.default
defaultgrob <- function(x) UseMethod("defaultgrob")
defaultgrob.default <- function(x) function(x) grob_point(x, unique=FALSE)

# Scale breaks
# Compute breaks of scale object
# 
# @arguments scale object
# @arguments ...
# @keyword manip 
# @keyword internal 
# @alias breaks.categorical
# @alias breaks.continuous
# @alias breaks.gradient
# @alias breaks.ps_double
# @alias breaks.ps_map
# @alias breaks.manual
breaks  <- function(scale, ...) UseMethod("breaks")

# Print scale
# Print a moderately useful description of a scale object
# 
# @arguments scale object
# @arguments unused
# @keyword manip 
# @keyword internal 
print.scale <- function(x, ...) {
	cat(paste("Scale: ", scale_mapping(x), "\n", sep=""))
}

# Scale mapping
# Text string describing how the mapping of the scale works
# 
# @arguments scale object
# @keyword manip 
# @keyword internal 
scale_mapping <- function(x) {
	paste(paste(input(x), collapse=", "), "->", paste(output(x), collapse=","), sep="")
}


# Add scale
# Add (one) scale to the plot 
# 
# You shouldn't need to call this function yourself as all
# scale objects provide a convenient method to do so automatically.  These
# are the functions that start with sc.
# 
# @arguments plot object, if not specified will use current plot
# @arguments scale to add, see \code{\link{scales}} for possible options
# @keyword hplot 
# @keyword internal 
#X p <- ggplot(movies, aesthetics=list(x=length, y=rating))
#X add_scale(ggpoint(p), position_continuous('x', range=c(80,100)))
add_scale <- function(p = .PLOT, scale) {
	replaced <- output(p$scales) %in% output(scale)
	p$scales <- do.call(scales, c(p$scales[!replaced, drop=FALSE], list(scale)))
	(.PLOT <<- p)
}

# Add position scales.
# Add postiion scales to a plot
# 
# @arguments plot object
# @arguments precompution, see code in \code{\link{ggplot_plot}}
# @arguments position ("x" or "y")
# @keyword hplot
# @keyword internal 
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