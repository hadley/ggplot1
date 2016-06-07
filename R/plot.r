# Create a new plot
# Create a new ggplot plot
# 
# This function creates the basic ggplot object which you can then
# furnish with graphical objects.  Here you will set 
# up the default data frame, default aesthetics and the formula that
# will determine how the panels are broken apart.  See \code{\link[reshape]{reshape}} 
# for more details on specifying the facetting formula and margin arguments.
# Note that ggplot creates a plot object without a "plot": you need to
# grobs (points, lines, bars, etc.) to create something that you can see.
#
# To get started, read the introductory vignette: \code{vignette("introduction", "ggplot")}
# 
# Steps to create a plot:
# 
# \enumerate{
#  \item Create a new plot.  (\code{p <- ggplot(mtcars, aesthetics=list(y=hp, x=mpg))})
#  \item Set scales (if necessary)
#  \item Add grobs to the plot (\code{ggpoint(p)})
# }
# 
# or, use \code{\link{qplot}}
# 
# Simple grobs: 
# 
# \itemize{
# 	\item \code{\link{ggabline}}: line with given slope and intercept
# 	\item \code{\link{ggarea}}: area (polygons with base on y=0)
# 	\item \code{\link{ggbar}}: bars (stocked and dodgted)
# 	\item \code{\link{ggjitter}}: jittered points (useful for discrete data)
# 	\item \code{\link{ggline}}: lines (paths sorted by x-axis values)
# 	\item \code{\link{ggpath}}: paths
# 	\item \code{\link{ggpoint}}: points
# 	\item \code{\link{ggribbon}}: ribbon
# 	\item \code{\link{ggtext}}: text
# 	\item \code{\link{ggtile}}: tiles, like a levelplot
# }
# 
# Complex grobs:
# 
# \itemize{
# 	\item \code{\link{ggboxplot}}: box plot
# 	\item \code{\link{ggcontour}}: contour lines
# 	\item \code{\link{ggdensity}}: 1d density plot (continuous analogue of histogram)
# 	\item \code{\link{gg2density}}: 2d density countours
# 	\item \code{\link{gghistogram}}: histogram
# 	\item \code{\link{ggquantile}}: quantile lines from a quantile regression
# 	\item \code{\link{ggsmooth}}: smooths from any model family
# }
# 
# Look at the documentation of these objects to see many examples of ggplot
# in action.
#
# You will also want to add scales to the basic plot to give finer control
# over how the data values are mapped to aethetics attributes of the grobs.
# For scales that control position of the points see:
# 
# \itemize{
# 	\item \code{\link{pscontinuous}}: continuous scales (with optional transformation)
# 	\item \code{\link{pscategorical}}: categorical scales
# }
# 
# For other scales, see:
#
# \itemize{
# 	\item \code{\link{sccolour}}: colour categorical variables using Brewer colour scales (see also \code{\link{scfill}})
# 	\item \code{\link{scgradient}}: colour continuous scales with a gradient (see also \code{\link{scfillgradient}})
# 	\item \code{\link{schcl}}: map continuous variable to hue, chroma or luminance components (see also \code{\link{scfillhcl}})
# 	\item \code{\link{schsv}}: map continuous variable to hue, saturation or value components (see also \code{\link{scfillhsv}})
# 	\item \code{\link{scmanual}}: no automatic conversion, uses raw values directly
# 	\item \code{\link{sclinetype}}: line type (solid, dashed, dotted, etc.)
# 	\item \code{\link{scrgb}}: map continuous variable to red, green or blue components (see also \code{\link{scfillrgb}})
# 	\item \code{\link{scshape}}: point shape (glyph)
# 	\item \code{\link{scsize}}: point or line size
# }
# 
# ggplot is different from base and lattice graphics in how you build up the plot.
# With ggplot you build up the plot object (rather than the plot on the screen as
# in base graphics, or all at once as in lattice graphics.) 
# 
# Each of the grob and scale functions adds the grob to the plot and returns
# the modified plot object.  This lets you quickly experiment with different
# versions of the plot, using different grobs or scales.  You can see how this 
# works in the examples
# 
# You can also use \code{summary} to give a quick description of a plot.
# 
# If you want to change the background colour, how the panel strips are displayed,
# or any other default graphical option, see \code{\link{ggopt}}.
# 
# @alias package-ggplot
# @alias ggplot
# @arguments default data frame
# @arguments formula describing row and column layout, see \code{\link[reshape]{reshape}} for more details
# @arguments a vector of names giving which margins to display, can include grand\_row and grand\_col or uss TRUE to display all margins
# @arguments default list of aesthetic mappings (these can be colour, size, shape, line type -- see individual grob functions for more details)
# @seealso \url{http://had.co.nz/ggplot}, \code{\link[reshape]{stamp}}, \code{\link[reshape]{reshape}}, \code{\link{ggopt}}, \code{vignette("introduction", "ggplot")}
# @keyword hplot
#X p <- ggplot(tips)
#X summary(p)
#X ggpoint(p, aesthetic=list(y = tip, x=total_bill))
#X p <- ggplot(tips, aesthetic=list(y = tip, x=total_bill))
#X p$title <- "Tips"
#X summary(p)
#X ggpoint(p)
#X ggpoint(p, colour="darkgreen", size=3)
#X ggpoint(p, list(colour=sex))
#X ggpoint(ggplot(tips, . ~ sex,aesthetics = list(y = tip, x = total_bill)))
#X p <- ggplot(tips, smoker ~ sex,aesthetics = list(y = tip, x = total_bill))
#X ggpoint(p)
#X ggsmooth(ggpoint(p))
#X ggsmooth(ggpoint(p), method=lm, formula=y~x)
#X ggabline(ggpoint(p), slope=c(0.1,0.15,0.2))
#X (p2 <- ggabline(ggpoint(p, aes=list(colour=tip/total_bill)), slope=c(0.1,0.15,0.2)))
#X summary(p2)
#X scgradient(p2)
#X scgradient(p2, midpoint=0.15, high="green", mid="yellow")
#X
#X p<-ggplot(tips, sex ~ smoker, aesthetics=list(x=tip/total_bill), margins=TRUE)
#X gghistogram(p)
#X gghistogram(p,scale="density", breaks=seq(0,1, length=20))
#X ggdensity(gghistogram(p))
#X 
#X p<-ggplot(tips, . ~ smoker, aesthetics=list(x=sex, y=tip))
#X ggboxplot(p)
#X ggjitter(ggboxplot(p))
ggplot.default <- function(data = NULL, formula = . ~ ., margins=FALSE, aesthetics=list(), ...) {
	p <- structure(list(
		data = data, 
		grobs = list(),
		scales = scales(),
		defaults = uneval(substitute(aesthetics)),
		title = "",
		fixedaspect = FALSE
	), class="ggplot")
	
	p$xlabel <- if (!is.null(p$defaults$x)) deparse(p$defaults$x) else ""
	p$ylabel <- if (!is.null(p$defaults$y)) deparse(p$defaults$y) else ""
	
	if (inherits(formula, "formula")) formula <- deparse(substitute(formula)) 
	p <- setfacets(p, formula, margins)
	(.PLOT <<- p)
}

