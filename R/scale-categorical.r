
# Position: categorical
# Add a categorical position scale to the plot
# 
# A categorical scale converts a factor into a numerical representation
# very simply: by using \code{as.numeric}.  This means that levels
# will be placed a integer locations in the same order that they
# appear in the levels of the factor (see \code{\link{levels}}).
# 
# If you want to reorder (or combine) categories, currently the best way 
# to do this is to modify the original factors.  In a future version of ggplot
# I will probably expand the categorical scale so that you can do that here.
#
# This scale is added to the plot automatically when you use a categorical
# variable in the x or y aesthetics.  You shouldn't need to to call this function
# unless (for some reason) you want to change the expansion factor.  
# 
# @arguments ggplot object
# @arguments axis ("x" or "y")
# @arguments name of the scale (used in the legend)
# @arguments expansion vector (numeric vector, multiplicative and additive expansion).  Defaults to adding 0.6 on either end of the scale.
# @keyword hplot
#X p <- ggpoint(ggplot(mtcars, aesthetics=list(x=cyl, y=mpg)))
#X pscategorical(p, "x") # no change, because already categorical
#X pscategorical(p, "y") # chops into discrete segments
pscategorical <- function(plot = .PLOT, variable="x", name="", expand=c(0.01, 0.6)) {
	add_scale(plot,  position_categorical(variable=variable, name=name, expand=expand) )
}
position_categorical <- function(variable="x", name="", expand=c(0, 0.5)) {
	sc <- scale_categorical(variable=variable, name=name, expand=expand, visible=TRUE)
	class(sc) <- c("position", class(sc))
	sc
}


# Scale: general categorical
# Create a categorical scale for the specified variable
# 
# A categorical scale is a simple mapping from the levels of 
# the categorical factor to values of the aesthetic attribute.
# These mappings are created by the aesthetic mapping functions
# \code{\link{map_colour}}, and \code{\link{map_linetype}}.
# You will want to refer to those to see the possible options
# that can be used to control the mapping.
# 
# You should not call this function yourself.  Instead use:
# 
#   \item \code{\link{pscategorical}}
#   \item \code{\link{sccolour}}
#   \item \code{\link{sclinetype}}
#   \item \code{\link{scshape}}
# 
# If you use a continuous variable with this scale, it will automatically
# be converted to a categorical variable using \code{\link{chop_auto}}.  If
# you want more control over the conversion you will want to use 
# \code{\link{chop}} yourself.  However, be careful to do all the chopping
# in one place, otherwise you may end up with different scales in different grobs. 
# 
# This categorical scale places evenly spaces the levels of the factor
# along the intergers.  If you want to change the order of the levels
# you will need to change the levels in the original factor.
# 
# @arguments variable that this scale is for
# @arguments name of the scale (used in the legend)
# @arguments expansion factor for scale
# @arguments transformation function
# @keyword hplot 
# @keyword internal 
scale_categorical <- function(variable="x", name="", expand=c(0,0), transform="as.numeric", ...) {
	structure(
		list(variable=variable, name=name, expand=expand, transform=transform, args=list(...)), 
		class = c("categorical", "scale")
	)
	
}
"update<-.categorical" <- function(x, value) {
	if (!(input(x) %in% names(value))) return(x)
	
	val <- chop_auto(value[[input(x)]])
	x$autobreaks <- attr(val, "breaks")
 
	uval <- sort(unique(val))
	attributes(uval) <- attributes(val)
	x$map <- do.call(match.fun(x$transform), c(list(uval), x$args))
	names(x$map) <- levels(val)
	x
}

map_aesthetic.categorical <- function(scale, data, ...) {
	if (!(input(scale) %in% names(data))) return(data.frame())

	val <- data[[input(scale)]]
	if (!is.null(scale$autobreaks)) {
		breaks <- scale$autobreaks
		val <- cut(val, breaks, labels=FALSE, include.lowest=TRUE) #- attr(breaks,"midpoint.level")
  	vals <- scale$map[val]
	} else {
		val <- as.character(val)
  	vals <- scale$map[as.character(val)]
	}

	names(vals)[is.na(names(vals))] <- "missing"
	
	df <- data.frame(vals)
	names(df) <- input(scale)
	df
}

breaks.categorical <- function(scale, ...) scale$map
labels.categorical <- function(object, ...) {
	if (is.null(object$autobreaks)) return(names(object$map))
	
	breaks <- formatC(object$autobreaks, digits=2, format="fg", width=1)
  
	paste(breaks[-length(breaks)], breaks[-1], sep="-")
	
}
range.categorical <- function(scale, ...) expand_range(range(scale$map), scale$expand[1], scale$expand[2])


