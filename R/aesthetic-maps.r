# Chop
# Chop a continuous variable into a categorical variable.
#
# Chop provides a convenient interface to the main methods of
# converting a continuous variable into a categorical variable.
#
# @argument continuous variable to chop into pieces
# @argument number of bins to chop into
# @argument method to use: quantiles (approximately equal numbers), cut (equal lengths) or pretty
# @argument mid point for diverging factors
# @keyword manip
chop <- function(x, n=5, method="quantiles", midpoint=0, digits=2) {
	methods <- c("quantiles","cut", "pretty")
	method <- methods[charmatch(method, methods)]
	if (is.na(method)) stop(paste("Method must be one of:", paste(methods, collapse=", ")))
	
	breaks <- chop.breaks(x, n, method, midpoint)
	labels <- formatC(breaks, digits=2, width=0)
	
	fac <- ordered(cut(x, breaks, labels=FALSE, include.lowest=TRUE) - attr(breaks,"midpoint.level"),labels=paste(labels[-length(breaks)], labels[-1], sep="-"))
	attr(fac, "breaks") <- breaks
	
	if (attr(breaks,"midpoint.level") != 0) {
		attr(fac, "midpoint.level") <- - attr(breaks,"midpoint.level")
		class(fac) <- c("diverging", "ordered", "factor")		
	}

	fac
}

# Chop breaks
# Calculate breakpoints for chop function
#
# @argument continuous variable
# @argument number of bins to chop into
# @argument method to use: quantiles (approximately equal numbers), cut (equal lengths) or pretty
# @argument mid point for diverging factors
# @keyword manip
chop.breaks <- function(x, n, method, midpoint=NA) {
	if (!missing(midpoint) && midpoint > min(x, na.rm=TRUE) && midpoint < max(x, na.rm=TRUE)) {
		range <- diff(range(x, na.rm=TRUE))
		range.neg <- midpoint - min(x, na.rm=TRUE)
		range.pos <- max(x, na.rm=TRUE) - midpoint
		
		n.pos <- floor(n * range.pos / range)
		n.neg <- ceiling(n * range.neg / range)
		
		breaks <- unique(c(
			chop.breaks(x[x <= midpoint], n.neg, method, midpoint)[-(n.neg + 1)],
			midpoint, 
			chop.breaks(x[x >= midpoint], n.pos, method, midpoint)[-1]
		))
		attr(breaks, "midpoint.level") <- n.neg+1
		
	} else {
		breaks <- unique(as.vector(switch(method, 
			pretty = pretty(x, n),
			cut = seq(min(x, na.rm=TRUE),max(x, na.rm=TRUE), length=n+1), 
			quantiles = quantile(x, seq(0,1, length=n+1), na.rm=TRUE)
		)))
		attr(breaks, "midpoint.level") <- 0
	}
	
	breaks
}

# Automatic chop
# Keep categorical variables as is, chop up continuous variable
#
# @argument data
# @keyword manip
chop_auto <- function(x) {
	if(is.factor(x)) return(x)
	if (length(unique(x)) < 5) return(factor(x))
	
	warning("Continuous variable automatically converted to categorical", call.=FALSE)
	chop(x)#, method="pretty")
}

# Rescale numeric vector
# Rescale numeric vector to have specified minimum and maximum.
# If vector has length one, it is not rescaled, but is restricted to the range.
#
# @argument data to rescale
# @argument range to scale to
# @argument range to scale from, defaults to range of data
# @keyword manip
rescale <- function(x, to=c(0,1), from=range(x, na.rm=TRUE)) {
	if (length(from) == 1 || length(to) == 1  || from[1] == from[2] || to[1] == to[2]) return(x)
	if (is.factor(x)) {
		warning("Categorical variable automatically converted to continuous", call.=FALSE)
		x <- as.numeric(x)
	}
	
	(x-from[1])/diff(from)*diff(to) + to[1]

}


# Continuous mappings
# ================================================================