ggplot <- function(data, ...) UseMethod("ggplot")

# Default aesthetics
# Modify the default aesthetics for a plot
# 
# @arguments plot object
# @arguments new list of aesthetics
# @keyword hplot
# @value modified plot object 
defaultaesthetics <- function(plot, aesthetics) {
  plot$defaults <- defaults(uneval(substitute(aesthetics)), plot$defaults)
  (.PLOT <<- plot)
}

# Set facetting formula and margins for a plot
# Set the function that controls how the plot is facetted into multiple panels.
# 
# @arguments plot object, if not specified will use current plot
# @arguments formula describing row and column layout, see \code{\link[reshape]{reshape}} for more details
# @arguments a vector of names giving which margins to display, can include grand\_row and grand\_col or uss TRUE to display all margins
# @keyword hplot 
setfacets <- function(p = .PLOT, formula = . ~ . , margins = FALSE) {
	if (inherits(formula, "formula")) formula <- deparse(substitute(formula)) 
	vars <- cast_parse_formula(formula, names(p$data))

	p$formula <- formula
	p$margins <- margins
	p$facet <- stamp(p$data, p$formula, function(x) 0, margins=p$margins)
	p$conditions <- as.vector(unlist(vars))
	
	(.PLOT <<- p)
}


# Set default dataset for a plot
# Set the default data set for a plot object
# 
# @arguments plot object, if not specified will use current plot
# @arguments new data set
# @keyword hplot 
setdata <- function(p = .PLOT, data) {
  p$data <- data
  vars <- cast_parse_formula(p$formula, names(p$data))

	p$facet <- stamp(p$data, p$formula, function(x) 0, margins=p$margins)
	p$conditions <- as.vector(unlist(vars))

	(.PLOT <<- p)
}

# Print ggplot
# Print generic for ggplot.  Plot on current graphics device.
#
# @arguments plot to display
# @arguments draw new (empty) page first?
# @arguments viewport to draw plot in
# @arguments other arguments passed on to \code{\link{ggplot_plot}}
# @keyword hplot
# @keyword internal 
print.ggplot <- function(x, newpage = is.null(vp), vp = NULL, save=ggopt()$save, ...) {	
	if (newpage) grid.newpage()
	if (is.null(vp)) {
		grid.draw(ggplot_plot(x, ...)) 
	} else { 
		pushViewport(vp)
		grid.draw(ggplot_plot(x, ...)) 
		upViewport()
	}
	
	if (save) {
		dev.off()
		print("\\includegraphics")
	}
}
