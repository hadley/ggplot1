# Grob function: histogram
# Draw a histogram
# 
# Aesthetic mappings that this grob function understands:
#
# Conceptually, the histogram is one of the most complicated
# of the grob functions, becuase it takes a 1D data set and makes
# it two dimensional.  This necessitates an extra step, the \code{pre_histogram}
# function which bins the data and returns the bins with their counts.  
# This data is then used my \code{grob_histogram} 
# to plot the points.
# 
# \itemize{
#   \item \code{x}:x position (required)
#   \item \code{weight}: observation weights
# }
# 
# These can be specified in the plot defaults (see \code{\link{ggplot}}) or
# in the \code{aesthetics} argument.  If you want to modify the position 
# of the points or any axis options, you will need to add a position scale to
# the plot.  These functions start with \code{ps}, eg. 
# \code{\link{pscontinuous}} or \code{\link{pscategorical}}
# 
# Other options:
# 
# \itemize{
#   \item \code{breaks}:breaks argument passed to \code{\link{hist}}
#   \item \code{scale}:scale argument passed to \code{\link{hist}}
# 	\item any other aesthetic setting passed on to \code{\link{ggrect}}
# }
# 
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot
#X m <- ggplot(movies, aesthetics=list(x=rating))
#X gghistogram(m)
#X gghistogram(m, breaks=100)
#X qplot(length, data=movies, type="histogram")
#X qplot(log(length), data=movies, type="histogram")
#X m <- ggplot(movies, Action ~ Comedy, aesthetics=list(x=rating), margins=TRUE)
#X gghistogram(m)
#X gghistogram(m, scale="freq")
#X gghistogram(m, colour="darkgreen", fill="white") 
#X qplot(rating, data=movies, type="histogram")
#X qplot(rating, weight=votes, data=movies, type="histogram")
#X qplot(rating, weight=votes, data=movies, type=c("histogram", "density"))
gghistogram <- function(plot = .PLOT, aesthetics=list(), scale="prob", ..., data=NULL) {
	plot <- pscontinuous(plot, "y", range=c(0,NA), expand=c(0.05,0))
	plot <- pscontinuous(plot, "x", expand=c(0.15, 0))
	
	plot$ylabel <- if (scale == "prob") "Density" else "Frequency"

	gg_add("histogram", plot, aesthetics, scale=scale, ..., data=data)
}
pre_histogram <- function(data, breaks=20, scale="prob", ...) {
	if (is.function(breaks)) breaks <- breaks(data$x)
	h <- hist(data$x, breaks=breaks, freq=FALSE, plot=FALSE, ...)
	
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

# Grob function: quantiles
# Add quantile lines from a quantile regression
# 
# This can be used a continuous analogue of a boxplot (see \code{\link{grob_boxplot}})
# Lines will be automatically sized to reflect their distance from the median.
#
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item \code{x}:x position (required)
#   \item \code{y}:y position (required)
#   \item \code{weight}: observation weights
# }
# 
# These can be specified in the plot defaults (see \code{\link{ggplot}}) or
# in the \code{aesthetics} argument.  If you want to modify the position 
# of the points or any axis options, you will need to add a position scale to
# the plot.  These functions start with \code{ps}, eg. 
# \code{\link{pscontinuous}} or \code{\link{pscategorical}}
# 
# Other options:
# 
# \itemize{
#   \item \code{quantiles}:quantiles to display
#   \item \code{formula}:formula to use in quantile regression
# }
# 
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot
# @seealso \code{\link[quantreg]{rq}} for the code used to fit the quantile regression
#X \dontrun{
#X m <- ggplot(movies, aesthetics=list(y=length, x=rating))
#X ggquantile(m)
#X }
ggquantile <- function(plot = .PLOT, aesthetics=list(), ..., data=NULL) {
	gg_add("quantile", plot, aesthetics, ..., data=data)
}
grob_quantile <- function(aesthetics, quantiles=c(0.05, 0.25, 0.5, 0.75, 0.95), formula=y ~ splines::ns(x, 5), ...) {
	aesthetics <- aesdefaults(aesthetics, list(weight=rep(1, length(aesthetics$y))), ...)
	if (!require(quantreg, quietly=TRUE)) stop("You need to install the quantreg package!")
	
	xseq <- seq(min(aesthetics$x, na.rm=TRUE), max(aesthetics$x, na.rm=TRUE), length=30)
	
	model <- rq(formula, data=aesthetics, tau=quantiles, weight=weight) #
	yhats <- predict(model, data.frame(x=xseq))
	qs <- data.frame(y = as.vector(yhats), x = xseq, id = rep(quantiles, each=length(xseq)))
	qs$size <- (0.5 - abs(0.5 - qs$id))*5 + 0.5
	
	grob_path(qs, ...)
}

# Grob function: boxplot
# Add box and whiskers
# 
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item \code{x}:x position (required)
#   \item \code{y}:y position (required)
#   \item \code{weight}: observation weights
# }
# 
# These can be specified in the plot defaults (see \code{\link{ggplot}}) or
# in the \code{aesthetics} argument.  If you want to modify the position 
# of the points or any axis options, you will need to add a position scale to
# the plot.  These functions start with \code{ps}, eg. 
# \code{\link{pscontinuous}} or \code{\link{pscategorical}}
# 
# Other options:
# 
# \itemize{
#   \item \code{breaks}:how to break up the x axis (only used if not already a factor)
#   \item \code{orientation}: whether boxplots should be horizontal or vertical.  
#     If missing will automatically decide based on which variable is a factor.
#   \item other arguments passed \code{\link{boxplot}}
# }
# 
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot
# @seealso \code{\link{ggquantile}} for a continuous analogue of the boxplot
#X p <- ggplot(mtcars, aesthetics=list(y=mpg, x=factor(cyl)))
#X p2 <- ggplot(mtcars, aesthetics=list(x=mpg, y=factor(cyl)))
#X ggpoint(p)
#X ggboxplot(p)
#X ggboxplot(p2)
#X ggboxplot(p, fill="pink", colour="green")
#X ggpoint(ggboxplot(p))
#X ggboxplot(p)
ggboxplot <- function(plot = .PLOT, aesthetics=list(), ..., data=NULL) {
	gg_add("boxplot", plot, aesthetics, ..., data=data)
}
grob_boxplot <- function(aesthetics, breaks=length(unique(aesthetics$x)), orientation, ...) {

	aesthetics <- aesdefaults(aesthetics, list(fill="white", colour="grey50", weight=rep(1, length(aesthetics$x))), ...)
	swap <- function(list) { 
	  if (orientation == "vertical") return(list)
	  rename(list, c(x="y", y="x", height="width", width="height"))
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
		median = tapply(aesthetics$x, breakpoints, median, na.rm=TRUE),
		width =  tapply(aesthetics$x, breakpoints, function(x) diff(range(x, na.rm=TRUE))) * 0.5 + 0.5,
		colour = tapply(rep(as.character(aesthetics$colour),length=n), breakpoints, function(x) x[1]),
		fill =   tapply(rep(as.character(aesthetics$fill),  length=n), breakpoints, function(x) x[1])
	)

	boxes <- boxplot.weighted.formula(aesthetics$y ~ breakpoints, weights=aesthetics$weight, plot=FALSE, ...)
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


# Grob function: smooth
# Add a smooth line to a plot
# 
# This grob adds a smoother to the graphic to aid the eye in
# seeing important patterns, especially when there is a lot of overplotting.
# 
# You can customise this very freely, firstly by choosing the function used
# to fit the smoother (eg. \code{\link{loess}}, \code{\link{lm}}, \code{\link{rlm}}, 
# \code{\link{gam}}, \code{\link{glm}}) and the formula used to related the y and x 
# values (eg. \code{y ~ x}, \code{y ~ poly(x,3)}).
# 
# This smoother is automatically restricted to the range of the data.  If you
# want to perform predictions (or fit more complicated variabels with covariates)
# then you should fit the model and plot the predicted results.
# 
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item \code{x}:x position (required)
#   \item \code{y}:y position (required)
#   \item \code{size}:size of the point, in mm (see \code{\link{scsize})}
#   \item \code{colour}:point colour (see \code{\link{sccolour})}
#   \item \code{weight}: observation weights
# }
# 
# These can be specified in the plot defaults (see \code{\link{ggplot}}) or
# in the \code{aesthetics} argument.  If you want to modify the position 
# of the points or any axis options, you will need to add a position scale to
# the plot.  These functions start with \code{ps}, eg. 
# \code{\link{pscontinuous}} or \code{\link{pscategorical}}
# 
# Other options:
# 
# \itemize{
#   \item \code{method}:smoothing method (function) to use
#   \item \code{formula}:formula to use in smoothing function
#   \item \code{se}:display one standard error on either side of fit? (true by default)
#   \item other arguments are passed to smoothing function
# }
# 
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot 
#X p <- ggpoint(ggplot(mtcars, aesthetics=list(y=wt, x=qsec)))
#X ggsmooth(p)
#X ggsmooth(p, span=0.9)
#X ggsmooth(p, method=lm)
#X ggsmooth(p, method=lm, formula = y~splines::ns(x,3))
#X ggsmooth(p, method=MASS::rlm, formula = y~splines::ns(x,3))
ggsmooth <- function(plot = .PLOT, aesthetics=list(), ..., data=NULL) {
	gg_add("smooth", plot, aesthetics, ..., data=data)
}
grob_smooth <- function(aesthetics, method=loess, formula=y~x, se = TRUE, ...) {
	aesthetics <- aesdefaults(aesthetics, list(colour="black", size=1, weight=rep(1, length(aesthetics$x))), ...)
	xseq <- seq(min(aesthetics$x, na.rm=TRUE), max(aesthetics$x, na.rm=TRUE), length=80)
	method <- match.fun(method)

	colour <- as.character(uniquedefault(aesthetics$colour, "black"))
	size <- uniquedefault(aesthetics$size, 1)

	model <- method(formula, data=aesthetics, ..., weight=weight)
	pred <- predict(model, data.frame(x=xseq), se=se)

	if (se) {
		gTree(children=gList(
			grob_path(list(y = as.vector(pred$fit), x = xseq, colour=colour, size=size)),
			grob_path(list(y = as.vector(pred$fit + 2 * pred$se), x = xseq, colour="grey80")),
			grob_path(list(y = as.vector(pred$fit - 2 * pred$se), x = xseq, colour="grey80")),
			grob_ribbon(list(y = c(pred$fit + 2 * pred$se, rev(pred$fit - 2 * pred$se)), x = c(xseq,rev(xseq))), colour=NA, fill=alpha("grey50", 0.2))
		)) # , name="smooth"
	} else {
		grob_path(list(y = as.vector(pred), x = xseq, colour=colour, size=size))
	}
}

# Grob function: contours
# Create a grob to display contours of a 3D data set.
# 
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item \code{x}:x position (required)
#   \item \code{y}:y position (required)
#   \item \code{z}:z position (required)
# }
# 
# These can be specified in the plot defaults (see \code{\link{ggplot}}) or
# in the \code{aesthetics} argument.  If you want to modify the position 
# of the points or any axis options, you will need to add a position scale to
# the plot.  These functions start with \code{ps}, eg. 
# \code{\link{pscontinuous}} or \code{\link{pscategorical}}
# 
# Other options:
# 
# \itemize{
#   \item \code{nlevels}: number of contours to draw
#   \item \code{levels}: contour positions
# 	\item \code{...}: other aesthetic parameters passed to \code{\link{grob_path}}
# }
# 
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot 
# @seealso \code{\link{gg2density}}
#X volcano3d <- data.frame(expand.grid(x = 1:nrow(volcano), y=1:ncol(volcano)), z=as.vector(volcano))
#X p <- ggplot(volcano3d, aesthetics=list(x=x,y=y,z=z))
#X ggcontour(p)
#X ggcontour(p, colour="red")
#X ggcontour(p, nlevels=3)
#X ggcontour(ggtile(p, list(fill=z)))
ggcontour <- function(plot = .PLOT, aesthetics=list(), ..., data=NULL) {
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
	
	clines <- contourLines(x = gridx$unique, y = gridy$unique, z = gridz, nlevels = nlevels, levels = levels)
		
	gTree(children = do.call(gList, lapply(clines, grob_path, ...))) # , name="contour"
}


# Grob function: 1d density
# Display a smooth density estimate.
# 
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item \code{x}:x position (required)
#   \item \code{weight}: observation weights
# }
# 
# These can be specified in the plot defaults (see \code{\link{ggplot}}) or
# in the \code{aesthetics} argument.  If you want to modify the position 
# of the points or any axis options, you will need to add a position scale to
# the plot.  These functions start with \code{ps}, eg. 
# \code{\link{pscontinuous}} or \code{\link{pscategorical}}
# 
# Other options:
# 
# \itemize{
#   \item \code{adjust}: see \code{\link{density}}
# 		for details
# 	\item \code{kernel}: kernel used for density estimation, see \code{\link{density}}
# 		for details
# 	\item other aesthetic properties passed on to \code{\link{ggline}}
#   \item \code{weight}: observation weights
# }
# 
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot
# @seealso \code{\link{gghistogram}}, \code{\link{density}}
#X m <- ggplot(movies, aesthetics=list(x=rating))
#X ggdensity(m)
#X qplot(length, data=movies, type="density")
#X qplot(length, data=movies, type="density", weight=rating)
#X qplot(length, data=movies, type="density", weight=rating/sum(rating))
#X qplot(length, data=movies, type="density", log="x")
#X qplot(log(length), data=movies, type="density")
#X m <- ggplot(movies, Action ~ Comedy, aesthetics=list(x=rating), margins=TRUE)
#X ggdensity(m)
#X ggdensity(m, scale="freq")
#X ggdensity(m, colour="darkgreen", size=5) 
ggdensity <- function(plot = .PLOT, aesthetics=list(), ..., data=NULL) {
	plot$ylabel <- "Density"
	plot <- pscontinuous(plot, "y", range=c(0,NA), expand=c(0.05,0))
	gg_add("density", plot, aesthetics, ..., data=data)
}  
pre_density <- function(data, adjust=1, kernel="gaussian", ...) {
	if (is.null(data$weight)) data$weight <- rep(1/length(data$x), length(data$x))

	dens <- density(data$x, adjust=adjust, kernel=kernel, weight=data$weight)
	densdf <- as.data.frame(dens[c("x","y")])
	aestheticvars <- intersect(c("colour","linetype","size"), names(data))
	densdf[,aestheticvars] <- data[1,aestheticvars]
	
	densdf
}
grob_density <- function(aesthetics, ...) {
	grob_line(aesthetics, ...)
}


# Grob function: 2d density
# Perform a 2D kernel density estimatation using \code{\link{kde2d}} and
# display the results with contours.
# 
# This is another function useful for dealing with overplotting.
#
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item \code{x}:x position (required)
#   \item \code{y}:y position (required)
# }
# 
# These can be specified in the plot defaults (see \code{\link{ggplot}}) or
# in the \code{aesthetics} argument.  If you want to modify the position 
# of the points or any axis options, you will need to add a position scale to
# the plot.  These functions start with \code{ps}, eg. 
# \code{\link{pscontinuous}} or \code{\link{pscategorical}}
# 
# Other options:
# 
# \itemize{
#   \item passed to \code{\link{ggcontour}}, see it for details
# }
# 
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot
# @seealso \code{\link{ggcontour}} for another way of dealing with over plotting
#X m <- ggpoint(ggplot(movies, aesthetics=list(y=length, x=rating)))
#X dens <- MASS::kde2d(movies$rating, movies$length)
#X densdf <- data.frame(expand.grid(rating = dens$x, length = dens$y), z=as.vector(dens$z))
#X ggcontour(m, list(z=z), data=densdf)
#X gg2density(m)
#X # they don't look the same due to scaling effects on kde2d
gg2density <- function(plot = .PLOT, aesthetics=list(), ..., data=NULL) {
	gg_add("2density", plot, aesthetics, ..., data=data)
}

grob_2density <- function(aesthetics, ...) {
	df <- data.frame(aesthetics[, c("x", "y")])
	df <- df[complete.cases(df), ]
	dens <- do.call(MASS::kde2d, df)
	densdf <- data.frame(expand.grid(x = dens$x, y = dens$y), z=as.vector(dens$z))
	grob_contour(densdf, ...)
}


# Grob function: groups
# Create multiple of grobs based on id aesthetic.
# 
# This grob function provides a general means of creating 
# multiple grobs based on groups in the data.  This is useful
# if you want to fit a separate smoother for each group in the data.
# 
# You will need an id variable in your aesthetics list with determines
# how the data is broken down.
#
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item \code{x}:x position (required)
#   \item \code{y}:y position (required)
#   \item \code{id}:
#   \item any other grobs used by the grob function you choose
# }
# 
# These can be specified in the plot defaults (see \code{\link{ggplot}}) or
# in the \code{aesthetics} argument.  If you want to modify the position 
# of the points or any axis options, you will need to add a position scale to
# the plot.  These functions start with \code{ps}, eg. 
# \code{\link{pscontinuous}} or \code{\link{pscategorical}}
# 
# Other options:
# 
# \itemize{
#   \item \code{grob}:grob function to use for subgroups
#   \item anything else used by the grob function you choose
# } 
# 
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot
#X p <- ggplot(mtcars, aesthetics=list(y=wt, x=qsec, id=cyl, colour=cyl))
#X gggroup(p)
#X gggroup(p, grob="density")
#X gggroup(p, grob="histogram", aes=list(fill=cyl))
#X gggroup(ggpoint(p), grob="smooth", se=FALSE, span=1)
#X gggroup(ggpoint(p), aes=list(id=cyl, size=cyl), grob="smooth", span=1)
gggroup <- function(plot = .PLOT, aesthetics=list(), ..., data=NULL) {
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
