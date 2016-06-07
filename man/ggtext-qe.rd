\name{ggtext}
\alias{ggtext}
\title{Grob function: text}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Add text to a plot
}
\usage{ggtext(plot = .PLOT, aesthetics=list(), ..., data=NULL)}
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
\item \code{label}:text label to display
\item \code{size}:size of the text, as a multiple of the default size, (see \code{\link{scsize})}
\item \code{rotation}:angle, in degrees, of text label
\item \code{colour}:text colour (see \code{\link{sccolour})}
}

These can be specified in the plot defaults (see \code{\link{ggplot}}) or
in the \code{aesthetics} argument.  If you want to modify the position
of the points or any axis options, you will need to add a position scale to
the plot.  These functions start with \code{ps}, eg.
\code{\link{pscontinuous}} or \code{\link{pscategorical}}

Other options:

\itemize{
\item \code{justification}:justification of the text relative to its (x, y) location, see \code{\link{textGrob} for more details}
}}

\examples{p <- ggplot(mtcars, aesthetics=list(x=wt, y=mpg, labels = rownames(mtcars)))
ggtext(p)
ggtext(p, list(size=wt))
scsize(ggtext(p, list(size=wt)), c(0.5, 1.5))
ggtext(p, list(colour=cyl))}
\keyword{hplot}
