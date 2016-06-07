\name{ggvline}
\alias{ggvline}
\title{Grob function: vline}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Add vertical line(s) to a plot
}
\usage{ggvline(plot = .PLOT, aesthetics=list(), ..., data=NULL)}
\arguments{
\item{plot}{the plot object to modify}
\item{aesthetics}{named list of aesthetic mappings, see details for more information}
\item{...}{other options, see details for more information}
\item{data}{data source, if not specified the plot default will be used}
}

\details{Aesthetic mappings that this grob function understands:

\itemize{
\item none
}

Other options:

\itemize{
\item \code{position}: vertical position(s) to draw lines
\item \code{colour}: line colour
\item \code{size}: line thickness
\item \code{linetype}: line type
\item \code{range}: x (or y if slope infinite) range to draw the line.  This is sometimes necessary because ggplot isn't smart enough to calculate the entire range of the data
}}

\examples{p <- ggplot(mtcars, aesthetics=list(x = wt, y=mpg))
ggvline(ggpoint(p), position=mean(mtcars$wt), size=2)}
\keyword{hplot}