# Aesthetic mapping: colour gradient
# Map values to a colour gradient
#
# @arguments data vector
# @arguments colour to use at bottom of scale
# @arguments colour to use at middle of scale
# @arguments colour to use at top of scale
# @arguments where mid point colour should be used
# @alias map_color_gradient
# @keyword hplot
map_colour_gradient <- function(x, low="red", mid="white",high="black", midpoint = 0, from=range(x, na.rm=TRUE)) {
	if (length(x) == 0) return()
	ashcl <- function(x) {
		rgba <- col2rgb(x, TRUE)/ 255
		c(as.vector(convertColor(matrix(rgba[1:3], ncol=3), "sRGB", "Lab")), rgba[4])
	}
	x <- as.numeric(x)
	low.rgb  <- col2rgb(low, alpha=TRUE) / 255# ashcl(low)
	mid.rgb  <- col2rgb(mid, alpha=TRUE) / 255 #ashcl(mid)
	high.rgb <- col2rgb(high, alpha=TRUE) / 255 #ashcl(high)
	
	colour_interp <- function(i) approxfun(c(from[1], midpoint, from[2]), c(low.rgb[i], mid.rgb[i], high.rgb[i]))
	interp_r <- colour_interp(1)
	interp_g <- colour_interp(2)
	interp_b <- colour_interp(3)
	interp_a <- colour_interp(4)

	#labc <- convertColor(cbind(interp_l(x), interp_ax(x), interp_b(x)), "Lab", "sRGB")
	#apply(cbind(labc, interp_a(x)), 1, function(x) do.call(rgb, as.list(x)))
	
	rgb(interp_r(x), interp_g(x), interp_b(x), interp_a(x))
}

# Aesthetic mapping: hsv components of colour
# Map variables to hue, saturation or value
#
# @arguments hue
# @arguments saturation
# @arguments value
# @arguments alpha
# @arguments hue range
# @arguments saturation range
# @arguments value range
# @arguments alpha range
# @keyword hplot
# @alias map_color_hsv
map_colour_hsv <- function(h=1, s=1, v=1, a=1, h.to=c(0,1), s.to=c(0,1), v.to=c(0,1), a.to=c(0,1), h.from=range(h, na.rm=TRUE), s.from = range(s, na.rm=TRUE), v.from = range(v, na.rm=TRUE), a.from = range(a, na.rm=TRUE)) {
	.map_colour(list(h,s,v,a), list(h.to, s.to, v.to, a.to), list(h.from, s.from, v.from, a.from), hsv)	
}

# Aesthetic mapping: hcl components of colour
# Map variables to hue, chroma or luminance.
#
# Using hue is the best.
#
# @arguments hue
# @arguments chroma
# @arguments luminance
# @arguments alpha
# @arguments hue to
# @arguments chroma to
# @arguments luminance to
# @arguments alpha to
# @keyword hplot
# @alias map_color_hcl
map_colour_hcl <- function(h=0, c=80, l=50, a=1, h.to=c(0,360), c.to=c(0,200), l.to=c(0,100), a.to=c(0,1), h.from = range(h, na.rm=TRUE), c.from = range(c, na.rm=TRUE), l.from = range(l, na.rm=TRUE), a.from = range(a, na.rm=TRUE)) {
	.map_colour(list(h,c,l,a), list(h.to, c.to, l.to, a.to), list(h.from, c.from, l.from, a.from), hcl)	
}

# Aesthetic mapping: rgb components of colour
# Map variables to red, green or blue components.
#
# @arguments red
# @arguments green
# @arguments blue
# @arguments alpha
# @arguments red to
# @arguments green to
# @arguments blue to
# @arguments alpha to
# @keyword hplot
# @alias map_color_rgb
map_colour_rgb <- function(r=0, g=0, b=0, a=1, r.to = c(0,1), g.to=c(0,1), b.to=c(0,1), a.to=c(0,1), r.from = range(r, na.rm=TRUE), g.from = range(g, na.rm=TRUE), b.from = range(b, na.rm=TRUE), a.from = range(a, na.rm=TRUE)) {
	.map_colour(list(r,g,b,a), list(r.to, g.to, b.to, a.to), list(r.from, g.from, b.from, a.from), rgb)
}


