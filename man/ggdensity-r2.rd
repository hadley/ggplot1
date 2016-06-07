\name{ggdensity}
\alias{ggdensity}
\title{Grob function: 1d density}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Display a smooth density estimate.
}
\usage{ggdensity(plot = .PLOT, aesthetics=list(), ..., data=NULL)}
\arguments{
\item{plot}{the plot object to modify}
\item{aesthetics}{named list of aesthetic mappings, see details for more information}
\item{...}{other options, see details for more information}
\item{data}{data source, if not specified the plot default will be used}
}

\details{Aesthetic mappings that this grob function understands:

\itemize{
\item \code{x}:x position (required)
\item \code{weight}: observation weights
}

These can be specified in the plot defaults (see \code{\link{ggplot}}) or
in the \code{aesthetics} argument.  If you want to modify the position
of the points or any axis options, you will need to add a position scale to
the plot.  These functions start with \code{ps}, eg.
\code{\link{pscontinuous}} or \code{\link{pscategorical}}

Other options:

\itemize{
\item \code{adjust}: see \code{\link{density}}
for details
\item \code{kernel}: kernel used for density estimation, see \code{\link{density}}
for details
\item other aesthetic properties passed on to \code{\link{ggline}}
\item \code{weight}: observation weights
}}
\seealso{\code{\link{gghistogram}}, \code{\link{density}}}
\examples{m <- ggplot(movies, aesthetics=list(x=rating))
ggdensity(m)
qplot(length, data=movies, type="density")
qplot(length, data=movies, type="density", weight=rating)
qplot(length, data=movies, type="density", weight=rating/sum(rating))
qplot(length, data=movies, type="density", log="x")
qplot(log(length), data=movies, type="density")
m <- ggplot(movies, Action ~ Comedy, aesthetics=list(x=rating), margins=TRUE)
ggdensity(m)
ggdensity(m, scale="freq")
ggdensity(m, colour="darkgreen", size=5) }
\keyword{hplot}
