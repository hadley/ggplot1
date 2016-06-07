# ggplot method for tabular data
# Automatically 
# 
# 
# @arguments table
# @arguments unused
# @keyword hplot 
#X ggbar(ggplot())
#ggplot.table <- function(data, ...) {
#	df <- as.data.frame(x)
#	ggplot(df, aes=list(y=Freq, x=names(df)[1]))
#}

#ggplot.lm <- function(data, ...) {
	# get significant cateogrical variables, and facet
	# get significant continuous variables, most of on x-axis, rest divided into slicess
#}

# ggplot: Time series
# Convenient way of plotting \code{ts} and \code{zoo} objects with ggplot
# 
# @arguments 
#ggplot.zoo <- ggplot.ts <- function(data, formula = series ~ ., margins=FALSE, aesthetics=list(x=time, y=value, id=series), ...) {
#	formula <- deparse(substitute(formula))
#	
#	df <- cbind(as.data.frame(data), time = c(as.numeric(time(data))))
#	dfm <- melt(df, id="time")
#	dfm <- rename(dfm, c(variable = "series"))
#	dfm$series <- factor(gsub("Series ", "", dfm$series))
#	
#	p <- ggplot(dfm, aesthetics=list(), margins=margins, formula=formula, ...)
#	p$defaults <- uneval(substitute(aesthetics))
#	p
#	
#}