\name{ggpolygon}
\alias{ggpolygon}
\title{Grob function: polygon}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Add polygons to a plot
}
\usage{ggpolygon(plot = .PLOT, aesthetics=list(), ..., data=NULL)}
\arguments{
\item{plot}{the plot object to modify}
\item{aesthetics}{named list of aesthetic mappings, see details for more information}
\item{...}{other options, see details for more information}
\item{data}{data source, if not specified the plot default will be used}
}

\details{Aesthetic mappings that this grob function understands:

\itemize{
\item \code{x}:x position (required)
\item \code{y}:y position (required)
\item \code{id}:identifier variable used to break up into multiple polygons
\item \code{size}:size of the outline, in mm (see \code{\link{scsize})}
\item \code{colour}:outline colour (see \code{\link{sccolour})}
\item \code{fill}:internal colour (see \code{\link{sccolour})}
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

\examples{}
\keyword{hplot}
