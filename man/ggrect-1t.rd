\name{ggrect}
\alias{ggrect}
\title{Grob function: rectangle}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Add rectangles to a plot
}
\usage{ggrect(plot = .PLOT, aesthetics=list(), ..., data=NULL)}
\arguments{
\item{plot}{the plot object to modify}
\item{aesthetics}{named list of aesthetic mappings, see details for more information}
\item{...}{other options, see details for more information}
\item{data}{data source, if not specified the plot default will be used}
}

\details{This grob provides the basic functionality required by
\code{\link{ggbar}} and \code{\link{ggtile}}.  You should probably
not call it yourself

Aesthetic mappings that this grob function understands:

\itemize{
\item \code{x}:x position (required)
\item \code{y}:y position (required)
\item \code{width}:width of the rectangle (required)
\item \code{height}:height of the rectangle (required)
\item \code{fill}:fill colour (see \code{\link{sccolour})}
}

These can be specified in the plot defaults (see \code{\link{ggplot}}) or
in the \code{aesthetics} argument.  If you want to modify the position
of the points or any axis options, you will need to add a position scale to
the plot.  These functions start with \code{ps}, eg.
\code{\link{pscontinuous}} or \code{\link{pscategorical}}

Other options:

\itemize{
\item \code{justification}:justification of the bar relative to its (x, y) location, see \code{\link{rectGrob} for more details}
}}
\seealso{\code{\link{ggbar}}, \code{\link{ggtile}}}
\examples{}
\keyword{hplot}
