# Get grid names
# 
# @keyword internal 
get.names <- function(x, indent=0) {
  if (length(x$children) > 0) {
    children <- clearNames(sapply(x$children, get.names, indent=indent+1))
    spaces <- paste(rep(" ", indent), collapse="") 
    paste(grid:::getName(x), ":\n", spaces, " (", paste(children, collapse=","), ")", "\n", sep="")
  } else grid:::getName(x)
}
