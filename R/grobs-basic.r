
# gg add
# Convenience method to make writing gg\_XXXX functions easier.
# 
# Will automatically add scales if needed.
# 
# @arguments type of grob mapping to add
# @arguments plot object
# @arguments list of aesthetic mappings
# @arguments parameters passed to grob function
# @arguments data frame
# @keyword hplot  
# @keyword internal 
# @value modified plot object 
gg_add <- function(map, plot, aesthetics=list(), ..., data=NULL) {
	aesthetics <- substitute(aesthetics, parent.frame())
	
	plot <- add_defaults(plot, uneval(aesthetics))
	do.call(plot_add, list(plot=plot, data=data, map=map, aesthetics=aesthetics, ...))
}

# Aesthetic defaults
# Convenience method for setting aesthetic defaults
# 
# @arguments values from aesthetic mappings
# @arguments defaults
# @arguments user specified values
# @keyword internal 
aesdefaults <- function(x, y, ...) {
	defaults(x, updatelist(y, list(...)))
}

# Grob function: point
# Add points to a plot
# 
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item \code{x}:x position (required)
#   \item \code{y}:y position (required)
#   \item \code{size}:size of the point, in mm (see \code{\link{scsize})}
#   \item \code{shape}:shape of the glyph used to draw the point (see \code{\link{scshape})}
#   \item \code{colour}:point colour (see \code{\link{sccolour})}
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
#   \item \code{unique}:if \code{TRUE, draw at most one point at each unique location}
# }
# 
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot
#X p <- ggplot(mtcars, aesthetics=list(x=wt, y=mpg))
#X ggpoint(p)
#X ggpoint(p, list(colour=cyl))
#X ggpoint(p, list(blahbalh=cyl)) #unknown aesthetics are ignored
#X ggpoint(p, list(shape=cyl))
#X ggpoint(p, list(shape=cyl, colour=cyl))
#X ggpoint(p, list(size=mpg))
#X ggpoint(p, list(size=mpg/wt))
#X ggpoint(p, list(x=cyl, colour=cyl))
#X p <- ggplot(mtcars)
#X ggpoint(p, aesthetics=list(x=wt, y=mpg))
ggpoint <- function(plot = .PLOT, aesthetics=list(), ..., data=NULL) {
	gg_add("point", plot, aesthetics, ..., data=data)
}
grob_point <- function(aesthetics, unique=TRUE, ...) {
  if (length(aesthetics$x) + length(aesthetics$y) == 0) return();
	aesthetics <- aesdefaults(aesthetics, list(colour="black", size=2, shape=16, rotation=0), ...)
  
	if (unique) { 
		aesthetics <- unique(data.frame(aesthetics))
		aesthetics <- lapply(aesthetics, function(x) if (is.factor(x)) as.character(x) else x)
	}
	
	pointsGrob(
		aesthetics$x, aesthetics$y, size=unit(aesthetics$size, "mm"), pch=aesthetics$shape, gp = gpar(col=as.character(aesthetics$colour), rot=aesthetics$rotation, cex=aesthetics$size)
	)
}

# Grob function: abline 
# Add line specified by slope and intercept to a plot
# 
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item none
# }
#
# Other options:
# 
# \itemize{
#   \item \code{intercept}:intercept(s) of line
#   \item \code{slope}:slope(s) of line, set to Inf
#   \item \code{colour}:line colour
#   \item \code{size}:line thickness
#   \item \code{linetype}:line type
# 	\item \code{range}: x (or y if slope infinite) range to draw the line.  This is sometimes necessary because ggplot isn't smart enough to calculate the entire range of the data
# }
# 
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot
#X p <- ggplot(mtcars, aesthetics=list(x = wt, y=mpg))
#X ggabline(ggpoint(p), intercept=30, slope=-5)
#X ggabline(ggpoint(p), intercept=c(30,40,50), slope=-5)
#X ggsmooth(ggpoint(p), method=lm, formula=y~x) 
ggabline <- function(plot = .PLOT, aesthetics=list(), ..., data=NULL) {
	gg_add("abline", plot, aesthetics, ..., data=data)
}
grob_abline <- function(aesthetics, intercept=0, slope=1, range=c(NA, NA), ...) {
	xrange <- range(range(aesthetics$x, na.rm=TRUE), range, na.rm=TRUE)

	build_line <- function(intercept, slope) {
		y <- function(x) x * slope + intercept
		list(x=xrange, y=y(xrange))
	}
	
	aesthetics <- mapply(build_line, intercept, slope, SIMPLIFY=FALSE)
	gTree(children = do.call(gList,
		lapply(aesthetics, grob_line, ...)
	)) # , name="abline"
}


