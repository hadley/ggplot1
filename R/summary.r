# Summarise ggplot object
# Displays a useful description of a ggplot object
# 
# @keyword internal
summary.ggplot <- function(object, ...) {
  defaults <- function() {
    paste(mapply(function(x, n) {
      paste(n, deparse(x), sep="=")
    }, object$defaults, names(object$defaults)), collapse=", ")
  }
  
  cat(" Title:     ", object$title, "\n", sep="")
  cat(" Labels:    x=", object$xlabel, ", y=", object$ylabel, "\n", sep="")
  cat(" Data:      ", paste(names(object$data), collapse=", "), " [", nrow(object$data), "x", ncol(object$data), "] ", "\n", sep="")
  cat(" Defaults:  ", defaults(), "\n", sep="")
  cat(" Scales:    ", paste(sapply(object$scales, scale_mapping), collapse=", "), "\n", sep="")
  cat(" Grobs:    ", paste(sapply(object$grobs, function(x) x$name), collapse=", "), "\n")
  cat(" Facetting:", deparse(object$formula), "\n")
  cat(" Margins:  ", object$margins, "\n")
  
  
} 