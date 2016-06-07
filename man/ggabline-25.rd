\name{ggabline}
\alias{ggabline}
\title{Grob function: abline}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Add line specified by slope and intercept to a plot
}
\usage{ggabline(plot = .PLOT, aesthetics=list(), ..., data=NULL)}
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
\item \code{intercept}:intercept(s) of line
\item \code{slope}:slope(s) of line, set to Inf
\item \code{colour}:line colour
\item \code{size}:line thickness
\item \code{linetype}:line type
\item \code{range}: x (or y if slope infinite) range to draw the line.  This is sometimes necessary because ggplot isn't smart enough to calculate the entire range of the data
}}

\examples{p <- ggplot(mtcars, aesthetics=list(x = wt, y=mpg))
ggabline(ggpoint(p), intercept=30, slope=-5)
ggabline(ggpoint(p), intercept=c(30,40,50), slope=-5)
ggsmooth(ggpoint(p), method=lm, formula=y~x) }
\keyword{hplot}