# Grob function: vline
# Add vertical line(s) to a plot
# 
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item none
# }
#
# Other options:
# 
# \itemize{
#   \item \code{position}: vertical position(s) to draw lines
#   \item \code{colour}: line colour
#   \item \code{size}: line thickness
#   \item \code{linetype}: line type
# 	\item \code{range}: x (or y if slope infinite) range to draw the line.  This is sometimes necessary because ggplot isn't smart enough to calculate the entire range of the data
# }
# 
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot
#X p <- ggplot(mtcars, aesthetics=list(x = wt, y=mpg))
#X ggvline(ggpoint(p), position=mean(mtcars$wt), size=2)
ggvline <- function(plot = .PLOT, aesthetics=list(), ..., data=NULL) {
	gg_add("vline", plot, aesthetics, ..., data=data)
}
grob_vline <- function(aesthetics, position=0, range=c(NA, NA), ...) {
	yrange <- range(range(aesthetics$y, na.rm=TRUE), range, na.rm=TRUE)

	build_line <- function(position) {
		list(x=c(position, position), y=yrange)
	}
	
	aesthetics <- mapply(build_line, position, SIMPLIFY=FALSE)
	gTree(children = do.call(gList,
		lapply(aesthetics, grob_line, ...)
	)) # , name="vline"
}

# Grob function: hline
# Add horizontal line(s) to a plot
# 
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item none
# }
#
# Other options:
# 
# \itemize{
#   \item \code{position}: vertical position(s) to draw lines
#   \item \code{colour}: line colour
#   \item \code{size}: line thickness
#   \item \code{linetype}: line type
# 	\item \code{range}: x (or y if slope infinite) range to draw the line.  This is sometimes necessary because ggplot isn't smart enough to calculate the entire range of the data
# }
# 
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot
#X p <- ggplot(mtcars, aesthetics=list(x = wt, y=mpg))
#X gghline(ggpoint(p), position=mean(mtcars$mpg), size=2)
gghline <- function(plot = .PLOT, aesthetics=list(), ..., data=NULL) {
	gg_add("hline", plot, aesthetics, ..., data=data)
}
grob_hline <- function(aesthetics, position=0, range=c(NA, NA), ...) {
	xrange <- range(range(aesthetics$x, na.rm=TRUE), range, na.rm=TRUE)

	build_line <- function(position) {
		list(y=c(position, position), x=xrange)
	}
	
	aesthetics <- mapply(build_line, position, SIMPLIFY=FALSE)
	gTree(children = do.call(gList,
		lapply(aesthetics, grob_line, ...)
	)) # , name="hline"
}