# Map colour
# Convenience function to power \code{\link{map_colour_hsv}}, 
# \code{\link{map_colour_hcl}} and \code{\link{map_colour_rgb}}
#
# @arguments list of colour vectors
# @arguments list of colour tos in same order as colours
# @arguments function to produce colours in \#rrggbbaa form
# @keyword hplot
# @keyword internal 
.map_colour <- function(colours, tos, froms, colour_function) {
	do.call(colour_function, mapply(rescale, colours, tos, froms))
}


# Categorical mappings
# ================================================================

# Aesthetic mapping: glyph shape
# Map values to point shapes.  
#
# If x is not a factor, will be converted to one by \code{\link{chop_auto}}.
# Can display at most 6 different categories.
#
# @arguments data vector
# @arguments use solid points?
# @keyword manip
# @seealso \url{http://www.public.iastate.edu/~dicook/scgn/v141.pdf}
map_shape <- function(x, solid=FALSE) {
	x <- chop_auto(x)
	if (length(levels(x)) > 6) stop("Too many levels! 6 at most")
	
	if (solid) {
		c(19, 17, 3, 15, 7, 8)[x]
	} else {
		c(1:3, 5, 7, 8)[x]
	}
}

# Aesthetic mapping: line type
# Map values to line types
#
# If x is not a factor, will be converted to one by \code{link{chop_auto}}.
# Can display at most 4 different categories.
#
# @arguments data vector
# @keyword manip
map_linetype <- function(x){
	x <- chop_auto(x)
	if (length(levels(x)) > 4) stop("Too many levels! 4 at most")
	
	c(1,2,3,4)[x]
}

# Aesthetic mapping: Brewer colours
# Map categorical variables to Brewer colour scales
#
# If x is not a factor, will be converted to one by \code{\link{chop_auto}}.
# Can display at most 9 different categories.
#
# Unordered factors will use qualitative scales.
# Ordered factors will use sequential scales.
# Ordered factors with negative level will use diverging scales.
#
# @arguments data vector
# @arguments palette number to use
# @keyword manip
# @alias map_color_brewer
# @alias map_color
# @alias map_colour
map_colour_brewer <- function(x, palette=1){
	x <- chop_auto(x)
	type <- brewer_type(x)

	if (type == "div") {
		y <- as.numeric(as.vector(x))
		n <- 2 * max(abs(range(y, na.rm=TRUE))) + 1
		x <- y - attr(x, "midpoint.level")
	} else {
		n <- length(levels(x))
	}
	
	if (n > 9) stop("Too many levels! 9 at most")
	if (n < 3) stop("Too few levels! 3 at least")
	
	pal <- brewer.pal(n, brewer_palettes(type)[palette])
	pal[x]
}
map_color_brewer <- map_colour_brewer


map_colour <- function(x, h=c(0,360), l=60, c=90, alpha=1) {
	x <- chop_auto(x)
	n <- length(levels(x))
	
	pal <- grDevices::hcl(seq(h[1], h[2], length = n+1), c=c, l=l, alpha=alpha)[-(n+1)]
	pal
	#names(pal) <- 
	#pal[levels(x)]
}

map_color <- map_colour


# Brewer type
# Return the type of factor in Cynthia brewers scheme.
# Ordered factors with negative levels mapped to diverging,
# other ordered factors mapped to sequential, and unordered factors
# to quantitative.
#
# @argument factor to inspect
# @value character string giving Brewer type
# @keyword internal 
brewer_type <- function(x) {
	if (is.ordered(x)) {
		if ("diverging" %in% class(x)) {
			return("div")
		} else {
			return("seq")
		}
	} else if (is.factor(x)) {
		return("qual")
	} else {
		return(NA)
	}
}

# Get Brewer colour palettes
# Convenience function to retrieve private RColorBrewer palettes.
# 
# @arguments type of palettes to retrieve
# @keyword internal
brewer_palettes <- function(type) {
	switch(type, div = RColorBrewer:::divlist, qual = RColorBrewer:::quallist, seq = RColorBrewer:::seqlist)
} 


# Alias all colour to color
map_color_brewer <- map_colour_brewer
map_color_gradient <- map_colour_gradient
map_color_hsv <- map_colour_hsv
map_color_hcl <- map_colour_hcl
map_color_rgb <- map_colour_rgb
