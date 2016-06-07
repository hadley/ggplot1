\name{ggjitter}
\alias{ggjitter}
\title{Grob function: jittered points}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Add jittered points to a plot
}
\usage{ggjitter(plot = .PLOT, aesthetics=list(), ..., data=NULL)}
\arguments{
\item{plot}{the plot object to modify}
\item{aesthetics}{named list of aesthetic mappings, see details for more information}
\item{...}{other options, see details for more information}
\item{data}{data source, if not specified the plot default will be used}
}

\details{This is useful when plotting points with a categorical axis so to
avoid overplotting.

Aesthetic mappings that this grob function understands:

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
\item \code{xjitter}:degree of jitter in x direction, see \code{\link{jitter} for details, defaults to 1 if the x variable is a factor, 0 otherwise}
\item \code{yjitter}:degree of jitter in y direction, see \code{\link{jitter} for details, defaults to 1 if the y variable is a factor, 0 otherwise}
}}

\examples{p <- ggplot(movies, aes=list(x=mpaa, y=rating))
ggjitter(p)
ggjitter(ggboxplot(p))
ggjitter(ggboxplot(p), xjitter=2)
ggjitter(ggboxplot(p), yjitter=1)
p <- ggplot(movies, aes=list(x=mpaa, y=factor(Action)))
ggjitter(p)}
\keyword{hplot}
