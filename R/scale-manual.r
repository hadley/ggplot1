# Scale: manual
# Create a manual scale
# 
# This scale function allows you complete control over the 
# scale.
# 
# Supply labels and breaks to produce a legend.
# 
# @keyword hplot
# @arguments plot object to add scale to
# @arguments variable to scale
# @arguments name of the scale (used in the legend)
# @arguments numeric vector of break points
# @arguments character vector of break labels
# @arguments grob function to use when drawing legend
# @seealso \code{\link{ggfluctuation}} for a use
scmanual <- function(plot = .PLOT, variable="x", name="", breaks=NULL, labels=as.character(breaks), grob=function(x) grob_point(x, unique=FALSE)) {
	add_scale(plot,  
	  scale_manual(variable=variable, name=name, breaks=breaks, labels=labels, grob=grob) 
	)
}

scale_manual <- function(name="", variable="x", breaks=NULL, labels=labels, grob=function(x) grob_point(x, unique=FALSE)) {
	structure(
		list(variable=variable, name=name, breaks=breaks, labels=labels, grob=grob), 
		class = c("manual", "scale")
	)
}
"update<-.manual" <- function(x, value) x
map_aesthetic.manual <- function(scale, data, ...) {
	if (length(intersect(names(data), input(scale))) < length(input(scale))) return(data.frame())
	data[,input(scale), drop=FALSE]
}
breaks.manual <- function(scale, ...) scale$breaks
labels.manual <- function(object, ...) scale$labels


# Print manual details
# Print moderately useful details of this manual scale.
# 
# @arguments scale object
# @arguments not used
# @keyword manip 
# @keyword internal 
print.manual <- function(x, ...) {
	cat(paste("manual scale: ", scale_mapping(x), "\n", sep=""))
}

defaultgrob.manual <- function(x) x$grob
guides.manual <- function(scale, ...) {
  if(is.null(scale$labels)) return()
  guides.default(scale, ...)
}