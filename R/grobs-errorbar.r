# Grob function: error bars
# Add error bars to a plot
#
# The error bar grob adds error bars to a plot.  Thanks to Timm
# Danker for supplying some initial code and the motivation to include
# it in ggplot.
#
# Aesthetic mappings that this grob function understands:
#
# \itemize{
#   \item \code{x}:x position (required)
#   \item \code{y}:y position (required)
#   \item \code{plus}:length of error bar in positive direction (required)
#   \item \code{minus}:length of error bar in negative direction (defaults to -plus)
#   \item \code{colour}:line colour (see \code{\link{sccolour})}
#   \item \code{size}:size of the line, in mm (see \code{\link{scsize})}
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
#  }
#
# @arguments the plot object to modify
# @arguments named list of aesthetic mappings, see details for more information
# @arguments other options, see details for more information
# @arguments data source, if not specified the plot default will be used
# @keyword hplot
# @seealso \code{\link{ggbar}}
#X df <- data.frame(x = factor(c(1, 1, 2, 2)), y = c(1, 5, 3, 4), g = c(1, 2, 1, 2), bar = c(0.1,
#X 0.3, 0.3, 0.2))
#X df2<-df[c(1,3),];df2
#X
#X p <- ggbar(ggplot(data=df, aes=list(fill=g, y=y, x=x)))
#X ggerrorbar(p, aes=list(plus=bar))
ggerrorbar <- function(plot, aesthetics = list(), ..., data = NULL) {
   plot <- pscontinuous(plot, "y", range = c(0, NA), expand = c(0.05, 0))
   gg_add("errorbar", plot, aesthetics, ..., data = data)
}


pre_errorbar <- function(data, avoid="none", sort=FALSE, ...) {
	data <- pre_bar(data, avoid=avoid, sort=sort, direction="vertical", ...)

	if (!all(c("upper","lower") %in% names(data))) {
		if (is.null(data$plus) && !is.null(data$minus)) data$plus <- -data$minus
		if (!is.null(data$plus) && is.null(data$minus)) data$minus <- -data$plus

		upper <- data$y + data$plus
		lower <- data$y + data$minus
	} else {
		upper <- data$upper
		lower <- data$lower
	}

	rbind(
		transform(data, y = upper, .pos = "t"),
		transform(data, y = lower, .pos = "b")
	)
}

grob_errorbar <- function (aesthetics, avoid = "none", ...) {
	aesthetics <- aesdefaults(aesthetics, list(colour = "black", size=1, linetype=1), ...)
	aesthetics <- position_adjust(aesthetics, avoid=avoid, "vertical", adjust=2)
	aesthetics$width <- aesthetics$width * 0.3

	aesm <- reshape::melt(as.data.frame(aesthetics), m="y")
	aesthetics <- as.data.frame(reshape::cast(aesm, ... ~ variable + .pos))

	aesthetics <- plyr::rename(aesthetics, c(y_t = "t", y_b="b"))
	aesthetics$l <- aesthetics$x - aesthetics$width
	aesthetics$r <- aesthetics$x + aesthetics$width

	with(aesthetics, polylineGrob(
		as.vector(rbind(l, r, x, x, r, l)), as.vector(rbind(t,t,t,b,b,b)), default.units="native", id.lengths=rep(6, nrow(aesthetics)),
		gp=gpar(col=as.character(colour), lwd=size, lty=linetype) # , name="errorbar"
	))
}
