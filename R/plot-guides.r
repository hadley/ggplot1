# Default guides
# Generate default guides (legends, axes, and labels).
#
# The default guides built for a plot are:
# 
#  \item the background colour over the whole plotting area (white)
#  \item within each a panel a gray background with white gridlines 
#     (see \code{\link{ggopt}}) to change)
#  \item vertical and horizontal axes (appearance control by options
#     to the position scales)
#  \item facetting labels (see \code{\link{ggopt}}) to change default
#    colours etc)
# 
# To decouple plot construction from the objects that are placed within it,
# each of the grobs produced by this function uses a \code{\link[grid]{vpPath}}.
# 
# @arguments plot object
# @arguments plot scales
# @value background list of grobs to appear in background
# @value grid grobs that form background grob 
# @value axes\_v vertical axes
# @value axes\_h horizontal axes
# @value labels row and column labels
# @keyword hplot
# @keyword internal
guides_basic <- function(plot, scales=scales_default(plot)) {
	guides <- guides(scales)

  nr <- nrow(plot$facet)
  nc <- ncol(plot$facet)

	axes_v <- matrix(lapply(1:nr, function(n) editGrob(guides$y, name=paste("xaxis", n, sep=""))), ncol=1)
	axes_h <- matrix(lapply(1:nc, function(n) editGrob(guides$x, name=paste("yaxis", n, sep=""))), nrow=1)
	
	breaks <- position_apply(plot$scales, breaks)
	grid <- matrix(rep(list(grob_grid(xbreaks=breaks$x, ybreaks=breaks$y, fill=plot$grid.fill, colour=plot$grid.colour)), nc * nr), ncol = nc)
	pg <- expand.grid(1:nr, 1:nc)
	grid <- matrix(mapply(function(x,y) {
	  editGrob(grid[[x,y]], name=paste("grid", x, "-", y,  sep=""))
	},pg[,1], pg[,2], SIMPLIFY=FALSE), ncol=nc)
	
	list(
		background = list(rectGrob(gp=gpar(fill=plot$background.fill, col=NA), name="background")),
		grid =   plot_grob_matrix(grid, "panel"), 
		axes_v = plot_grob_matrix(axes_v, "axis_v"),
		axes_h = plot_grob_matrix(axes_h, "axis_h"),
		labels = labels_default(plot)
	)
}

# Default labels
# Generate default facet labels.
# 
# Facet labels are only displayed when there are facets in a particular
# direction.  By default the labels consist of the variable name : value.
# You can't currently change this display. but it will be an option in the near
# future.
#
# @arguments plot object
# @value gList containg text grobs with appropriate viewports
# @keyword hplot
# @keyword internal
labels_default <- function(plot, strip = plot$striplabel) {
	add.names <- function(x) {
		for(i in 1:ncol(x)) x[,i] <- plot$strip.text(colnames(x)[i], x[,i])
		x
	}

	row.labels <- add.names(rrownames(plot$facet))
	col.labels <- add.names(rcolnames(plot$facet))
  
  labels_h <- apply(col.labels, c(2,1), ggstrip, strip.gp=plot$strip.gp, text.gp=plot$strip.text.gp)
	labels_v <- apply(row.labels, c(1,2), ggstrip, hor=FALSE, strip.gp=plot$strip.gp, text.gp=plot$strip.text.gp)

  labels_grobs <- unlist(compact(list(
    if (ncol(plot$facet) > 1) plot_grob_matrix(labels_h),
    if (nrow(plot$facet) > 1) plot_grob_matrix(labels_v)
  )), recursive=FALSE)
  
  if (!is.null(labels_grobs)) do.call(gList, labels_grobs)
}


