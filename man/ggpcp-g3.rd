\name{ggpcp}
\alias{ggpcp}
\title{Parallel coordinates plot.}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Generate a plot ``template'' for a paralell coordinates plot.
}
\usage{ggpcp(data, vars=names(data), scale="range", ...)}
\arguments{
\item{data}{data frame}
\item{vars}{variables to include in parallel coordinates plot}
\item{scale}{scaling function, one of "range", "var" or "I"}
\item{...}{other arguments passed on plot creation}
}

\details{One way to think about a parallel coordinates plot, is as plotting
the data after it has transformation been transformed to gain a new
variable.  This function does this using \code{\link[reshape]{melt}}.

This gives us enormous flexibility as we have separated out the
type of drawing (lines by tradition) and can now use any of the existing
grob functions.  In particular this makes it very easy to create parallel
boxplots, as shown in the example.}

\examples{ggline(ggpcp(mtcars))
ggline(ggpcp(mtcars, scale="var"))
ggline(ggpcp(mtcars, vars=names(mtcars)[3:6], formula= . ~cyl, scale="I"))
ggboxplot(ggpcp(mtcars, scale="I"))
ggline(ggpcp(mtcars, vars=names(mtcars[2:6])))
p <- ggpcp(mtcars, vars=names(mtcars[2:6]), formula=.~vs)
ggline(p)
ggline(p, aes=list(colour=mpg)) }
\keyword{hplot}
