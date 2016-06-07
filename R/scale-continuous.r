scale_continuous <- function(variable="x", name="", transform=trans_none, range=c(NA,NA), expand=c(0, 0), breaks=NULL, to=NULL, ...) {
	#scale_new(match.call(), "continuous")
	structure(list(variable=variable, name=name, transform=transform, range=range, expand=expand, breaks=breaks, to=to, visible=TRUE, ...),
		class = c("continuous", "scale")
	)
}

#' Position: continuous
#' Add a continuous position scale to the plot
#'
#' There are a few useful things that you can do with \code{pscontinuous}:
#'
#' \itemize{
#'  \item set plot limits explicitly (with \code{range})
#'  \item transform the scale (with \code{transform})
#'  \item explicitly set where the axis labels (and grid lines) should appear (with \code{breaks})
#' }
#'
#' Note, that if you explicitly set the axis range, you may want to use
#' \code{\link{expand_range}} to add a little extra room on each side.
#'
#' When transforming an axes, you need to supply the transforming function
#' and it's inverse (used to create pretty axis labels).  I have created
#' a few common ones for you:
#'
#' \itemize{
#'   \item \code{trans_log10}: log base 10
#'   \item \code{trans_log2}: log base 2
#'   \item \code{trans_inverse}: inverse
#'   \item \code{trans_sqrt}: square root
#' }
#'
#' @param plot plot
#' @param variable variable ("x" or "y")
#' @param name namen of the scale (used in the legend)
#' @param transform transform function and it's inverse in a vector
#' @param range range, or leave missing to automatically determine
#' @param expand expansion vector (numeric vector, multiplicative and additive expansion)
#' @param breaks set breaks manually
#' @export
#' @examples
#' p <- ggpoint(ggplot(mtcars, aesthetics=list(x=mpg, y=disp)))
#' pscontinuous(p, "x", range=c(20,30))
#' pscontinuous(p, "y", breaks=seq(100, 400, 50))
#' pscontinuous(p, "y", transform=trans_inverse)
#' pscontinuous(p, "x", transform=trans_sqrt)
#' pscontinuous(p, "x", transform=trans_log10)
#' pscontinuous(p, "x", transform=trans_log10, breaks=seq(10,30, 5))
pscontinuous <- function(plot, variable="x", name="", transform=trans_none, range=c(NA,NA), expand=c(0.05, 0), breaks=NULL) {
	sc <- position_continuous(variable=variable, name=name, expand=expand, transform=transform, range=range, breaks=breaks)
	add_scale(plot, sc)
}

position_continuous <- function(variable="x", name="", transform=trans_none, range=c(NA,NA), expand=c(0, 0.5), breaks=NULL) {
	range <- (transform[[1]])(range)

	sc <- scale_continuous(variable=variable, expand=expand, name=name, transform=transform, range=range, breaks=breaks)
	class(sc) <- c("position", class(sc))
	sc
}

#' @rdname pscontinuous
#' @export
trans_none     <- c(force, force)
#' @rdname pscontinuous
#' @export
trans_log10    <- c(log10, function(x) 10^x)
#' @rdname pscontinuous
#' @export
trans_log2     <- c(log2, function(x) 2^x)
#' @rdname pscontinuous
#' @export
trans_sqrt     <- c(sqrt, function(x) x^2)
#' @rdname pscontinuous
#' @export
trans_inverse  <- c(function(x) 1/x, function(x) 1/x)

#' @export
map_aesthetic.continuous <- function(scale, data, ...) {
	if (nrow(data) == 0) return(data.frame())

	df <- data.frame((scale$transform[[1]])(as.numeric(data[[input(scale)]])))
	names(df) <- input(scale)

	if (!is.null(scale$to)) df <- rescale(df, scale$to, scale$range)

	df
}
#' @export
"update<-.continuous" <- function(x, value) {
	val <- (x$transform[[1]])(as.numeric(value[[input(x)]]))

	x$range[is.na(x$range)] <- range(val, na.rm=TRUE)[is.na(x$range)]
	if(diff(x$range) == 0) x$range <- c(0.9, 1.1) * (x$range[1])
	x
}
#' @export
breaks.continuous <- function(scale, ...) {
	if (!is.null(scale$breaks)) return((scale$transform[[1]])(scale$breaks))

	r <- grid.pretty(range(scale))
	if (!is.null(scale$to)) r <- rescale(r, scale$to, scale$range)
	r
}
#' @export
range.continuous <- function(scale, ...) expand_range(scale$range, scale$expand[1], scale$expand[2])

#' @export
labels.continuous <- function(object, ...) {
  if (is.null(object$breaks)) {
    breaks <- (object$transform[[2]])(grid.pretty(range(object)))
  } else {
    breaks <- object$breaks
  }

	formatC(breaks, digits=3, format="fg", width=1)
}