# Grob function: jittered points
# Add jittered points to a plot
# 
# This is useful when plotting points with a categorical axis so to
# avoid overplotting.
# 
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item \code{x}:x position (required)
#   \item \code{y}:y position (required)
#   \item \code{size}:size of the point, in mm (see \code{\link{scsize})}
#   \item \code{shape}:shape of the glyph used to draw the point (see \code{\link{scshape})}
#   \item \code{colour}:point colour (see \code{\link{sccolour})}
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
#   \item \code{xjitter}:degree of jitter in x direction, see \code{\link{jitter} for details, defaults to 1 if the x variable is a factor, 0 otherwise}
#   \item \code{yjitter}:degree of jitter in y direction, see \code{\link{jitter} for details, defaults to 1 if the y variable is a factor, 0 otherwise}
# }
# 
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot
#X p <- ggplot(movies, aes=list(x=mpaa, y=rating))
#X ggjitter(p)
#X ggjitter(ggboxplot(p))
#X ggjitter(ggboxplot(p), xjitter=2)
#X ggjitter(ggboxplot(p), yjitter=1)
#X p <- ggplot(movies, aes=list(x=mpaa, y=factor(Action)))
#X ggjitter(p)
ggjitter <- function(plot = .PLOT, aesthetics=list(), ..., data=NULL) {
	gg_add("jitter", plot, aesthetics, ..., data=data)
}
grob_jitter <- function(aesthetics, xjitter, yjitter, ...) {
	if (missing(xjitter)) xjitter <- (resolution(aesthetics$x) == 1) * 1
	if (missing(yjitter)) yjitter <- (resolution(aesthetics$y) == 1) * 1

	aesthetics <- aesdefaults(aesthetics, list(), ...)
	aesthetics$x <- jitter(aesthetics$x, xjitter)
	aesthetics$y <- jitter(aesthetics$y, yjitter)

	grob_point(aesthetics)
}

# Grob function: text
# Add text to a plot
# 
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item \code{x}:x position (required)
#   \item \code{y}:y position (required)
#   \item \code{label}:text label to display
#   \item \code{size}:size of the text, as a multiple of the default size, (see \code{\link{scsize})}
#   \item \code{rotation}:angle, in degrees, of text label
#   \item \code{colour}:text colour (see \code{\link{sccolour})}
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
#   \item \code{justification}:justification of the text relative to its (x, y) location, see \code{\link{textGrob} for more details}
# }
# 
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot
#X p <- ggplot(mtcars, aesthetics=list(x=wt, y=mpg, labels = rownames(mtcars)))
#X ggtext(p)
#X ggtext(p, list(size=wt))
#X scsize(ggtext(p, list(size=wt)), c(0.5, 1.5))
#X ggtext(p, list(colour=cyl))
ggtext <- function(plot = .PLOT, aesthetics=list(), ..., data=NULL) {
	gg_add("text", plot, aesthetics, ..., data=data)
}
grob_text  <- function(aesthetics, justification="centre", ...) {
	aesthetics <- aesdefaults(aesthetics, list(colour="black", size=1, rotation=0), ...)
	textGrob(aesthetics$label, aesthetics$x, aesthetics$y, default.units="native", just=justification, rot=aesthetics$rotation, gp=gpar(col=as.character(aesthetics$colour), cex=aesthetics$size)) # , name="text"
}


# Grob function: path
# Add a path (a line between points in the order that they appear in the dataset) to the plot
# 
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item \code{x}:x position (required)
#   \item \code{y}:y position (required)
#   \item \code{id}:identifier variable used to break up into multiple paths
#   \item \code{size}:size of the line, in mm (see \code{\link{scsize}})
#   \item \code{colour}:line colour (see \code{\link{sccolour}})
#   \item \code{linetype}:line style/type (see \code{\link{sclinetype}})
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
#   \item none
# }
# 
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot
#X myear <- do.call(rbind, by(movies, movies$year, function(df) data.frame(year=df$year[1], mean.length = mean(df$length), mean.rating=mean(df$rating))))
#X p <- ggplot(myear, aesthetics=list(x=mean.length, y=mean.rating))
#X ggpath(p)
#X ggpath(p, list(size=year))
#X ggpath(p, list(colour=year))
#X ggpath(scsize(p, c(0.5,1)), list(size=year))
#X ggpath(scsize(p, c(0.5,1)), list(size=year))
#X p <- ggplot(mtcars, aesthetics=list(x=drat, y=wt))
#X ggpath(p)
#X ggpath(p, list(id=cyl))
#x ggpath(p, list(id=cyl, linetype=cyl))
ggpath <- function(plot = .PLOT, aesthetics=list(), ..., data=NULL) {
	gg_add("path", plot, aesthetics, ..., data=data)
}
grob_path  <- function(aesthetics, ...) {
  if (length(aesthetics$x) + length(aesthetics$y) == 0) return();
	aesthetics <- aesdefaults(aesthetics, list(id=1, colour="black", size=1.5, linetype=1), ...)

	longest <- max(sapply(aesthetics, length))
	aesthetics <- lapply(aesthetics, rep, length=longest)
	data <- data.frame(aesthetics)
	data <- lapply(data, function(x) if (is.factor(x)) as.character(x) else x)

	path <- function(data) {
		n <- nrow(data)
		if (n<2) return(NULL)
		segmentsGrob(as.numeric(data$x[-n]), as.numeric(data$y[-n]),as.numeric(data$x[-1]),as.numeric(data$y[-1]), default.units="native", gp=gpar(col=as.character(data$colour), lwd=data$size, lty=data$linetype)) #, name="path"
	}
	segs <- by(data, data$id, path)
	
	gTree(children = do.call(gList, segs)) # , name="paths"
}

