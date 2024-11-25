#' Grob function: histogram
#'
#' Conceptually, the histogram is one of the most complicated
#' of the grob functions, becuase it takes a 1D data set and makes
#' it two dimensional.  This necessitates an extra step, the \code{pre_histogram}
#' function which bins the data and returns the bins with their counts.
#' This data is then used my \code{grob_histogram}
#' to plot the points.
#'
#' Aesthetic mappings that this grob function understands:
#'
#' \itemize{
#'   \item \code{x}:x position (required)
#'   \item \code{weight}: observation weights
#' }
#'
#' These can be specified in the plot defaults (see \code{\link{ggplot}}) or
#' in the \code{aesthetics} argument.  If you want to modify the position
#' of the points or any axis options, you will need to add a position scale to
#' the plot.  These functions start with \code{ps}, eg.
#' \code{\link{pscontinuous}} or \code{\link{pscategorical}}
#'
#' Other options:
#'
#' \itemize{
#'   \item \code{breaks}:breaks argument passed to \code{\link{hist}}
#'   \item \code{scale}:scale argument passed to \code{\link{hist}}
#' 	\item any other aesthetic setting passed on to \code{\link{ggrect}}
#' }
#'
#' @inheritParams ggpoint
#' @param scale scale of y-axis
#' @export
#' @examples
#' library(ggplot2movies)
#' m <- ggplot(movies, aesthetics=list(x=rating))
#' gghistogram(m)
#' gghistogram(m, breaks=100)
#'
#' m <- ggplot(movies, Action ~ Comedy, aesthetics=list(x=rating), margins=TRUE)
#' gghistogram(m)
#' gghistogram(m, scale="freq")
#' gghistogram(m, colour="darkgreen", fill="white")
#' ggdensity(gghistogram(m, colour="darkgreen", fill="white"))
gghistogram <- function(plot, aesthetics=list(), scale="prob", ..., data=NULL) {
	plot <- pscontinuous(plot, "y", range=c(0,NA), expand=c(0.05,0))
	plot <- pscontinuous(plot, "x", expand=c(0.15, 0))

	plot$ylabel <- if (scale == "prob") "Density" else "Frequency"

	gg_add("histogram", plot, aesthetics, scale=scale, ..., data=data)
}
pre_histogram <- function(data, breaks=20, scale="prob", ...) {
	if (is.function(breaks)) breaks <- breaks(data$x)
	h <- graphics::hist(data$x, breaks=breaks, plot=FALSE)

	if (!is.null(data$weight)) {
		h$counts <- tapply(data$weight, cut(data$x, h$breaks), sum)
	  h$density <- h$counts/diff(h$breaks)
	}

	if (is.character(scale) && scale == "prob") {
		y <- h$density
	} else if (is.numeric(scale) && length(scale == 2)){
		y <- rescale(h$density, scale)
	} else {
		y <- h$counts
	}

	cbind(
		data.frame(y = y, x=h$breaks[-1], width = diff(h$breaks), height=y),
		data[rep(1, length(h$breaks) - 1),intersect(c("fill"), names(data)), drop=FALSE]
	)
}
grob_histogram <- function(...) grob_bar(..., justification=c("right", "top"))

