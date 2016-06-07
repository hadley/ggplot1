# Mosaic plot:
#   ggplot(df, aes=list(m1 = a, m2 = bm, m3=s))
#  + psmosaic(p, direction, offset, range)
# 
# -> ggplot(df, aes(mosaic(list(a, bm, s), direction, offset, range=n)))
# 
#  + ggrect(p)
# 
# Ternary plot:
#   ggplot(df, aes=list(a=a, b=b, c=c))
#  + psternary(p) # check/force add up to one
#  + ggpoint(p)
# 
# Glyph plot:
# 	ggplot(df, aes=list(x=x, y=y)) 
#  ggglyph(p, aes=list(g1=a, g2=b, gc=3), type="star", size)
# 
# 

# Mosaic plot
# 
# @keyword internal 
#X library(grid)
#X tt <- as.data.frame(Titanic)
#X mdf(~ Class, tt)  # counts
#X mdf(Freq ~ Class, tt) # with a weighting variable
#X mdf(Freq ~ Class + Sex + Age, tt)
#X mdf(Freq ~ Class + Sex + Age, tt, direction=c("v","h","v"))
mdf <- function(formula=~., df, direction, offset, xrange=c(0,1), yrange=c(0,1)) {
  df <- as.data.frame(xtabs(formula, df))
  n <- sum(df$Freqs)

  data <- mosaicdata(df, direction, offset, xrange, yrange)
  plotmosaicdata(data)
  data
}


# Mosaic data
# Construct a data frame for producing a mosaic plot
# 
# Take a data frame, with last column value and then
# recursively create a data frame that reflects the position of each cell
#
# @arguments data frame, with values in last column
# @arguments character vector of direction ("v" or "h") to split in
# @arguments vector of offsets to use
# @arguments xrange
# @arguments yrange
# @keyword hplot 
# @keyword internal 
# @alias plotmosaicdata
mosaicdata <- function(df, direction, offset, xrange=c(0,1), yrange=c(0,1)) {
  if (missing(direction)) direction <- c(rep("v", ncol(df) - 2), "h")
  if (missing(offset)) offset <- 0.02 * 0.9 ^ (1:(ncol(df)-1) - 1)
  
  splitcol <- df[, 1]
  valuecol <- df[, ncol(df)]
  
  range <- if (direction[1] == "v") yrange else xrange
  
  nbreaks <- length(unique(splitcol)) - 1
  offsets <- (offset[1]*(0:nbreaks)) * sum(valuecol)

  cs <- cumsum(tapply(valuecol, splitcol, sum))
  
  breaks <- matrix(c(
    c(0, cs)[1:(nbreaks+1)] + offsets,
    cs + offsets
  ), ncol=2)
  breaks <- rescale(breaks, to=range)
  
  if (ncol(df) == 2) {
    return(switch(direction, 
      v = data.frame(df, x0=xrange[1], x1=xrange[2], y0=breaks[,1], y1=breaks[,2]),
      h = data.frame(df, y0=yrange[1], y1=yrange[2], x0=breaks[,1], x1=breaks[,2])
    ))
  }
  
  splits <- split(df, splitcol)
  
  results <- lapply(1:length(splits), function(i) {
    switch(direction[1], 
      h = mosaicdata(splits[[i]][, -1], direction[-1], offset[-1], xrange=breaks[i,], yrange=yrange),
      v = mosaicdata(splits[[i]][, -1], direction[-1], offset[-1], yrange=breaks[i,], xrange=xrange)
    )
  })
  cbind(df[,1, drop=FALSE], do.call(rbind, results))
  
  
}

plotmosaicdata <- function(df) {
  grid.newpage()
  pushViewport(dataViewport(xData=c(df$x0, df$x1), yData=c(df$y0, df$y1)))
  
  height <- df$y0 - df$y1
  width <- df$x0 - df$x1
  
  grid.draw(grob_rect(list(x=df$x0, y=df$y0, width=width, height=height, fill="white", colour="black"), justification=c("right","top")))
}