# Grob function: polygon
# Add polygons to a plot
# 
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item \code{x}:x position (required)
#   \item \code{y}:y position (required)
#   \item \code{id}:identifier variable used to break up into multiple polygons
#   \item \code{size}:size of the outline, in mm (see \code{\link{scsize})}
#   \item \code{colour}:outline colour (see \code{\link{sccolour})}
#   \item \code{fill}:internal colour (see \code{\link{sccolour})}
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
#   \item none
# }
# 
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot 
ggpolygon <- function(plot = .PLOT, aesthetics=list(), ..., data=NULL) {
	gg_add("polygon", plot, aesthetics, ..., data=data)
}
grob_polygon  <- function(aesthetics, ...) {
	aesthetics <- aesdefaults(aesthetics, list(id=1, colour="black", size=1, pattern=1), ...)
	
	polygonGrob(aesthetics$x, aesthetics$y, default.units="native", gp=gpar(col=as.character(aesthetics$colour), fill=as.character(aesthetics$fill), lwd=aesthetics$lwd, pattern=aesthetics$pattern)) # , name="polygon"
}

# Grob function: line
# Add a line to the plot
# 
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item \code{x}:x position (required)
#   \item \code{y}:y position (required)
#   \item \code{id}:identifier variable used to break up into multiple paths
#   \item \code{size}:size of the line, in mm (see \code{\link{scsize}})
#   \item \code{colour}:line colour (see \code{\link{sccolour}})
#   \item \code{linetype}:line style/type (see \code{\link{sclinetype}})
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
#   \item none
# }
# 
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot
#X mry <- do.call(rbind, by(movies, round(movies$rating), function(df) { 
#X 	nums <- tapply(df$length, df$year, length)
#X 	data.frame(rating=round(df$rating[1]), year = as.numeric(names(nums)), number=as.vector(nums))
#X }))
#X p <- ggplot(mry, aesthetics = list(x=year, y=number, id=rating))
#X ggline(p)
#X ggpath(p, list(size=rating))
#X ggpath(p, list(colour=rating))
ggline <- function(plot = .PLOT, aesthetics=list(), ..., data=NULL) {
	gg_add("line", plot, aesthetics, ..., data=data)
}
grob_line  <- function(aesthetics, ...) {
  aesthetics <- aesdefaults(aesthetics, list(id=1,  colour="black", size=1, linetype=1), ...)

  if (length(aesthetics$x) == 1 ) {
    return(linesGrob(x = unit(c(0, 1), "npc"), y=unit(c(0.5, 0.5), "npc"), gp=gpar(col=as.character(aesthetics$colour), lwd=aesthetics$size, lty=aesthetics$linetype))) # , name="line"
  }

	aesthetics <- data.frame(aesthetics)
  aesthetics <- aesthetics[order(aesthetics$id, aesthetics$x), ]
	grob_path(aesthetics)
}

