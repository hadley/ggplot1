# Pretty axis breaks
ggpretty <- function(x) {
  unique(c(min(x), grid.pretty(x), max(x)))
}

# Version of \code{\link{match.fun}} that returns NULL on failure
match.fun.null <- function(x) {
  f <- NULL
  try(f <- match.fun(x), silent=TRUE)
  f
}

#' Give a colour an alpha level
#'
#' @param colour colour
#' @param alpha alpha level [0,1]
#' @keywords internal
#' @export
alpha <- function(colour, alpha) {
	col <- grDevices::col2rgb(colour, TRUE) / 255
	col[4, ] <- alpha
	grDevices::rgb(col[1,], col[2,], col[3,], col[4,])
}

# Apply with built in try
tryapply <- function(list, fun, ...) {
  compact(lapply(list, function(x) tryNULL(fun(x, ...))))
}

tryNULL <- function(expr)  {
  result <- NULL
  tryCatch(result <- expr, error=function(e){})
  result
}

defaults <- function(x, y) {
  c(x, y[setdiff(names(y), names(x))])
}

compact <- function(x) {
  x[!vapply(x, is.null, logical(1))]
}

stamp <- function(...) {
  suppressWarnings(reshape::stamp(...))
}
