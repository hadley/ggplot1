# These functions provide template for creating common plots.
# They are also useful to illustrate some different capabilities of
# ggplot.

# Parallel coordinates plot.
# Generate a plot ``template'' for a paralell coordinates plot.
# 
# One way to think about a parallel coordinates plot, is as plotting 
# the data after it has transformation been transformed to gain a new
# variable.  This function does this using \code{\link[reshape]{melt}}.
# 
# This gives us enormous flexibility as we have separated out the 
# type of drawing (lines by tradition) and can now use any of the existing
# grob functions.  In particular this makes it very easy to create parallel
# boxplots, as shown in the example.
# 
# Three different scaling function are available:
# \itemize{
#   \item "range": scale coordinates to have common range $[0, 1]
#   \item "var": scale coordinates to have mean 0 and variance 1
#   \item "I": don't scale the coordinates at all 
# }
# @arguments data frame
# @arguments variables to include in parallel coordinates plot
# @arguments scaling function, one of "range", "var" or "I"
# @arguments other arguments passed on plot creation
# @keyword hplot 
#X ggline(ggpcp(mtcars))
#X ggline(ggpcp(mtcars, scale="var"))
#X ggline(ggpcp(mtcars, vars=names(mtcars)[3:6], formula= . ~cyl, scale="I"))
#X ggboxplot(ggpcp(mtcars, scale="I"))
#X ggline(ggpcp(mtcars, vars=names(mtcars[2:6])))
#X p <- ggpcp(mtcars, vars=names(mtcars[2:6]), formula=.~vs)
#X ggline(p)
#X ggline(p, aes=list(colour=mpg)) 
ggpcp <- function(data, vars=names(data), scale="range", ...) {
  force(vars)	
	scaled <- rescaler(data[, vars], type=scale)
	data <- cbind(scaled, data[, setdiff(names(data), vars), drop=FALSE])
	
	data$ROWID <- 1:nrow(data)
	molten <- melt(data, m=vars)

	p <- ggplot(molten, aesthetics=list(x=variable, y=value, id=ROWID), ...)
	pscategorical(p, "x")
}

# Fluctuation plot
# Create a fluctuation plot.
# 
# A fluctutation diagram is a graphical representation of a contingency
# table.  This fuction currently only supports 2D contingency tabless
# but extension to more should be relatively straightforward.
# 
# With the default size fluctuation diagram, area is proportional to the 
# count (length of sides proportional to sqrt(count))
# 
# @arguments a table of values, or a data frame with three columns, the last column being frequency
# @arguments size, or colour to create traditional heatmap
# @arguments don't display cells smaller than this value
# @arguments 
# @keyword hplot
#X ggfluctuation(table(action=movies$Action, comedy=movies$Comedy))
#X ggfluctuation(table(action=movies$Action, rating=movies$mpaa))
#X ggfluctuation(table(action=movies$Action, comedy=movies$Comedy), type="colour")
#X ggfluctuation(table(warpbreaks[,c(1,3)]))
ggfluctuation <- function(table, type="size", floor=0, ceiling=max(table$freq, na.rm=TRUE)) {
  if (is.table(table)) table <- as.data.frame(t(table))

  oldnames <- names(table)
  names(table) <- c("x","y", "freq")
	
	table <- add.all.combinations(table, list("x","y"))	
  table <- transform(table,
		x = as.factor(x),
    y = as.factor(y)
 )

	if (type =="size") {
		table <- transform(table, 
    	freq = sqrt(pmin(freq, ceiling) / ceiling),
			border = ifelse(is.na(freq), "grey90", ifelse(freq > ceiling, "grey30", "grey50"))
  	)
		table[is.na(table$freq), "freq"] <- 1
	}

	table <- subset(table, freq * ceiling >= floor)
  
  if (type=="size") {
    p <- ggtile(ggplot(table, aesthetics = list(x=x, y=y, height=freq, width=freq, fill=border)), colour="white")
    #p <- pscategorical(p, var="x", expand=c(0, 1))
    #p <- pscategorical(p, "y", expand=c(0, 1))
		p <- scmanual(p, "fill")
  } else {
    p <- ggtile(ggplot(table, aesthetics = list(x=x, y=y, fill=freq)), colour="grey50")
    p <- scfillgradient(p, low="white", high="darkgreen")
  }

  p$xlabel <- oldnames[1]
  p$ylabel <- oldnames[2]
  p
}

