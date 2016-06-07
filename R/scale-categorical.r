#' Add a categorical position scale to the plot
#'
#' A categorical scale converts a factor into a numerical representation
#' very simply: by using \code{as.numeric}.  This means that levels
#' will be placed a integer locations in the same order that they
#' appear in the levels of the factor (see \code{\link{levels}}).
#'
#' If you want to reorder (or combine) categories, currently the best way
#' to do this is to modify the original factors.  In a future version of ggplot
#' I will probably expand the categorical scale so that you can do that here.
#'
#' This scale is added to the plot automatically when you use a categorical
#' variable in the x or y aesthetics.  You shouldn't need to to call this function
#' unless (for some reason) you want to change the expansion factor.
#'
#' @param plot ggplot object
#' @param variable axis ("x" or "y")
#' @param name name of the scale (used in the legend)
#' @param expand expansion vector (numeric vector, multiplicative and additive
#'   expansion).  Defaults to adding 0.6 on either end of the scale.
#' @export
#' @examples
#' p <- ggpoint(ggplot(mtcars, aesthetics=list(x=cyl, y=mpg)))
#' pscategorical(p, "x") # no change, because already categorical
#' pscategorical(p, "y") # chops into discrete segments
pscategorical <- function(plot, variable="x", name="", expand=c(0.01, 0.6)) {
	add_scale(plot,  position_categorical(variable=variable, name=name, expand=expand) )
}
position_categorical <- function(variable="x", name="", expand=c(0, 0.5)) {
	sc <- scale_categorical(variable=variable, name=name, expand=expand, visible=TRUE)
	class(sc) <- c("position", class(sc))
	sc
}


scale_categorical <- function(variable="x", name="", expand=c(0,0), transform=as.numeric, ...) {
  stopifnot(is.function(transform))
	structure(
		list(variable=variable, name=name, expand=expand, transform=transform, args=list(...)),
		class = c("categorical", "scale")
	)

}

#' @export
"update<-.categorical" <- function(x, value) {
	if (!(input(x) %in% names(value))) return(x)

	val <- chop_auto(value[[input(x)]])
	x$autobreaks <- attr(val, "breaks")

	uval <- sort(unique(val))
	attributes(uval) <- attributes(val)
	x$map <- do.call(x$transform, c(list(uval), x$args))
	names(x$map) <- levels(val)
	x
}

#' @export
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

#' @export
breaks.categorical <- function(scale, ...) scale$map

#' @export
labels.categorical <- function(object, ...) {
	if (is.null(object$autobreaks)) return(names(object$map))

	breaks <- formatC(object$autobreaks, digits=2, format="fg", width=1)

	paste(breaks[-length(breaks)], breaks[-1], sep="-")

}

#' @export
range.categorical <- function(scale, ...) expand_range(range(scale$map), scale$expand[1], scale$expand[2])


#' @export
print.categorical <- function(x, ...) {
	cat(paste("Categorical scale: ", scale_mapping(x), "\n", sep=""))
}

#' @export
defaultgrob.categorical <- function(x) {
  switch(x$variable,
    colour   = grob_tile,
    shape    = function(x) grob_point(x, unique=FALSE),
    fill     = grob_tile,
    linetype = grob_line)
}

#' Scale: categorical colour
#' Create a scale for categorical colours.
#'
#' Continuous variables will automatically be converted to categorical
#' using \code{\link{chop_auto}}.  You may want to use \code{\link{chop}}
#' to convert the values yourself for finer control.
#'
#' This scale is automatically added when you have colour in your list of
#' aesthetics.  For finer control, you will need to set the scale
#' yourself.  See the example for some ideas.
#'
#' @inheritParams pscategorical
#' @param h range of hues to use
#' @param l luminance value
#' @param c chroma value
#' @param alpha alpha value
#' @export
#' @examples
#' library(ggplot2movies)
#' p <- ggplot(movies, aes=list(x=mpaa, y=rating))
#' ggjitter(p, list(colour=rating))
#' ggjitter(p, list(colour=length))
#' ggjitter(p, list(colour=chop(length)))
#' ggjitter(p, list(colour=chop(length,3)))
#' sccolour(ggjitter(p, list(colour=chop(length,3))), 2)
sccolour <- function(plot, name="", h=c(0,360), l=65, c=100, alpha=1) {
	add_scale(plot, scale_colour(name=name, h=h, l=l, c=c, alpha=alpha))
}
#' @rdname sccolour
#' @export
sccolor <- sccolour
scale_colour <- function(name="", h=c(0, 360), l=65, c=100, alpha=1) scale_categorical("colour", name=name, h=h, l=l, c=c, transform=map_colour, alpha=alpha)

#' @rdname sccolour
#' @export
scfill <- function(plot, name="", h=c(0,360), l=75, c=100, alpha=1) {
	add_scale(plot, scale_fill(name=name, h=h, l=l, c=c, alpha=alpha))
}
scale_fill <- function(name="", h=c(0,360), l=75, c=100, alpha=1) scale_categorical("fill", name=name, h=h, l=l, c=c, transform=map_colour, alpha=alpha)

#' Scale: Brewer colours
#' Use Brewer colour scheme for colour fill.
#'
#' @inheritParams pscategorical
#' @param palette Color Brewer palette to use, see
#'   \code{\link[RColorBrewer]{brewer.pal}} for details. Note that palette type
#'   is chosen automatically.
#' @export
scfillbrewer <- function(plot, name="", palette=1) {
	add_scale(plot, scale_fill_brewer(name=name, palette=palette))
}
scale_fill_brewer <- function(name="", palette=1) scale_categorical("fill", name=name, palette=palette, transform=map_colour_brewer)

#' Scale: shape
#'
#' This scale is automatically added when you use the shape aesthetic
#' mapping.  By using this scale you can explicitly decide whether the
#' points used should be hollow or solid.
#'
#' @inheritParams pscategorical
#' @param solid should points be solid or hollow?
#' @export
#' @examples
#' p <- ggplot(mtcars, aes=list(x=mpg, y=wt, shape=cyl))
#' ggpoint(p)
#' ggpoint(scshape(p, FALSE))
scshape <- function(plot, name="", solid=TRUE) {
	add_scale(plot, scale_shape(name=name, solid))
}
scale_shape <- function(name="", solid=TRUE) scale_categorical("shape", name=name, solid=solid, transform=map_shape)


#' Scale: line type
#'
#' This scale is automatically added to the plot when you use the linetype
#' aesthetic.  As there are no options to this scale, you shouldn't ever
#' need to add it yourself.
#'
#' @inheritParams pscategorical
#' @export
#' @examples
#' p <- ggplot(mtcars, aes=list(x=mpg, y=wt, linetype=cyl))
#' ggline(p)
#' ggline(sclinetype(p))
sclinetype <- function(plot, name="") {
	add_scale(plot, scale_linetype(name=name))
}
scale_linetype <- function(name="") scale_categorical("linetype", name=name, transform=map_linetype)