# Print categorical details
# Print moderately useful details of this categorical scale.
# 
# @arguments scale object
# @arguments not used
# @keyword manip 
# @keyword internal 
print.categorical <- function(x, ...) {
	cat(paste("Categorical scale: ", scale_mapping(x), "\n", sep=""))
}

defaultgrob.categorical <- function(x) {
  switch(x$variable,
    colour   = grob_tile,
    shape    = function(x) grob_point(x, unique=FALSE),
    fill     = grob_tile,
    linetype = grob_line)
}

# Scale: categorical colour
# Create a scale for categorical colours.
# 
# Continuous variables will automatically be converted to categorical
# using \code{\link{chop_auto}}.  You may want to use \code{\link{chop}}
# to convert the values yourself for finer control.
# 
# This scale is automatically added when you have colour in your list of
# aesthetics.  For finer control, you will need to set the scale
# yourself.  See the example for some ideas.
# 
# @arguments plot to add scale to
# @arguments name of the scale (used in the legend)
# @arguments range of hues to use
# @arguments luminance value
# @arguments chroma value
# @arguments alpha value
# @seealso \code{\link{scale_categorical}}, \code{\link{map_colour}}
# @keyword hplot 
# @alias sccolor
# @alias scfill
#X p <- ggplot(movies, aes=list(x=mpaa, y=rating))
#X ggjitter(p, list(colour=rating))
#X ggjitter(p, list(colour=length))
#X ggjitter(p, list(colour=chop(length)))
#X ggjitter(p, list(colour=chop(length,3)))
#X sccolour(ggjitter(p, list(colour=chop(length,3))), 2)
sccolour <- function(plot = .PLOT, name="", h=c(0,360), l=65, c=100, alpha=1) {
	add_scale(plot, scale_colour(name=name, h=h, l=l, c=c, alpha=alpha))
}
sccolor <- sccolour
scale_colour <- function(name="", h=c(0, 360), l=65, c=100, alpha=1) scale_categorical("colour", name=name, h=h, l=l, c=c, transform="map_colour", alpha=alpha)

scfill <- function(plot = .PLOT, name="", h=c(0,360), l=75, c=100, alpha=1) {
	add_scale(plot, scale_fill(name=name, h=h, l=l, c=c, alpha=alpha))
}
scale_fill <- function(name="", h=c(0,360), l=75, c=100, alpha=1) scale_categorical("fill", name=name, h=h, l=l, c=c, transform="map_colour", alpha=alpha)

# Scale: Brewer colours
# Use Brewer colour scheme for colour fill.
# 
# @arguments plot to add scale to
# @arguments name of the scale (used in the legend)
# @arguments Color Brewer palette to use, see \code{\link[RColorBrewer]{brewer.pal}} for details.  Note that palette type is chosen automatically.
# @keyword hplot 
scfillbrewer <- function(plot = .PLOT, name="", palette=1) {
	add_scale(plot, scale_fill_brewer(name=name, palette=palette))
}
scale_fill_brewer <- function(name="", palette=1) scale_categorical("fill", name=name, palette=palette, transform="map_colour_brewer")

# Scale: shape
# Create a scale for categorical shapes.
# 
# This scale is automatically added when you use the shape aesthetic
# mapping.  By using this scale you can explicitly decide whether the
# points used should be hollow or solid.
# 
# @keyword hplot 
# @arguments plot to add scale to
# @arguments name of the scale (used in the legend)
# @arguments should points be solid or hollow?
# @seealso \code{\link{scale_categorical}}, \code{\link{map_shape}}
#X p <- ggplot(mtcars, aes=list(x=mpg, y=wt, shape=cyl))
#X ggpoint(p)
#X ggpoint(scshape(p, FALSE))
scshape <- function(plot = .PLOT, name="", solid=TRUE) {
	add_scale(plot, scale_shape(name=name, solid))
}
scale_shape <- function(name="", solid=TRUE) scale_categorical("shape", name=name, solid=solid, transform="map_shape")


# Scale: line type
# Create a scale for categorical line types.
# 
# This scale is automatically added to the plot when you use the linetype
# aesthetic.  As there are no options to this scale, you shouldn't ever 
# need to add it yourself.
# 
# @keyword hplot 
# @arguments plot to add scale to
# @arguments name of the scale (used in the legend)
# @seealso \code{\link{scale_categorical}}, \code{\link{map_linetype}}
#X p <- ggplot(mtcars, aes=list(x=mpg, y=wt, linetype=cyl))
#X ggline(p)
#X ggline(sclinetype(p))
sclinetype <- function(plot = .PLOT, name="") {
	add_scale(plot, scale_linetype(name=name))
}
scale_linetype <- function(name="") scale_categorical("linetype", name=name, transform="map_linetype")
