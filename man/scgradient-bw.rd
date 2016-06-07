\name{scgradient}
\alias{scgradient}
\alias{scfillgradient}
\title{Scale: colour gradient}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Scale a continuous variable along a colour gradient.
}
\usage{scgradient(plot = .PLOT, name="", low='red', mid='white', high="black", midpoint=0, range=c(NA,NA))}
\arguments{
\item{plot}{plot object to add scale to}
\item{name}{name of the scale (used in the legend)}
\item{low}{colour at low end of scale}
\item{mid}{colour at middle of scale}
\item{high}{colour at top of scale}
\item{midpoint}{definition of midpoint}
\item{range}{range to scale data to}
}

\details{This scale creates a continuous colour gradient from the
low colour to the mid colour to high colour, as defined in the
arguments.}
\seealso{\code{\link{sccolour}}}
\examples{p <- scgradient(ggplot(movies, aes=list(x=mpaa, y=rating)))
ggjitter(p, list(colour=rating))
ggjitter(p, list(colour=length))
p <- ggjitter(p, list(colour=rating))
scgradient(p, low="yellow")
scgradient(p, high="green", midpoint=5)}
\keyword{hplot}