#' Grob function: quantiles
#'
#' This can be used a continuous analogue of a boxplot (see \code{\link{ggboxplot}})
#' Lines will be automatically sized to reflect their distance from the median.
#'
#' Aesthetic mappings that this grob function understands:
#'
#' \itemize{
#'   \item \code{x}:x position (required)
#'   \item \code{y}:y position (required)
#'   \item \code{weight}: observation weights
#' }
#'
#' These can be specified in the plot defaults (see \code{\link{ggplot}}) or
#' in the \code{aesthetics} argument.  If you want to modify the position
#' of the points or any axis options, you will need to add a position scale to
#' the plot.  These functions start with \code{ps}, eg.
#' \code{\link{pscontinuous}} or \code{\link{pscategorical}}
#'
#' Other options:
#'
#' \itemize{
#'   \item \code{quantiles}:quantiles to display
#'   \item \code{formula}:formula to use in quantile regression
#' }
#'
#' @seealso \code{\link[quantreg]{rq}} for the code used to fit the quantile regression
#' @inheritParams ggpoint
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2movies)
#' m <- ggplot(movies, aesthetics=list(y=length, x=rating))
#' ggquantile(m)
#' }
ggquantile <- function(plot, aesthetics=list(), ..., data=NULL) {
	gg_add("quantile", plot, aesthetics, ..., data=data)
}
grob_quantile <- function(aesthetics, quantiles=c(0.05, 0.25, 0.5, 0.75, 0.95), formula=y ~ splines::ns(x, 5), ...) {
	aesthetics <- aesdefaults(aesthetics, list(weight=rep(1, length(aesthetics$y))), ...)
	if (!requireNamespace("quantreg", quietly=TRUE)) stop("You need to install the quantreg package!")

	xseq <- seq(min(aesthetics$x, na.rm=TRUE), max(aesthetics$x, na.rm=TRUE), length=30)

	model <- quantreg::rq(formula, data=aesthetics, tau=quantiles, weight=aesthetics$weight) #
	yhats <- stats::predict(model, data.frame(x=xseq))
	qs <- data.frame(y = as.vector(yhats), x = xseq, id = rep(quantiles, each=length(xseq)))
	qs$size <- (0.5 - abs(0.5 - qs$id))*5 + 0.5

	grob_path(qs, ...)
}

