\name{ggpoint}
\alias{ggpoint}
\title{Grob function: point}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Add points to a plot
}
\usage{ggpoint(plot = .PLOT, aesthetics=list(), ..., data=NULL)}
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
\item \code{size}:size of the point, in mm (see \code{\link{scsize})}
\item \code{shape}:shape of the glyph used to draw the point (see \code{\link{scshape})}
\item \code{colour}:point colour (see \code{\link{sccolour})}
}

These can be specified in the plot defaults (see \code{\link{ggplot}}) or
in the \code{aesthetics} argument.  If you want to modify the position
of the points or any axis options, you will need to add a position scale to
the plot.  These functions start with \code{ps}, eg.
\code{\link{pscontinuous}} or \code{\link{pscategorical}}

Other options:

\itemize{
\item \code{unique}:if \code{TRUE, draw at most one point at each unique location}
}}

\examples{p <- ggplot(mtcars, aesthetics=list(x=wt, y=mpg))
ggpoint(p)
ggpoint(p, list(colour=cyl))
ggpoint(p, list(blahbalh=cyl)) #unknown aesthetics are ignored
ggpoint(p, list(shape=cyl))
ggpoint(p, list(shape=cyl, colour=cyl))
ggpoint(p, list(size=mpg))
ggpoint(p, list(size=mpg/wt))
ggpoint(p, list(x=cyl, colour=cyl))
p <- ggplot(mtcars)
ggpoint(p, aesthetics=list(x=wt, y=mpg))}
\keyword{hplot}
