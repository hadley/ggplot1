# Quick plot.
# Quick plot is a convenient wrapper function for creating simple ggplot plot objects.
# You can use it like you'd use the \code{\link{plot}} function.
# 
# FIXME: describe how to get more information
# FIXME: add more examples
# 
# \code{qplot} provides a quick way to create simple plots.
# 
# @arguments x values
# @arguments y values
# @arguments data frame to use (optional)
# @arguments facetting formula to use
# @arguments grob type(s) to draw (can be a vector of multiple names)
# @arguments vector to use for colours
# @arguments vector to use for sizes
# @arguments vector to use for shapes
# @arguments vector to use for line type
# @arguments vector to use for fill colour
# @arguments vector to use for ids
# @arguments vector to use for weights
# @arguments limits for x axis (defaults to range of data)
# @arguments limits for y axis (defaults to range of data)
# @arguments which variables to log transform ("x", "y", or "xy")
# @arguments character vector or expression for plot title
# @arguments character vector or expression for x axis label
# @arguments character vector or expression for y axis label
# @arguments if specified, build on top of this ggplot, rather than creating a new one
# @arguments other arguments passed on to the grob functions
# @keyword hplot 
#X qplot(LETTERS[1:5], 1:5, type="rect", main="Blah", xlab="Hi")
#X qplot(LETTERS[1:5], 1:5, type=c("tile", "point"), main="Blah", xlab="Hi", ylim=c(0,10), col=1:5)
#X qplot(wt, mpg, data=mtcars, col=cyl, shape=cyl, size=wt)
qplot <- function(x, y = NULL, data, facets = . ~ ., margins=FALSE, types = "point", colour = NULL, size = NULL, shape = NULL, linetype = NULL, fill = NULL, id=NULL, weight=NULL, xlim = c(NA, NA), ylim = c(NA, NA), log = "", main = NULL, xlab = deparse(substitute(x)), ylab = deparse(substitute(y)), add=NULL, ...) {
	if (!missing(data)) {
		df <- df2 <- data
	} else {
		if (!is.null(add)) {
			df <- df2 <- add$data
		} else {
			df <- df2 <- do.call(data.frame, compact(list(x=x, y=y, colour=colour, shape=shape, size=size, linetype=linetype, fill=fill, id=id, weight=weight)))
		}
	}
	
	if (missing(data)) {
		facetvars <- all.vars(facets)
		facetvars <- facetvars[facetvars != "."]
		facetsdf <- as.data.frame(sapply(facetvars, get))
		if (nrow(facetsdf)) df <- cbind(df, facetsdf)
	}


	defaults <- if (!missing(data) || !is.null(add)) {
		uneval(substitute(list(x=x, y=y, colour=colour, shape=shape, size=size, linetype=linetype, fill=fill, id=id, weight=weight)))
	} else {
		uneval(substitute(list(x=x, y=y, colour=colour, shape=shape, size=size, linetype=linetype, fill=fill, id=id, weight=weight)))[names(df2)]
	}


	
	if (is.null(add)) {
		p <- ggplot(df, formula=deparse(substitute(facets)), margins=margins)	
		p$defaults <- defaults
	} else {
		p <- add
	}
	
	if (!is.null(main)) p$title <- main
	if (!is.null(xlab)) p$xlabel <- xlab
	if (!is.null(ylab)) p$ylabel <- ylab

	for(type in types) {
		ggtype <- get(paste("gg", type, sep=""))
		if (is.null(add)) {
			p <- ggtype(p, ...)
		} else {
			p <- ggtype(p, data=df, ...)
			p$grobs[[length(p$grobs)]]$aesthetics <- defaults
		}
	}
	
	logv <- function(var) var %in% strsplit(log, "")[[1]]
	transf <- function(var) if (logv(var)) trans_log10 else trans_none
	

	if (logv("x") || !missing(xlim)) p <- pscontinuous(p, "x", range=xlim, trans=transf("x"))
	if (logv("y") || !missing(ylim)) p <- pscontinuous(p, "y", range=ylim, trans=transf("y"))
	
	p
}