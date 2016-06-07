# Set ggplot options
# Set global options for ggplot.
# 
# These are aliased into every plot object, so that \code{p$grid.col} will
# return the default grid colour, unless it has been overriden for a particular
# plot object.  You can change the global options using the function, or the
# options for a specific plot by setting the values directly on the object.  See
# the examples for more details.
# 
# Colour settings:
# 
# \itemize{
# 	\item axis.colour: axis text and line colour ("black")
# 	\item background.colour: background text colour ("black"), used for title
# 	\item background.fill:   background fill ("white")
# 	\item grid.colour: plot grid colour ("white")
# 	\item grid.fill:   plot grid background fill ("grey90")
# }
# 
# Strip settings
# 
# \itemize{
# 	\item strip.text:   function with two arguments (variable, and value) used for
# 		generating strip labels
# 	\item strip.gp: graphic parameter settings for the strip
# 	\item strip.text.gp:  graphic parameter settings for the strip text
# }
# 
# Legend settings
# 
# \itemize{
# 	\item legend.position:   position of legend: "none" to hide legend;
# 		"left", "right", "top", "bottom", for positioning outside of plot;
# 		c(x, y) for positioning on top of plot
# }
# 
# Other settings:
# 
# \itemize{
# 	\item aspect.ratio: aspect ratio of facets.  Set to \code{NULL} to allow
#				 to vary with device size
# }
# 
# @arguments list of options to get/set
# @keyword manip 
# @alias ggopt
# @alias theme_default
# @alias theme_bw
#X ggopt(background.fill = "black", background.color ="white") # all new plots will use this
#X p <- ggpoint(ggplot(tips, smoker ~ sex,aesthetics = list(y = tip, x = total_bill)))
#X p
#X p$background.fill = "white"
#X p
#X p$strip.text.gp <- gpar(col="red", fontsize=8)
#X p$background.colour <- "pink"
#X p$grid.colour <- "green"
#X p$grid.fill <- "blue"
#X p # a very ugly plot!
#X ggopt(background.fill = "white", background.color ="black")
.build_options <- function(opt) {
	class(opt) <- "options"
	
	function(...) {
		opt <<- updatelist(opt, list(...))
		opt
	}
}

# Print options
# 
# @keyword internal 
print.options <- function(x, ...) str(x)

# Set ggplot theme.
# A theme is a list of options for \code{\link{ggopt}}. 
# 
# Use \code{ggtheme(defaulttheme)} to reset back to the
# default theme.
# 
# @arguments theme, a list of options for \code{\link{ggopt}}
# @keyword manip 
ggtheme <- function(theme) {
	do.call(ggopt, theme)
}

theme_default <- list(
	aspect.ratio = NULL,
	axis.colour = "grey50",
	background.colour = "black",
	background.fill = "white",
	grid.colour = "white",
	grid.fill = "grey90",
	legend.position = "right",
	save = FALSE,
	strip.gp = gpar(col = "white", fill = "grey80", lwd=3),
	strip.text = function(variable, value) paste(variable, value, sep=": "),
	strip.text.gp = gpar()
)
ggopt <- .build_options(theme_default)


theme_bw <- list(
	grid.colour = "grey80",
	grid.fill = "white"
)

# Access ggplot options
# Alias default options to plot object
# 
# @keyword internal
"$.ggplot" <- function(x, i) {
  if (i %in% names(x)) {
    x[[i]]
  } else {
    ggopt()[[i]]
  }
}