#' Grob function: boxplot
#' Add box and whiskers
#'
#' Aesthetic mappings that this grob function understands:
#'
#' \itemize{
#'   \item \code{x}:x position (required)
#'   \item \code{y}:y position (required)
#'   \item \code{weight}: observation weights
#' }
#'
#' These can be specified in the plot defaults (see \code{\link{ggplot}}) or
#' in the \code{aesthetics} argument.  If you want to modify the position
#' of the points or any axis options, you will need to add a position scale to
#' the plot.  These functions start with \code{ps}, eg.
#' \code{\link{pscontinuous}} or \code{\link{pscategorical}}
#'
#' Other options:
#'
#' \itemize{
#'   \item \code{breaks}:how to break up the x axis (only used if not already a factor)
#'   \item \code{orientation}: whether boxplots should be horizontal or vertical.
#'     If missing will automatically decide based on which variable is a factor.
#'   \item other arguments passed \code{\link{boxplot}}
#' }
#'
#' @seealso \code{\link{ggquantile}} for a continuous analogue of the boxplot
#' @inheritParams ggpoint
#' @export
#' @examples
#' p <- ggplot(mtcars, aesthetics=list(y=mpg, x=factor(cyl)))
#' p2 <- ggplot(mtcars, aesthetics=list(x=mpg, y=factor(cyl)))
#' ggpoint(p)
#' ggboxplot(p)
#' ggboxplot(p2)
#' ggboxplot(p, fill="pink", colour="green")
#' ggpoint(ggboxplot(p))
#' ggboxplot(p)
ggboxplot <- function(plot, aesthetics=list(), ..., data=NULL) {
	gg_add("boxplot", plot, aesthetics, ..., data=data)
}
grob_boxplot <- function(aesthetics, breaks=length(unique(aesthetics$x)), orientation, ...) {

	aesthetics <- aesdefaults(aesthetics, list(fill="white", colour="grey50", weight=rep(1, length(aesthetics$x))), ...)
	swap <- function(list) {
	  if (orientation == "vertical") return(list)
	  plyr::rename(list, c(x="y", y="x", height="width", width="height"))
	}
	just <- function() switch(orientation,
	  vertical = c("centre","bottom"),
	  horizontal = c("left", "centre"))

	if (missing(orientation)) orientation <- if(resolution(aesthetics$y) == 1) "horizontal" else "vertical"

	aesthetics <- swap(aesthetics)
	aesthetics$x <- as.numeric(aesthetics$x)
	n <- length(aesthetics$x)
	breakpoints <- cut(aesthetics$x, breaks, labels=FALSE)
	xrange <- list(
		min =    tapply(aesthetics$x, breakpoints, min, na.rm=TRUE),
		max =    tapply(aesthetics$x, breakpoints, max, na.rm=TRUE),
		median = tapply(aesthetics$x, breakpoints, stats::median, na.rm=TRUE),
		width =  tapply(aesthetics$x, breakpoints, function(x) diff(range(x, na.rm=TRUE))) * 0.5 + 0.5,
		colour = tapply(rep(as.character(aesthetics$colour),length=n), breakpoints, function(x) x[1]),
		fill =   tapply(rep(as.character(aesthetics$fill),  length=n), breakpoints, function(x) x[1])
	)

	boxes <- boxplot_weighted_formula(aesthetics$y ~ breakpoints, weights=aesthetics$weight, plot=FALSE, ...)
	# lower whisker, lower hinge, median, upper hinge and upper whisker

	outliers <- list(y = boxes$out, x = as.vector(xrange$median[boxes$group]), colour="red")
	uwhiskers <- list(y = c(boxes$stats[1,], boxes$stats[2, ]), x=rep(xrange$median, 2), id=rep(xrange$median, 2),  colour=xrange$colour)
	lwhiskers <- list(y = c(boxes$stats[4,], boxes$stats[5, ]), x=rep(xrange$median, 2), id=rep(xrange$median, 2),  colour=xrange$colour)
	hinges <- list(x = xrange$median, width=xrange$width, y=boxes$stats[2,], height=boxes$stats[4,] - boxes$stats[2,], fill=xrange$fill, colour=xrange$colour)
	medians <- list(x= xrange$median, width=xrange$width, y=boxes$stats[3,], height=unit(0.8,"mm"), colour=xrange$colour, fill=xrange$colour)

	gTree(children = gList(
		grob_path(swap(uwhiskers)),
		grob_path(swap(lwhiskers)),
		grob_rect(swap(hinges), justification=just()),
		grob_rect(swap(medians), justification=just()),
		grob_point(swap(outliers))
	)) # , name="boxplot"
}


