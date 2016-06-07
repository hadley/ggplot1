library(ggplot)
source.with.err <- function(path) {
	tryCatch(source(path), error = function(x) print(path))
}
lapply(dir("~/Documents/ggplot/releases/ggplot-0.4.1/R/", full.name=T), source.with.err)


