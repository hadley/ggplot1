\name{gg2density}
\alias{gg2density}
\title{Grob function: 2d density}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Perform a 2D kernel density estimatation using \code{\link{kde2d}} and
}
\usage{gg2density(plot = .PLOT, aesthetics=list(), ..., data=NULL)}
\arguments{
\item{plot}{the plot object to modify}
\item{aesthetics}{named list of aesthetic mappings, see details for more information}
\item{...}{other options, see details for more information}
\item{data}{data source, if not specified the plot default will be used}
}

\details{This is another function useful for dealing with overplotting.

Aesthetic mappings that this grob function understands:

\itemize{
\item \code{x}:x position (required)
\item \code{y}:y position (required)
}

These can be specified in the plot defaults (see \code{\link{ggplot}}) or
in the \code{aesthetics} argument.  If you want to modify the position
of the points or any axis options, you will need to add a position scale to
the plot.  These functions start with \code{ps}, eg.
\code{\link{pscontinuous}} or \code{\link{pscategorical}}

Other options:

\itemize{
\item passed to \code{\link{ggcontour}}, see it for details
}}
\seealso{\code{\link{ggcontour}} for another way of dealing with over plotting}
\examples{m <- ggpoint(ggplot(movies, aesthetics=list(y=length, x=rating)))
dens <- MASS::kde2d(movies$rating, movies$length)
densdf <- data.frame(expand.grid(rating = dens$x, length = dens$y), z=as.vector(dens$z))
ggcontour(m, list(z=z), data=densdf)
gg2density(m)
# they don't look the same due to scaling effects on kde2d}
\keyword{hplot}