#' Grob function: smooth
#'
#' This grob adds a smoother to the graphic to aid the eye in
#' seeing important patterns, especially when there is a lot of overplotting.
#'
#' You can customise this very freely, firstly by choosing the function used
#' to fit the smoother (eg. \code{\link{loess}}, \code{\link{lm}}, \code{\link{rlm}},
#' \code{\link{gam}}, \code{\link{glm}}) and the formula used to related the y and x
#' values (eg. \code{y ~ x}, \code{y ~ poly(x,3)}).
#'
#' This smoother is automatically restricted to the range of the data.  If you
#' want to perform predictions (or fit more complicated variabels with covariates)
#' then you should fit the model and plot the predicted results.
#'
#' Aesthetic mappings that this grob function understands:
#'
#' \itemize{
#'   \item \code{x}:x position (required)
#'   \item \code{y}:y position (required)
#'   \item \code{size}:size of the point, in mm (see \code{\link{scsize})}
#'   \item \code{colour}:point colour (see \code{\link{sccolour})}
#'   \item \code{weight}: observation weights
#' }
#'
#' These can be specified in the plot defaults (see \code{\link{ggplot}}) or
#' in the \code{aesthetics} argument.  If you want to modify the position
#' of the points or any axis options, you will need to add a position scale to
#' the plot.  These functions start with \code{ps}, eg.
#' \code{\link{pscontinuous}} or \code{\link{pscategorical}}
#'
#' Other options:
#'
#' \itemize{
#'   \item \code{method}:smoothing method (function) to use
#'   \item \code{formula}:formula to use in smoothing function
#'   \item \code{se}:display one standard error on either side of fit? (true by default)
#'   \item other arguments are passed to smoothing function
#' }
#'
#' @inheritParams ggpoint
#' @export
#' @examples
#' p <- ggpoint(ggplot(mtcars, aesthetics=list(y=wt, x=qsec)))
#' ggsmooth(p)
#' ggsmooth(p, span=0.9)
#' ggsmooth(p, method=lm)
#' ggsmooth(p, method=lm, formula = y~splines::ns(x,3))
#' ggsmooth(p, method=MASS::rlm, formula = y~splines::ns(x,3))
ggsmooth <- function(plot, aesthetics=list(), ..., data=NULL) {
	gg_add("smooth", plot, aesthetics, ..., data=data)
}
grob_smooth <- function(aesthetics, method=stats::loess, formula=y~x, se = TRUE, ...) {
	aesthetics <- aesdefaults(aesthetics, list(colour="black", size=1, weight=rep(1, length(aesthetics$x))), ...)
	xseq <- seq(min(aesthetics$x, na.rm=TRUE), max(aesthetics$x, na.rm=TRUE), length=80)
	method <- match.fun(method)

	colour <- as.character(reshape::uniquedefault(aesthetics$colour, "black"))
	size <- reshape::uniquedefault(aesthetics$size, 1)

	model <- method(formula, data=aesthetics, ..., weight=weight)
	pred <- stats::predict(model, data.frame(x=xseq), se=se)

	if (se) {
		gTree(children=gList(
			grob_path(list(y = as.vector(pred$fit), x = xseq, colour=colour, size=size)),
			grob_path(list(y = as.vector(pred$fit + 2 * pred$se.fit), x = xseq, colour="grey80")),
			grob_path(list(y = as.vector(pred$fit - 2 * pred$se.fit), x = xseq, colour="grey80")),
			grob_ribbon(list(y = c(pred$fit + 2 * pred$se.fit, rev(pred$fit - 2 * pred$se.fit)), x = c(xseq,rev(xseq))), colour=NA, fill=alpha("grey50", 0.2))
		)) # , name="smooth"
	} else {
		grob_path(list(y = as.vector(pred), x = xseq, colour=colour, size=size))
	}
}

# Models generally use NSE to evaluate name of weight variable in context of
# data
globalVariables("weight")

#' Grob function: contours
#' Create a grob to display contours of a 3D data set.
#'
#' Aesthetic mappings that this grob function understands:
#'
#' \itemize{
#'   \item \code{x}:x position (required)
#'   \item \code{y}:y position (required)
#'   \item \code{z}:z position (required)
#' }
#'
#' These can be specified in the plot defaults (see \code{\link{ggplot}}) or
#' in the \code{aesthetics} argument.  If you want to modify the position
#' of the points or any axis options, you will need to add a position scale to
#' the plot.  These functions start with \code{ps}, eg.
#' \code{\link{pscontinuous}} or \code{\link{pscategorical}}
#'
#' Other options:
#'
#' \itemize{
#'   \item \code{nlevels}: number of contours to draw
#'   \item \code{levels}: contour positions
#' 	\item \code{...}: other aesthetic parameters passed to \code{\link{ggpath}}
#' }
#'
#' @seealso \code{\link{gg2density}}
#' @inheritParams ggpoint
#' @export
#' @examples
#' volcano3d <- data.frame(expand.grid(x = 1:nrow(volcano), y=1:ncol(volcano)), z=as.vector(volcano))
#' p <- ggplot(volcano3d, aesthetics=list(x=x,y=y,z=z))
#' ggcontour(p)
#' ggcontour(p, colour="red")
#' ggcontour(p, nlevels=3)
#' ggcontour(ggtile(p, list(fill=z)))
ggcontour <- function(plot, aesthetics=list(), ..., data=NULL) {
	gg_add("contour", plot, aesthetics, ..., data=data)
}
grob_contour <- function(aesthetics, nlevels=10, levels, ...) {
	if (missing(levels)) levels <- pretty(range(aesthetics$z,na.rm=TRUE),nlevels)
	gridise <- function(x) {
		unique <- sort(unique(x[!is.na(x)]))
		id <- match(x, unique)
		list(unique=unique, id=id)
	}

	gridx <- gridise(aesthetics$x)
	gridy <- gridise(aesthetics$y)

	gridz <- matrix(NA, nrow = length(gridx$unique), ncol = length(gridy$unique))
	gridz[(gridy$id - 1) * length(gridx$unique) + gridx$id] <- aesthetics$z

	clines <- grDevices::contourLines(x = gridx$unique, y = gridy$unique, z = gridz, nlevels = nlevels, levels = levels)

	gTree(children = do.call(gList, lapply(clines, grob_path, ...))) # , name="contour"
}