#' @export
print.continuous <- function(x, ...) {
	cat(paste("Continuous scale ", input(x), "\n", sep=""))
	x$range[is.na(x$range)] <- "auto"
	cat(paste("  Range:     [", x$range[1], ", ", x$range[2], "]\n", sep=""))
	if (!is.null(x$to))
		cat(paste("  Scaled to: [", x$to[1], ", ", x$to[2], "]\n", sep=""))
	if (!identical(x$expand,c(0,0)))
		cat(paste("  Expansion: ", x$expand[1], ", ", x$expand[2], "\n", sep=""))
	if (is.null(x$breaks)) {
		cat("  Breaks:    automatic\n")
	} else {
		cat(paste("       Breaks: ", paste(x$breaks, collapse=", "), "\n", sep=""))
	}
}


#' Scale: size
#' Linearly map size to a variable.
#'
#' The mapping between size and the original variable value is not
#' linear, but square rooted.  This is because the human brain tends to
#' percieve area rather than radius.
#'
#' You can manipulate the range of the result by modifying the \code{to}
#' argument.
#'
#' @inheritParams pscontinuous
#' @param to size range in mm (numeric vector, length 2)
#' @export
#' @examples
#' p <- ggplot(mtcars, aes=list(x=mpg, y=hp))
#' ggpoint(p)
#' ggpoint(p, list(size=wt))
#' scsize(ggpoint(p, list(size=wt)), c(1,10))
#' scsize(ggpoint(p, list(size=sqrt(wt))), c(1,5))
scsize <- function(plot, name="", to=c(0.8, 5)) {
	add_scale(plot, scale_size(name=name, to))
}
scale_size <- function(name="", to=c(0.8, 5)) scale_continuous(variable="size", name=name, to=to, transform=trans_sqrt)


#' Scale: colour gradient
#' Scale a continuous variable along a colour gradient.
#'
#' This scale creates a continuous colour gradient from the
#' low colour to the mid colour to high colour, as defined in the
#' arguments.
#'
#' @inheritParams pscontinuous
#' @param low colour at low end of scale
#' @param mid colour at middle of scale
#' @param high colour at top of scale
#' @param midpoint definition of midpoint
#' @param range range to scale data to
#' @export
#' @examples
#' library(ggplot2movies)
#' p <- scgradient(ggplot(movies, aes=list(x=mpaa, y=rating)))
#' ggjitter(p, list(colour=rating))
#' ggjitter(p, list(colour=length))
#' p <- ggjitter(p, list(colour=rating))
#' scgradient(p, low="yellow")
#' scgradient(p, high="green", midpoint=5)
scgradient <- function(plot, name="", low='red', mid='white', high="black", midpoint=0, range=c(NA,NA)) {
	add_scale(plot, scale_gradient(name=name, low, mid, high, midpoint))
}
#' @export
#' @rdname scgradient
scfillgradient <- function(plot, name="", low='red', mid='white', high="black", midpoint=0, range=c(NA,NA)) {
	add_scale(plot, scale_gradient(name=name, low, mid, high, midpoint, variable="fill"))
}
scale_gradient <- function(name="", low="red", mid="white", high="black", midpoint=0, range=c(NA,NA), variable="colour") {
	x <- scale_continuous(variable, range=range)
	x$low <- low
	x$mid <- mid
	x$high <- high
	x$midpoint <- midpoint
	x$name <- name

	class(x) <- c("gradient", class(x))
	x
}

#' @export
"update<-.gradient" <- function(x, value) {
	x$range[is.na(x$range)] <- range(value[[input(x)]], na.rm=TRUE)[is.na(x$range)]
	x
}

#' @export
defaultgrob.gradient <- function(x) grob_tile

#' @export
labels.gradient <- function(object, ...) {
  formatC(ggpretty(range(object)), digits=2)
}

#' @export
breaks.gradient <- function(scale, ...) {
  map_colour_gradient(ggpretty(range(scale)), low=scale$low, mid=scale$mid, high=scale$high, midpoint=scale$midpoint, from=scale$range)
}

#' @export
map_aesthetic.gradient <- function(scale, data, ...) {
	if (is.null(data[[input(scale)]])) return(data.frame())

	df <- data.frame(colour=map_colour_gradient(data[[input(scale)]], low=scale$low, mid=scale$mid, high=scale$high, midpoint=scale$midpoint, from=scale$range))
	names(df) <- output(scale)
	df
}

#' @export
print.gradient <- function(x, ...) {
	cat(paste("Continuous scale colour gradient\n", sep=""))
	cat(paste("  Colours: ", x$low, " -> ", x$mid, " (", x$midpoint, ") -> ", x$high, "\n", sep=""))
	x$range[is.na(x$range)] <- "auto"
	cat(paste("  Range:   [", x$range[1], ", ", x$range[2], "]\n", sep=""))
}
