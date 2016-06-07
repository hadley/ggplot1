\name{ggtile}
\alias{ggtile}
\title{Grob function: tile}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Add tiles to a plot
}
\usage{ggtile(plot = .PLOT, aesthetics=list(), ..., data=NULL)}
\arguments{
\item{plot}{the plot object to modify}
\item{aesthetics}{named list of aesthetic mappings, see details for more information}
\item{...}{other options, see details for more information}
\item{data}{data source, if not specified the plot default will be used}
}

\details{The tile grob will tile the plot surface as densly as possible, assuming
that every tile is the same size.  It is similar to \code{\link{levelplot}}
or \code{\link{image}}.

Aesthetic mappings that this grob function understands:

\itemize{
\item \code{x}:x position (required)
\item \code{y}:y position (required)
\item \code{width}:width of the rectangle
\item \code{height}:height of the rectangle
\item \code{fill}:fill colour (see \code{\link{sccolour})}
}

These can be specified in the plot defaults (see \code{\link{ggplot}}) or
in the \code{aesthetics} argument.  If you want to modify the position
of the points or any axis options, you will need to add a position scale to
the plot.  These functions start with \code{ps}, eg.
\code{\link{pscontinuous}} or \code{\link{pscategorical}}

Other options:

\itemize{
\item none
}}
\seealso{\code{\link{ggrect}}, \code{\link{resolution}}}
\examples{pp <- function (n,r=4) {
x <- seq(-r*pi, r*pi, len=n)
df <- expand.grid(x=x, y=x)
df$r <- sqrt(df$x^2 + df$y^2)
df$z <- cos(df$r^2)*exp(-df$r/6)
df
}
p <- ggplot(pp(20), aes=list(x=x,y=y))
ggtile(p) #pretty useless!
ggtile(p, list(fill=z))
ggtile(p, list(height=abs(z), width=abs(z)))
ggtile(ggplot(pp(100), aes=list(x=x,y=y,fill=z)))
ggtile(ggplot(pp(100, r=2), aes=list(x=x,y=y,fill=z)))
p <- ggplot(pp(20)[sample(20*20, size=200),], aes=list(x=x,y=y,fill=z))
ggtile(p)}
\keyword{hplot}
