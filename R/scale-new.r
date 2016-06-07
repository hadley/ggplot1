# Scales
# 
# A scale is a mapping between data space and aesthetic
# space.  
# 
# It is not directly connected to a variable, but
# typically a variable will define the domain of the function.
# This is called training.  It ggplot all scales are connected to
# variables because of the difficulties associated with nested 
# immutable object (I'm sure there's a better solution to this)
# 
# A scale may take multiple inputs (variables) and return 
# multiple outputs (aesthetics).  
# 
# Building up overall scales
# ========================================
#
# In ggplot, a scale is first computed on a per facet per grob
# basis.  Scales are combined by default as follows:
#
#   * scales are combined across all grobs.
#
# Then
#
#   * all non-position scales are combined
#   * all x&y scales are combined
#   * x scales are combined vertically
#   * y scales are combined horizontally.
#
# However, some scales override these defaults.  eg. a mosaic scale 
# is combined across nothing.  These defaults can also be overridden
# for a given plot, by specifying an alternative function to perform
# the combining.
# 
# All combining functions take a matrix of scales and return a scales object
# of scales of the same dimension, and whether inidivudal guides will be needed.
# Basic functions are:
#
#  * scale_combine_all
#  * scale_combine_xy
#  * scale_combine_none
#
# The scales objects need to provide methods:
# 
# * generate guides (legend, x-axis, y-axis and internal), 
# * whether individual viewports are needed.
# 
# 
# All non-position guides form the legend (position specified by legend.position
# option).  Position scales range from one x & y scale overall, to one x & y 
# scale for each plot.  
# 
#
# Guides
# ========================================
#
# A scale can draw up to three types of graphical guides to ease
# the reverse mapping (by human eye) from aesthetic attribute
# to data attribute.  These are:
# 
#  * a legend (guide_legend)
#  * an axis  (guide_axis_x, guide_axis_y)
#  * elements within the plot (guide_inside)
#
# 
# Aspect ratios and relative sizes
# ========================================
# 
# A position scale also has a desired width for each variable in its domain.  
# This consists of a tuple of continuous and categorical widths.
# 
# These can be used to preserve mappings across multiple facets
# by allowing the facets to be different sizes.
#
# By default categorical and continuous plots try and take up the same
# amount of space.
# 
# Data pipeline
# ========================================
# 
# Add attribute to columns in data frame to indicate 
# whether or not they have been scaled?  Then new columns
# 
# Need to write out some use cases on paper.
# Also need to break everything down into manageable chunks.
# 
# When processing the data to make a plot, the sequence is 
# as follows:
# 
#  * apply all scales to data, to normalise data to aesthetic column names (except you can't do that for complicated )
#  * pre grob (if available), works on raw data
#  * train, combine and apply scales
#  * grob function, works on scaled data
# 
# (x) -> Histogram (x,y) -> Log scale (x, log(y))
# (x) -> Histogram (x,y) -> Colour scale (x, y, colour=y)
# (x, y, z) -> Log scale (x, y, log(z) -> Contours (x, y, log(z))
# (x, y) -> 2d density (x, y, z) -> Fill scale
#
# This allows scales to work on the output of pre_grob functions
# 
# How can a scale operate on both raw data and post pre_grob data?
#  * renaming to scale names
#  * processing
#
# Current aesthetics is really just setting scales (and defaults?)
# Mucking around with data is mainly for facets
#
#ggpoint(p, list(scsize(3 * height), psequal(weight, height), sccolour(smell, "brewer", 9))
#gghistogram(p, list(sccolour(height), scposition(length)))

# New scales functionality
# 
# @keyword internal
# @alias scale_domain
# @alias scale_map_single
# @alias scale_desired_size
# @alias range2
scale_new <- function(input, output=names(input), name = paste(input, collapse="/"), ..., class=output) {
	structure(list(input=input, output=output, name=name, ...), class=c(class, "scale"))	
}

# Scale apply combine map
# 
# @keyword internal 
#X scale_new(c(size="3 * height"), "size", range=c(0, 5), class="size")
#X scale_new(c(x="weight", y="height"), c("x", "y"), class=c("equal", "position"))
#X scale_new(c(group="age"), c("colour", "glyph"), class="group")
#X scale_new(c(h="age"), c("colour"), class="hsv", range=list(l=c(4,4), h=c(30,40)))
#X scale_new(c())
scale_apply_combine_map <- function(scale, rdmatrix) {
	domains <- c()
	ranges <- c()
	
	mapply(scale_map, cmatrix, domains, ranges)
}

scale_domain <- function(scale, rdmatrix, options) {
	if (!inherits(scale, "position")) return(range2(rdmatrix))
	
	
	iapply(rdmatrix, c(1,2), range2)
}

range2 <- function(inputs) {
	cat <- sapply(inputs, is.factor)
	c(
		cont = do.call(range, list(inputs[!cat], finite=TRUE)),
		cat =  levels(do.call(factor, inputs[cat]))
	)
}

# Given a scale and a data.frame, this runs the expressions 
# in the input and returns a list
# 
# And what should the names of that list be?
# @keyword internal 
scale_apply_to_data <- function(scale, data=data.frame()) {
	lapply(scale$input, function(i) tryCatch(eval(parse(text=i), data, parent.frame()), error=function(...) list()))
}
#T sc <- scale_new("1:10", "size")
#T assert_equal(scale_apply_to_data(sc), list(1:10)))
#T sc <- scale_new(c(a="1:10"), "size")
#T assert_equal(scale_apply_to_data(sc), list(a=1:10))
#T sc <- scale_new(c(a="2 * a"), "size")
#T assert_equal(scale_apply_to_data(sc, data.frame(a=1:10)), list(a=(1:10)*2))
#T assert_equal(scale_apply_to_data(sc, data.frame()), list())


# @arguments scale object
# @arguments \code{data.frame} to be mapped
# @arguments named list of domains (one for each) input variable, each domain being a list of length two, the first element containing the range of the numeric component, the second the text labels of the categorical component
# @keyword internal 
scale_map <- function(scale, data, domain, range=scale$range) {
	
}

scale_map_single <- function(scale, variable, domain, range=scale$range) {
	if (length(domain) != length(range)) stop("Domain and range of different lengths")
	
	if (is.null(variable)) return()
	
	if (is.factor(variable)) {
		names(range) <- domain
		domain[as.character(range)]
	} else {
		rescale(variable, domain, range)
	}
}


scale_desired_size <- function(scale, domain) {
	
}

