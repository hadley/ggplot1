# Scale: colour (continuous)
# Scale colour along a continuous path
# 
# This scale class is the workhorse behind:
# 
#   \item \code{\link{scrgb}}
#   \item \code{\link{schsv}}
#   \item \code{\link{schcl}}
# 
# See those function for more details.
# 
# @keyword hplot
# @keyword internal 
scale_cont_colour <- function(inputs, name="", variable="colour", to=list()) {
	type <- paste(inputs[1:3], collapse="")
	x <- list(inputs=inputs, name=name, variable=variable, to=to, type=type, visible=TRUE)
	class(x) <- c("scale_cont_colour", "scale")
	x
}
input.scale_cont_colour <- function(scale)  scale$inputs
output.scale_cont_colour <- function(scale) scale$variable

guides.scale_cont_colour <- function(scale, ...) NULL

"update<-.scale_cont_colour" <- function(x, value) {
	vars <- intersect(names(value), input(x))
	x$from <- lapply(vars, function(variable) range(value[[variable]], na.rm=TRUE))
	names(x$from) <- paste(vars, "from", sep=".")
	x
}

map_aesthetic.scale_cont_colour <- function(scale, data, ...) {
	vars <- intersect(names(data), input(scale))
	func <- paste("map_colour", scale$type, sep="_")
	data.frame(colour=do.call(func, c(data[, vars, drop=FALSE], scale$from, scale$to)))
}

# Scale: colour (rgb)
# Scale continuous variables to red, green and blue components of colour.
# 
# The RGB colour space is NOT perceptually uniform.  Use
# this scale with care.  It is extremely ill-advised to map variables to more
# than one of r, g, b, or a.
# 
# Note: alpha mappings only work with the Quartz and PDF devices.
# 
# @arguments plot to add scale to
# @arguments name of the scale (used in the legend)
# @arguments named list of target ranges (r.to, g.to, b.to, a.to)
# @keyword hplot 
# @seealso \code{\link{map_colour_rgb}}, \code{\link{rgb}}
# @alias scfillrgb
#X p <- scrgb(ggplot(movies, aes=list(y=rating, x=year)))
#X ggpoint(p, list(r=year))
#X ggpoint(p, list(b=rating))
#X ggpoint(p, list(b=rating, r=1))
#X scrgb(ggpoint(p, list(b=rating, r=1)), list(b.to=c(0.25,0.75)))
#X ggpoint(p, list(b=rating, r=year))
#X ggpoint(p, list(b=rating, r=year, g=year))
scrgb <- function(plot = .PLOT, name="", to=list()) add_scale(plot, scale_rgb(name=name, to))
scale_rgb <- function(name="", to=list()) scale_cont_colour(name=name, c("r","g","b","a"), to)

scfillrgb <- function(plot = .PLOT, name="", to=list()) add_scale(plot, scale_fill_rgb(name=name, to))
scale_fill_rgb <- function(name="", to=list()) scale_cont_colour(name=name, variable="fill", c("r","g","b","a"), to)


# Scale: colour (hsv)
# Scale continuous variables to hue, saturation and value components of colour.
# 
# Use multiple mappings with care
#
# Note: alpha mappings only work with the Quartz and PDF devices.
# 
# @seealso \code{\link{map_colour_hsv}}, \code{\link{hsv}}
# @keyword hplot 
# @alias scfillhsv
#X p <- schsv(ggplot(movies, aes=list(y=rating, x=year)))
#X ggpoint(p, list(h=year))
#X schsv(ggpoint(p, list(h=year)), list(h.to=c(0.3,0.5)))
#X ggpoint(p, list(s=rating))
#X ggpoint(p, list(v=rating, h=0.3, s=rating))
#X ggpoint(p, list(h=rating, v=year))
schsv <- function(plot = .PLOT, name="", to=list()) add_scale(plot, scale_hsv(name=name, to))
scale_hsv <- function(name="", to=list()) scale_cont_colour(name=name, c("h","s","v","a"), to)

scfillhsv <- function(plot = .PLOT, name="", to=list()) add_scale(plot, scale_fill_hsv(name=name, to))
scale_fill_hsv <- function(name="", to=list()) scale_cont_colour(name=name, variable="fill", c("h","s","v","a"), to)

# Scale: colour (hcl)
# Scale continuous variables to hue, chroma and luminance components of colour
# 
# This colour map is the most perceptually uniform.  However, use multiple
# mappings with care.  It is often a good idea to restrict the range of the 
# hue, as shown in the example.
# 
# Note: alpha mappings only work with the Quartz and PDF devices.
# 
# @keyword hplot 
# @seealso \code{\link{map_colour_hcl}}, \code{\link{hcl}}
# @alias scfillhcl
#X p <- schcl(ggplot(movies, aes=list(y=rating, x=year)))
#X ggpoint(p, list(h=year))
#X schcl(ggpoint(p, list(h=year)), list(h.to=c(45,60)))
#X ggpoint(p, list(c=rating))
#X ggpoint(p, list(l=length))
#X ggpoint(p, list(h=rating, l=year))
#X ggpoint(p, list(h=rating, c=year, l=year))
schcl <- function(plot = .PLOT, name="", to=list()) add_scale(plot, scale_hcl(name=name, to))
scale_hcl <- function(name="", to=list()) scale_cont_colour(name=name, c("h","c","l","a"), to)

scfillhcl <- function(plot = .PLOT, name="", to=list()) add_scale(plot, scale_fill_hcl(name=name, to))
scale_fill_hcl <- function(name="", to=list()) scale_cont_colour(name=name, variable="fill", c("h","c","l","a"), to)