# Grob function: ribbon
# Add a ribbon to the plot
# 
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item \code{x}:x position (required)
#   \item \code{upper}: position of upper edge of ribbon  (required)
#   \item \code{lower}: position of lower edge of ribbon (required)
#   \item \code{id}:identifier variable used to break up into multiple paths
#   \item \code{colour}:line colour (see \code{\link{sccolour}})
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
#   \item none
# }
# 
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot
#X mry <- do.call(rbind, by(movies, round(movies$rating), function(df) { 
#X 	nums <- tapply(df$length, df$year, length)
#X 	data.frame(rating=round(df$rating[1]), year = as.numeric(names(nums)), number=as.vector(nums))
#X }))
#X p <- ggplot(mry, aesthetics = list(x=year, y=number, id=rating))
#X ggribbon(p, aes=list(upper=number+5, lower=number-5), fill="white", colour=NA)
#X ggribbon(p, aes=list(y=number, plus=5, minus=-5), fill="white", colour=NA)
#X ggribbon(p, aes=list(upper=number*1.1, lower=number*0.9), fill="white", colour=NA)
#X ggribbon(p, aes=list(upper=number+5, lower=number-5), fill="pink")
#X ggribbon(p, aes=list(upper=number+5, lower=number-5, fill=rating), colour=NA)
#X scfillgradient(ggribbon(p, aes=list(upper=number+5, lower=number-5, fill=rating), colour=NA), midpoint=5, low="red", high="darkgreen")
ggribbon <- function(plot = .PLOT, aesthetics=list(), ..., data=NULL) {
	gg_add("ribbon", plot, aesthetics, ..., data=data)
}
pre_ribbon <- function(data, ...) {
	if (!all(c("upper","lower") %in% names(data))) {
		if (is.null(data$plus) && !is.null(data$minus)) data$plus <- -data$minus
		if (!is.null(data$plus) && is.null(data$minus)) data$minus <- -data$plus
		
		upper <- data$y + data$plus
		lower <- data$y + data$minus
	} else {
		upper <- data$upper
		lower <- data$lower
	}

	data <- data.frame(upper=upper, lower=lower, data)
	data$y <- (data$upper + data$lower)/2
  data <- data[order(data$id), ]
	data <- lapply(data, function(x) if (is.factor(x)) as.character(x) else x)

	as.data.frame(data)
}
grob_ribbon <- function(aesthetics, ...) {
	aesthetics <- aesdefaults(aesthetics, list(colour=NA, fill="grey60", id=1), ...)
	aesthetics <- as.data.frame(aesthetics)
	grob_group(aesthetics, grob="polygon", ...)
}

# Grob function: area
# Add an filled area to a plot.
#
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item \code{x}:x position (required)
#   \item \code{y}:y position (required)
#   \item \code{id}:identifier variable used to break up into multiple paths
#   \item \code{colour}:line colour (see \code{\link{sccolour}})
#   \item \code{fill}:fill colour (see \code{\link{sccolour}})
#   \item \code{linetype}:line style/type (see \code{\link{sclinetype}})
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
#   \item none
# }
# 
# @arguments x positions
# @arguments y positions
# @arguments id variable used to separate observations into different areas
# @arguments colour
# @arguments pattern
# @arguments ...
# @keyword hplot
# @keyword internal 
#X huron <- data.frame(year = 1875:1972, level = as.vector(LakeHuron))
#X p <- ggplot(huron, aes=list(y=level, x=year))
#X ggarea(p)
#X ggarea(p, colour="black")
#X ggline(ggarea(p)) # better
#X qplot(year, level, data=huron, type=c("area", "line"))
#X ggarea(p, fill=alpha("grey80", 0.5))
#X pscontinuous(ggarea(p), "y", range=c(0,NA))
ggarea <- function(plot = .PLOT, aesthetics=list(), ..., data=NULL) {
	gg_add("area", plot, aesthetics, ..., data=data)
}
grob_area  <- function(aesthetics, ...) {
	aesthetics <- aesdefaults(aesthetics, list(id=1, fill="grey80", colour=NA, linetype=1), ...)

	data <- as.data.frame(aesthetics)
	data <- data[order(data$id, data$x), ]
	data <- lapply(data, function(x) if (is.factor(x)) as.character(x) else x)

	poly <- function(data) {
		n <- nrow(data)
		with(data, 
			polygonGrob(c(min(x), x, max(x)), c(0, y, 0), default.units="native", gp=gpar(fill=as.character(fill), col=as.character(colour), lty=linetype))
		)
	}
	segs <- by(data, data$id, poly)
	
	gTree(children=do.call(gList, segs)) # , name="area"
}