# Missing values plot
# Create a plot to illustrate patterns of missing values
# 
# The missing values plot is a useful tool to get a rapid
# overview of the number of missings in a dataset.  It's strength
# is much more apparent when used with interactive graphics, as you can
# see in Mondrian (\url{http://rosuda.org/mondrian}) where this plot was
# copied from.
# 
# @arguments data.frame
# @arguments whether missings should be stacked or dodged, see \code{\link{ggbar}} for more details
# @arguments whether variable should be ordered by number of missings
# @arguments whether only variables containing some missing values should be shown
# @keyword hplot
# @seealso \code{\link{ggstructure}}, \code{\link{ggorder}}
#X mmissing <- movies
#X mmissing[sample(nrow(movies), 1000), sample(ncol(movies), 5)] <- NA
#X ggmissing(mmissing)
#X ggmissing(mmissing, order=FALSE, missing.only = FALSE)
#X pscontinuous(ggmissing(mmissing, avoid="dodge"), "y", transform=trans_sqrt, range=c(0, NA))
#X pscontinuous(ggmissing(mmissing), "y", transform=trans_log10, range=c(1, NA))
ggmissing <- function(data, avoid="stack", order=TRUE, missing.only = TRUE) {
	missings <- mapply(function(var, name) cbind(as.data.frame(table(missing=factor(is.na(var), levels=c(TRUE, FALSE), labels=c("yes", "no")))), variable=name), 
		data, names(data), SIMPLIFY=FALSE
	)
	df <- do.call(rbind, missings)
	
	prop <- df[df$missing == "yes", "Freq"] / (df[df$missing == "no", "Freq"] + df[df$missing == "yes", "Freq"])
	df$prop <- rep(prop, each=2)
	
	
	if (order) {
		df$variable <- reorder_factor(df$variable, prop)
	}

	if (missing.only) {
		df <- df[df$prop > 0 & df$prop < 1, , drop=FALSE]
		df$variable <- factor(df$variable)
	}
	
	ggbar(ggplot(df, aes=list(y=Freq, x=variable, fill=missing)), avoid=avoid)
}

# Structure plot
# A plot which aims to reveal gross structural anomalies in the data
# 
# @arguments data set to plot
# @arguments type of scaling to use.  See \code{\link[reshape]{rescaler}} for options
# @keyword hplot
#X ggstructure(mtcars)
ggstructure <- function(data, scale = "rank") {
	p <- ggtile(ggpcp(data, scale=scale), aes=list(y=ROWID, fill=value))
	p$ylabel <- "row number"
	p <- pscontinuous(p, "y", expand = c(0, 1))
	scfillgradient(p, low="blue", mid="white", high="red", midpoint=0)
}

# Order plot
# A plot to investigate the order in which observations were recorded.
# 
# ar
#  Need ggobi version as well that creates edge between consecutive observations (and adds row number to dataset)
# 
# @arguments data set to plot
# @arguments type of scaling to use.  See \code{\link[reshape]{rescaler}} for options
# @keyword hplot 
ggorder <- function(data, scale="rank") {
	p <- ggpcp(data, scale="rank")
	p <- defaultaesthetics(p, list(x=ROWID, id=variable))
	p <- setfacets(p, . ~ variable)
	p <- ggline(p)
	p <- pscontinuous(p, "x")
	p$xlabel <- "row number"
	p
}

# Distribution plot
# Experimental template
# 
# @keyword internal  
ggdist <- function(data, vars=names(data), facets = . ~ .) {
	cat <- sapply(data[vars], is.factor)
	facets <- deparse(substitute(facets))
	
	grid.newpage()
	pushViewport(viewport(layout=grid.layout(ncol = ncol(data))))
	
	mapply(function(name, cat, i) {
		p <- ggplot(data)
		p <- setfacets(p, facets)
		p$defaults <- list(x=as.name(name), y=1)
		p <- if (cat) ggbar(p, avoid="stack") else gghistogram(p)
		pushViewport(viewport(layout.pos.col=i))
		grid.draw(ggplot_plot(p, pretty=FALSE))
		popViewport()
	}, names(data[vars]), cat, 1:ncol(data[vars]))
	invisible()
	
}