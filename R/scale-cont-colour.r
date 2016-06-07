scale_cont_colour <- function(inputs, name="", variable="colour", to=list()) {
	type <- paste(inputs[1:3], collapse="")
	x <- list(inputs=inputs, name=name, variable=variable, to=to, type=type, visible=TRUE)
	class(x) <- c("scale_cont_colour", "scale")
	x
}
#' @export
input.scale_cont_colour <- function(scale)  scale$inputs
#' @export
output.scale_cont_colour <- function(scale) scale$variable

#' @export
guides.scale_cont_colour <- function(scale, ...) NULL

#' @export
"update<-.scale_cont_colour" <- function(x, value) {
	vars <- intersect(names(value), input(x))
	x$from <- lapply(vars, function(variable) range(value[[variable]], na.rm=TRUE))
	names(x$from) <- paste(vars, "from", sep=".")
	x
}

#' @export
map_aesthetic.scale_cont_colour <- function(scale, data, ...) {
	vars <- intersect(names(data), input(scale))
	func <- paste("map_colour", scale$type, sep="_")
	data.frame(colour=do.call(func, c(data[, vars, drop=FALSE], scale$from, scale$to)))
}

#' Scale: colour (rgb)
#' Scale continuous variables to red, green and blue components of colour.
#'
#' The RGB colour space is NOT perceptually uniform.  Use
#' this scale with care.  It is extremely ill-advised to map variables to more
#' than one of r, g, b, or a.
#'
#' Note: alpha mappings only work with the Quartz and PDF devices.
#'
#' @inheritParams pscontinuous
#' @param to named list of target ranges (r.to, g.to, b.to, a.to)
#' @export
#' @examples
#' library(ggplot2movies)
#' p <- scrgb(ggplot(movies, aes=list(y=rating, x=year)))
#' ggpoint(p, list(r=year))
#' ggpoint(p, list(b=rating))
#' ggpoint(p, list(b=rating, r=1))
#' scrgb(ggpoint(p, list(b=rating, r=1)), list(b.to=c(0.25,0.75)))
#' ggpoint(p, list(b=rating, r=year))
#' ggpoint(p, list(b=rating, r=year, g=year))
scrgb <- function(plot, name="", to=list()) add_scale(plot, scale_rgb(name=name, to))

scale_rgb <- function(name="", to=list()) scale_cont_colour(name=name, c("r","g","b","a"), to)

#' @export
#' @rdname scrgb
scfillrgb <- function(plot, name="", to=list()) add_scale(plot, scale_fill_rgb(name=name, to))

scale_fill_rgb <- function(name="", to=list()) scale_cont_colour(name=name, variable="fill", c("r","g","b","a"), to)


#' Scale: colour (hcl)
#' Scale continuous variables to hue, chroma and luminance components of colour
#'
#' This colour map is the most perceptually uniform.  However, use multiple
#' mappings with care.  It is often a good idea to restrict the range of the
#' hue, as shown in the example.
#'
#' Note: alpha mappings only work with the Quartz and PDF devices.
#'
#' @inheritParams pscontinuous
#' @inheritParams scrgb
#' @export
#' @examples
#' p <- schcl(ggplot(movies, aes=list(y=rating, x=year)))
#' ggpoint(p, list(h=year))
#' schcl(ggpoint(p, list(h=year)), list(h.to=c(45,60)))
#' ggpoint(p, list(c=rating))
#' ggpoint(p, list(l=length))
#' ggpoint(p, list(h=rating, l=year))
#' ggpoint(p, list(h=rating, c=year, l=year))
schcl <- function(plot, name="", to=list()) add_scale(plot, scale_hcl(name=name, to))
scale_hcl <- function(name="", to=list()) scale_cont_colour(name=name, c("h","c","l","a"), to)

#' @export
#' @rdname schcl
scfillhcl <- function(plot, name="", to=list()) add_scale(plot, scale_fill_hcl(name=name, to))
scale_fill_hcl <- function(name="", to=list()) scale_cont_colour(name=name, variable="fill", c("h","c","l","a"), to)