# Grob function: rectangle
# Add rectangles to a plot
# 
# This grob provides the basic functionality required by
# \code{\link{ggbar}} and \code{\link{ggtile}}.  You should probably
# not call it yourself
# 
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item \code{x}:x position (required)
#   \item \code{y}:y position (required)
#   \item \code{width}:width of the rectangle (required)
#   \item \code{height}:height of the rectangle (required)
#   \item \code{fill}:fill colour (see \code{\link{sccolour})}
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
#   \item \code{justification}:justification of the bar relative to its (x, y) location, see \code{\link{rectGrob} for more details}
# }
# 
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot
# @seealso \code{\link{ggbar}}, \code{\link{ggtile}}
ggrect <- function(plot = .PLOT, aesthetics=list(), ..., data=NULL) {
	gg_add("rect", plot, aesthetics, ..., data=data)
}
grob_rect   <- function(aesthetics, justification = c("centre","top"), ...) {
	aesthetics <- aesdefaults(aesthetics, list(fill="grey50", height=aesthetics$y, width=resolution(aesthetics$x)*0.9, colour="NA"), ...)
	
	rectGrob(aesthetics$x, aesthetics$y, width=aesthetics$width, height=aesthetics$height, default.units="native", just=justification, gp=gpar(col=as.character(aesthetics$colour), fill=as.character(aesthetics$fill))) #, name="rect"
}


# Grob function: bars
# Add bars to a plot
# 
# The bar grob produces bars from the y-position to the y=0.
# 
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item \code{x}:x position (required)
#   \item \code{y}:y position (required)
#   \item \code{fill}:fill colour (see \code{\link{sccolour})}
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
#   \item \code{avoid}: how should overplotting be dealt with? 
#      "none" (default) = do nothing, "stack" = stack bars on top of one another,
#      "dodge" = dodge bars from side to side
#		\item \code{sort}: Should the values of the bars be sorted
#  }
# 
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot
# @seealso \code{\link{ggrect}}
#X cyltab <- as.data.frame(table(cyl=mtcars$cyl))
#X p <- ggplot(cyltab, aes=list(y=Freq, x=cyl))
#X ggbar(p)
#X ggbar(p, fill="white", colour="red")
#X #Can also make a stacked bar chart
#X p <- ggplot(mtcars, aes=list(y=1, x=factor(cyl)))
#X ggbar(p, avoid="stack")
#X ggbar(p, avoid="stack", colour="red") # Made up of multiple small bars
#X p <- ggplot(mtcars, aes=list(y=mpg, x=factor(cyl)))
#X ggbar(p, avoid="stack")
#X ggbar(p, avoid="dodge", sort=TRUE)
#X ggbar(p, aes=list(fill=mpg), avoid="dodge", sort=TRUE)
#X ggbar(p, avoid="stack", sort=TRUE)
ggbar <- function(plot = .PLOT, aesthetics=list(), ..., data=NULL) {
	plot <- pscontinuous(plot, "y", range=c(NA,NA), expand=c(0.05,0))
	gg_add("bar", plot, aesthetics, ..., data=data)
}

pre_bar <- function(data, avoid="none", sort=FALSE, direction="vertical", width=resolution(data$x) * 0.9, ...) {
	if (direction != "vertical") data[c("x","y")] <- data[c("y","x")]

	data$width <- width
	if (avoid == "none") return(data)
	
	if (sort) {
		data <- data[order(data$x, data$y), ]
	} else {
		data <- data[order(data$x), ]
	}
	
	if (avoid == 'stack') {
		data$y <- unlist(tapply(data$y, data$x, cumsum))
		data <- data[order(data$y, decreasing=TRUE), ]
	} else if (avoid == 'dodge') {
		data$width <- data$width / max(tapply(data$y, data$x, length), na.rm=TRUE)
	}
	if (direction != "vertical") data[c("x","y")] <- data[c("y","x")]
	data
}