#' Grob function: 1d density
#' Display a smooth density estimate.
#'
#' Aesthetic mappings that this grob function understands:
#'
#' \itemize{
#'   \item \code{x}:x position (required)
#'   \item \code{weight}: observation weights
#' }
#'
#' These can be specified in the plot defaults (see \code{\link{ggplot}}) or
#' in the \code{aesthetics} argument.  If you want to modify the position
#' of the points or any axis options, you will need to add a position scale to
#' the plot.  These functions start with \code{ps}, eg.
#' \code{\link{pscontinuous}} or \code{\link{pscategorical}}
#'
#' Other options:
#'
#' \itemize{
#'   \item \code{adjust}: see \code{\link{density}}
#' 		for details
#' 	\item \code{kernel}: kernel used for density estimation, see \code{\link{density}}
#' 		for details
#' 	\item other aesthetic properties passed on to \code{\link{ggline}}
#'   \item \code{weight}: observation weights
#' }
#'
#' @seealso \code{\link{gghistogram}}, \code{\link{density}}
#' @inheritParams ggpoint
#' @export
#' @examples
#' library(ggplot2movies)
#' m <- ggplot(movies, aesthetics=list(x=rating))
#' ggdensity(m)
#'
#' m <- ggplot(movies, Action ~ Comedy, aesthetics=list(x=rating), margins=TRUE)
#' ggdensity(m)
#' ggdensity(m, scale="freq")
#' ggdensity(m, colour="darkgreen", size=5)
ggdensity <- function(plot, aesthetics=list(), ..., data=NULL) {
	plot$ylabel <- "Density"
	plot <- pscontinuous(plot, "y", range=c(0,NA), expand=c(0.05,0))
	gg_add("density", plot, aesthetics, ..., data=data)
}
pre_density <- function(data, adjust=1, kernel="gaussian", ...) {
	if (is.null(data$weight)) data$weight <- rep(1/length(data$x), length(data$x))

	dens <- stats::density(data$x, adjust=adjust, kernel=kernel, weight=data$weight)
	densdf <- as.data.frame(dens[c("x","y")])
	aestheticvars <- intersect(c("colour","linetype","size"), names(data))
	densdf[,aestheticvars] <- data[1,aestheticvars]

	densdf
}
grob_density <- function(aesthetics, ...) {
	grob_line(aesthetics, ...)
}


