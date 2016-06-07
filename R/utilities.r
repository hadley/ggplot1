# Useful little functions

# GG Pretty
# Pretty axis breaks
#
# Same as \code{\link{grid.pretty}} but contains minimum and
# maximum of data as well.  Useful for legends.
#  
# @arguments values to prettify
# @keyword internal
ggpretty <- function(x) {
  unique(c(min(x), grid.pretty(x), max(x)))
}

# Cleaner version of match.fun
# Version of \code{\link{match.fun}} that returns NULL on failure
# 
# @arguments function name to find (character vector)
# @value function if found, otherwise NULL
# @keyword internal 
match.fun.null <- function(x) {
  f <- NULL
  try(f <- match.fun(x), silent=TRUE)
  f
}

# alpha
# Give a colour an alpha level
# 
# @arguments colour
# @arguments alpha level [0,1]
# @keyword internal 
alpha <- function(colour, alpha) {
	col <- col2rgb(colour, TRUE) / 255
	col[4, ] <- alpha
	rgb(col[1,], col[2,], col[3,], col[4,])
}

# Apply with built in try
# 
# @keyword internal
# @alias tryNULL
tryapply <- function(list, fun, ...) {
  compact(lapply(list, function(x) tryNULL(fun(x, ...))))
}

tryNULL <- function(expr)  {
  result <- NULL
  tryCatch(result <- expr, error=function(e){})
  result
}
