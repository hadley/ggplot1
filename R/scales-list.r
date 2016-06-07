# Scaleslist object
# Create a list of scales objects
# 
# The scales output maintains a list of scale objects.  
# 
#  \item input and output variables
#  \item maps a data frames using those scales
#  \item generates ready to use scales
# 
# @keyword hplot 
# @arguments scales objects
# @alias input.scales
# @alias output.scales
# @alias print.scales
# @alias range.scales
# @alias guides.scales
# @keyword internal
scales <- function(...) {
	structure(list(...), class="scales")
}
input.scales <- function(scale)  lapply(scale, input)
output.scales <- function(scale) lapply(scale, output)
print.scales <- function(x, ...) str(x)
range.scales <- function(scales, ...) position_apply(scales, range)
guides.scales <- function(scale, ...) {
	position_apply(scale, guides)
}

# Add new scale
# Add new scale to list.  
# 
# Will overwrite any existing scales that use the same
# output variables.
# 
# @keyword hplot 
# @keyword internal
"add<-" <- function(x, value) {
	replaced <- output(x) %in% output(value)
	do.call(scales, c(x[!replaced, drop=FALSE], list(value)))
}

# Update scales.
# This function updates an entire set of scales with data.
# 
# Update needs to be able to deal with the multiple possible
# data formats it could recieve:
# 
#  * a single data frame (representing one panel from one grob function)
#  * a matrix of data frames (all panels from a grob function)
#  * a list of matrix of data frames (all panels from all grob functions)
# 
# @keyword hplot 
# @arguments scales object
# @arguments data
# @keyword internal
"update<-.scales" <- function(x, value) {
	if (is.matrix(value)) {
		value <- do.call(rbind.fill, value)
	} else if(is.list(value) && !is.data.frame(value)) {
		if (length(value) == 0) {
			value <- NULL
		} else {
			value <- do.call(rbind.fill, unlist(value, recursive=FALSE))
		}
	}
	structure(lapply(x, "update<-", value=value), class="scales")
}

# Map scales.
# Applies scales to data to return a data frame
# of aesthetic values, ready to be realised by the grob functions
# 
# @keyword hplot 
# @arguments scale
# @arguments data
# @arguments other arguments (unused)
# @keyword internal
map_aesthetic.scales <- function(scale, data, ...) {
	if (is.list(data) && !is.data.frame(data)) data <- data[[1]]
	if (length(scale) == 0) return(data)

	results <- lapply(scale, map_aesthetic, data=data)
	absent <- sapply(results, function(x) nrow(x) == 0 )
	
	data.frame(defaults(as.data.frame(results[!absent]), data))
}

# Map all
# Map all grobs with scale
# 
# @arguments scale to map with
# @arguments matrix of grobs
# @keyword hplot 
# @keyword internal
map_all <- function(scale, matrix) {

	if (length(matrix) == 0) return(matrix)
	if (is.matrix(matrix)) {
		apply(matrix, c(1,2), function(x) map_aesthetic(scale, x))
	} else if(is.list(matrix) && !is.data.frame(matrix)) {
		lapply(matrix, function(x) map_all(scale, x))
	} else {
		map_aesthetic(scale, matrix)
	}
	
}

# Position apply
# Apply a function to x and y position scales.
# 
# This is a convience method because position scales can
# be made up of two separate scales, or one scale that provides
# both x and y position mappings.
# 
# @arguments scales
# @arguments function to apply
# @arguments other arguments to pass to f
# @keyword hplot 
# @keyword internal
position_apply <- function(scales, f, ...) {
	find_output <- function(outputs) sapply(scales, function(x) all(outputs %in% output(x), na.rm=TRUE))
	xyscale <- find_output(c("x","y"))
	
	if (any(xyscale)) {
		return(f(scales[xyscale][[1]]))
	}
	
	xscale <- find_output("x")
	yscale <- find_output("y")
	
	list(x = f(scales[xscale][[1]]), y=f(scales[yscale][[1]]))
}