#' Grob function: 2d density
#'
#' Perform a 2D kernel density estimatation using \code{\link{kde2d}} and
#' display the results with contours.
#'
#' This is another function useful for dealing with overplotting.
#'
#' Aesthetic mappings that this grob function understands:
#'
#' \itemize{
#'   \item \code{x}:x position (required)
#'   \item \code{y}:y position (required)
#' }
#'
#' These can be specified in the plot defaults (see \code{\link{ggplot}}) or
#' in the \code{aesthetics} argument.  If you want to modify the position
#' of the points or any axis options, you will need to add a position scale to
#' the plot.  These functions start with \code{ps}, eg.
#' \code{\link{pscontinuous}} or \code{\link{pscategorical}}
#'
#' Other options:
#'
#' \itemize{
#'   \item passed to \code{\link{ggcontour}}, see it for details
#' }
#'
#' @seealso \code{\link{ggcontour}} for another way of dealing with over plotting
#' @inheritParams ggpoint
#' @export
#' @examples
#' library(ggplot2movies)
#' m <- ggpoint(ggplot(movies, aesthetics=list(y=length, x=rating)))
#' dens <- MASS::kde2d(movies$rating, movies$length)
#' densdf <- data.frame(expand.grid(rating = dens$x, length = dens$y), z=as.vector(dens$z))
#' ggcontour(m, list(z=z), data=densdf)
#' gg2density(m)
#' # they don't look the same due to scaling effects on kde2d
gg2density <- function(plot, aesthetics=list(), ..., data=NULL) {
	gg_add("2density", plot, aesthetics, ..., data=data)
}

grob_2density <- function(aesthetics, ...) {
	df <- data.frame(aesthetics[, c("x", "y")])
	df <- df[stats::complete.cases(df), ]
	dens <- do.call(MASS::kde2d, df)
	densdf <- data.frame(expand.grid(x = dens$x, y = dens$y), z=as.vector(dens$z))
	grob_contour(densdf, ...)
}


#' Grob function: groups
#'
#' This grob function provides a general means of creating
#' multiple grobs based on groups in the data.  This is useful
#' if you want to fit a separate smoother for each group in the data.
#'
#' You will need an id variable in your aesthetics list with determines
#' how the data is broken down.
#'
#' Aesthetic mappings that this grob function understands:
#'
#' \itemize{
#'   \item \code{x}:x position (required)
#'   \item \code{y}:y position (required)
#'   \item \code{id}:
#'   \item any other grobs used by the grob function you choose
#' }
#'
#' These can be specified in the plot defaults (see \code{\link{ggplot}}) or
#' in the \code{aesthetics} argument.  If you want to modify the position
#' of the points or any axis options, you will need to add a position scale to
#' the plot.  These functions start with \code{ps}, eg.
#' \code{\link{pscontinuous}} or \code{\link{pscategorical}}
#'
#' Other options:
#'
#' \itemize{
#'   \item \code{grob}:grob function to use for subgroups
#'   \item anything else used by the grob function you choose
#' }
#'
#' @inheritParams ggpoint
#' @export
#' @examples
#' p <- ggplot(mtcars, aesthetics=list(y=wt, x=qsec, id=cyl, colour=cyl))
#' gggroup(p)
#' gggroup(p, grob="density")
#' gggroup(p, grob="histogram", aes=list(fill=cyl))
#' gggroup(ggpoint(p), grob="smooth", se=FALSE, span=1)
#' gggroup(ggpoint(p), aes=list(id=cyl, size=cyl), grob="smooth", span=1)
gggroup <- function(plot, aesthetics=list(), ..., data=NULL) {
	gg_add("group", plot, aesthetics, ..., data=data)
}
pre_group <- function(data, grob="point", ...) {
	if(length(data$id) != length(data$x)) stop("You need to set an id variable to use grob_group")

	pre <- paste("pre", grob, sep="_")
	if (exists(pre)) {
		pref <- get(pre)
		do.call(rbind, by(data, data$id, function(data) cbind(pref(data, ...), id=data$id[1])))
	} else {
		data
	}

}

grob_group <- function(aesthetics, grob = "point", separate=TRUE, ...) {
	grobf <- get(paste("grob", grob, sep="_"))
	if (separate) {
		parts <- by(aesthetics, aesthetics$id, function(data) grobf(data, ...))
		gTree(children = do.call(gList, parts)) # , name="group"
	} else {
		grobf(aesthetics, ...)
	}
}