grob_bar   <- function(aesthetics, avoid="none", direction="vertical", justification=c("centre","top"), ...) {
	aesthetics <- aesdefaults(aesthetics, list(fill="grey50", colour="NA", height = aesthetics$y), ...)

	aesthetics <- position_adjust(aesthetics, avoid=avoid, direction=direction)

	rectGrob(aesthetics$x, aesthetics$y, width=aesthetics$width, height=aesthetics$height, default.units="native", just=justification, gp=gpar(col=as.character(aesthetics$colour), fill=as.character(aesthetics$fill))) #, name="bar"
}

# Position adjust
# This function extracts out some of the code necessary to perform
# position adjustments (eg. stack, dodge).  More needs to be done
# 
# @arguments list of aesthetics
# @arguments avoid method to use
# @arguments direction (currently only works with vertical)
# @arguments adjustment factor if multiple rows correspond to same grob (awful hack)
# @keyword internal 
position_adjust <- function(aesthetics, avoid, direction, adjust=1) {
	if (direction != "vertical") aesthetics[c("height", "width")] <- aesthetics[c("width", "height")]
	if (avoid == "dodge") {
		n <- max(tapply(aesthetics$y, aesthetics$x, length)) / adjust

		aesthetics$x <- as.numeric(aesthetics$x) + unlist(tapply(aesthetics$y, aesthetics$x, function(x) rep(1:n - n/2, adjust)[1:length(x)])) * aesthetics$width - aesthetics$width / 2 
	}
	aesthetics
}


# Grob function: tile
# Add tiles to a plot
# 
# The tile grob will tile the plot surface as densly as possible, assuming
# that every tile is the same size.  It is similar to \code{\link{levelplot}}
# or \code{\link{image}}.  
# 
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item \code{x}:x position (required)
#   \item \code{y}:y position (required)
#   \item \code{width}:width of the rectangle
#   \item \code{height}:height of the rectangle
#   \item \code{fill}:fill colour (see \code{\link{sccolour})}
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
#   \item none
# }
# 
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot
# @seealso \code{\link{ggrect}}, \code{\link{resolution}}
#X pp <- function (n,r=4) {
#X  x <- seq(-r*pi, r*pi, len=n)
#X  df <- expand.grid(x=x, y=x)
#X  df$r <- sqrt(df$x^2 + df$y^2)
#X  df$z <- cos(df$r^2)*exp(-df$r/6)
#X  df
#X }
#X p <- ggplot(pp(20), aes=list(x=x,y=y))
#X ggtile(p) #pretty useless!
#X ggtile(p, list(fill=z))
#X ggtile(p, list(height=abs(z), width=abs(z)))
#X ggtile(ggplot(pp(100), aes=list(x=x,y=y,fill=z)))
#X ggtile(ggplot(pp(100, r=2), aes=list(x=x,y=y,fill=z)))
#X p <- ggplot(pp(20)[sample(20*20, size=200),], aes=list(x=x,y=y,fill=z))
#X ggtile(p)
ggtile <- function(plot = .PLOT, aesthetics=list(), ..., data=NULL) {
	gg_add("tile", plot, aesthetics, ..., data=data)
}
grob_tile  <- function(aesthetics, ...) {
	if (length(aesthetics$x) == 1) {
	  colour <- if(is.null(aesthetics$colour)) aesthetics$fill else aesthetics$colour
		return(rectGrob(gp=gpar(col=NA, fill=as.character(colour))))
	}

	aesthetics <- aesdefaults(aesthetics, list(
	  width=resolution(aesthetics$x), 
	  height=resolution(aesthetics$y),
		colour = NA
	), ...)
	
	grob_rect(aesthetics, justification=c("centre","centre")) #, name="tile"
}

# Resolution
# Compute the "resolution" of a data vector, ie. what is the smallest non-zero
# distance between adjacent values.
#
# @arguments numeric vector
# @seealso \code{\link{ggtile}}
# @keyword hplot
# @keyword internal 
resolution <- function(x) {
	un <- unique(as.numeric(x))
	if (length(un) == 1) return(1)
	min(diff(sort(un)))
}