# Grob strip
# Grob for strip labels
# 
# @arguments text to display
# @arguments orientation, horizontal or vertical
# @keyword hplot 
# @keyword internal
ggstrip <- function(text, horizontal=TRUE, strip.gp=ggopt()$strip.gp, text.gp=ggopt()$strip.text.gp) {
	gTree(children = gList(
		rectGrob(gp=strip.gp), #, name="strip-background"
		textGrob(text, rot=-90 * (1 - horizontal), gp=text.gp) #, name="strip-text"
	))	# , name="strip"
}

# Legends
# Create and arrange legends for all scales.
# 
# This function gathers together all of the legends produced by 
# the scales that make up the plot and organises them into a 
# \code{\link[grid]{frameGrob}}.  
# 
# If there are no legends to create, this function will return \code{NULL}
# 
# @arguments scales object
# @arguments direction of scales, vertical by default
# @keyword hplot 
# @value frameGrob, or NULL if no legends
# @keyword internal
legends <- function(scales, horizontal = FALSE) {
	position_scale <- sapply(scales, function(x) inherits(x, "position"))
	legs <- compact(lapply(scales[!position_scale], guides))

  n <- length(legs)
	if (n == 0) return()
	
	if (!horizontal) {
  	width <-   do.call(sum, lapply(legs, widthDetails))
  	heights <- do.call(unit.c, lapply(legs, function(x) heightDetails(x) * 1.1))
  	fg <- frameGrob(grid.layout(nrow=n, 1, widths=width, heights=heights, just="centre"), name="legends")
  	for(i in 1:n) {
  		fg <- placeGrob(fg, legs[[i]], row=i)
  	}
	} else {
	  height <- do.call(sum, lapply(legs, heightDetails))
  	widths <- do.call(unit.c, lapply(legs, function(x) widthDetails(x) * 1.1))
  	fg <- frameGrob(grid.layout(ncol=n, 1, widths=widths, heights=height, just="centre"), name="legends")
  	for(i in 1:n) {
  		fg <- placeGrob(fg, legs[[i]], col=i)
  	}
	}
	fg
}

# Default guides
# Construct a default guide (legend) for a scale
# 
# This is used for automatic legends.
# 
# @arguments scale
# @keyword hplot 
guides.default <- function(scale, ...) {
	#if (scale$visible == FALSE) return()
	
	labels <- rev(labels(scale))
	breaks <- rev(breaks(scale))

	if (is.null(breaks)) return(NULL)
	grob <- defaultgrob(scale)
	
	title <- textGrob(scale$name, x = 0, y = 0.5, just = c("left", "centre"), gp=gpar(fontface="bold"), name="legend-title")
	
	nkeys <- length(labels)
	hgap <- vgap <- unit(0.3, "lines")
	
	values <- data.frame(breaks)
	names(values) <- output(scale)

	widths <- unit.c(unit(1.4, "lines"), hgap, max(unit.c(unit(1, "grobwidth", title), unit(rep(1, nkeys), "strwidth", as.list(labels)))), hgap)
	heights <- unit.c(
		unit(1, "grobheight", title) + 2 * vgap, 
		unit.pmax(unit(1.4, "lines"), vgap + unit(rep(1, nkeys), "strheight", as.list(labels)))
	)
	
	# Make a table, 
  legend.layout <- grid.layout(nkeys+1, 4, widths = widths, heights = heights, just=c("left","top"))
  fg <- frameGrob(layout = legend.layout, name="legend")
	fg <- placeGrob(fg, rectGrob(gp=gpar(fill="NA", col="NA", name="legend-background")))

	fg <- placeGrob(fg, title, col=1:2, row=1)
	for (i in 1:nkeys) {
		df <- as.list(values[i,, drop=FALSE])
		df$x <- unit(0.5, "npc")
		df$y <- unit(0.5, "npc")
		fg <- placeGrob(fg, editGrob(do.call(grob, list(df)), name="legend-key"), col = 1, row = i+1)
		fg <- placeGrob(fg, textGrob(labels[i], x = 0, y = 0.5, just = c("left", "centre"), name="legend-label"), col = 3, row = i+1)
	}

	fg
}