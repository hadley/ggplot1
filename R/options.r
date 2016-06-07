#' @export
#' @rdname ggopt
theme_bw <- list(
	grid.colour = "grey80",
	grid.fill = "white"
)

#' @export
#' @rdname ggopt
theme_default <- list(
	aspect.ratio = NULL,
	axis.colour = "grey50",
	background.colour = "black",
	background.fill = "white",
	grid.colour = "white",
	grid.fill = "grey90",
	legend.position = "right",
	save = FALSE,
	strip.gp = grid::gpar(col = "white", fill = "grey80", lwd=3),
	strip.text = function(variable, value) paste(variable, value, sep=": "),
	strip.text.gp = grid::gpar()
)

#' Set global options for ggplot.
#'
#' These are aliased into every plot object, so that \code{p$grid.col} will
#' return the default grid colour, unless it has been overriden for a particular
#' plot object.  You can change the global options using the function, or the
#' options for a specific plot by setting the values directly on the object.  See
#' the examples for more details.
#'
#' Colour settings:
#'
#' \itemize{
#' 	\item axis.colour: axis text and line colour ("black")
#' 	\item background.colour: background text colour ("black"), used for title
#' 	\item background.fill:   background fill ("white")
#' 	\item grid.colour: plot grid colour ("white")
#' 	\item grid.fill:   plot grid background fill ("grey90")
#' }
#'
#' Strip settings
#'
#' \itemize{
#' 	\item strip.text:   function with two arguments (variable, and value) used for
#' 		generating strip labels
#' 	\item strip.gp: graphic parameter settings for the strip
#' 	\item strip.text.gp:  graphic parameter settings for the strip text
#' }
#'
#' Legend settings
#'
#' \itemize{
#' 	\item legend.position:   position of legend: "none" to hide legend;
#' 		"left", "right", "top", "bottom", for positioning outside of plot;
#' 		c(x, y) for positioning on top of plot
#' }
#'
#' Other settings:
#'
#' \itemize{
#' 	\item aspect.ratio: aspect ratio of facets.  Set to \code{NULL} to allow
#'				 to vary with device size
#' }
#'
#' @param ... named options to set
#' @param theme list of options set
#' @export
#' @examples
#' # Change global options
#' ggopt(background.fill = "black", background.color ="white")
#' p <- ggpoint(ggplot(reshape::tips, smoker ~ sex,aesthetics = list(y = tip, x = total_bill)))
#' p
#'
#' # Change individual plot options
#' p$background.fill = "white"
#' p
#' p$strip.text.gp <- grid::gpar(col="red", fontsize=8)
#' p$background.colour <- "pink"
#' p$grid.colour <- "green"
#' p$grid.fill <- "blue"
#' p # a very ugly plot!
#'
#' # Use ggtheme(theme_default) to reset back to the
#' # default theme.
#' ggtheme(theme_default)
ggopt <- local({
  opts <- theme_default
  function(...) {
    opts <<- reshape::updatelist(theme_default, list(...))
	  opts
  }
})

#' @export
print.options <- function(x, ...) utils::str(x)

#' @export
#' @rdname ggopt
ggtheme <- function(theme) {
	do.call(ggopt, theme)
}

#' @export
"$.ggplot" <- function(x, i) {
  if (i %in% names(x)) {
    x[[i]]
  } else {
    ggopt()[[i]]
  }
}
