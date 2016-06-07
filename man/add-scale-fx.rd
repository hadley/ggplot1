\name{add_scale}
\alias{add_scale}
\title{Add scale}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Add (one) scale to the plot
}
\usage{add_scale(p = .PLOT, scale)}
\arguments{
\item{p}{plot object, if not specified will use current plot}
\item{scale}{scale to add, see \code{\link{scales}} for possible options}
}

\details{You shouldn't need to call this function yourself as all
scale objects provide a convenient method to do so automatically.  These
are the functions that start with sc.}

\examples{p <- ggplot(movies, aesthetics=list(x=length, y=rating))
add_scale(ggpoint(p), position_continuous('x', range=c(80,100)))}
\keyword{hplot}
\keyword{internal}
