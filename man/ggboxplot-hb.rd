\name{ggboxplot}
\alias{ggboxplot}
\title{Grob function: boxplot}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Add box and whiskers
}
\usage{ggboxplot(plot = .PLOT, aesthetics=list(), ..., data=NULL)}
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
\item \code{weight}: observation weights
}

These can be specified in the plot defaults (see \code{\link{ggplot}}) or
in the \code{aesthetics} argument.  If you want to modify the position
of the points or any axis options, you will need to add a position scale to
the plot.  These functions start with \code{ps}, eg.
\code{\link{pscontinuous}} or \code{\link{pscategorical}}

Other options:

\itemize{
\item \code{breaks}:how to break up the x axis (only used if not already a factor)
\item \code{orientation}: whether boxplots should be horizontal or vertical.
If missing will automatically decide based on which variable is a factor.
\item other arguments passed \code{\link{boxplot}}
}}
\seealso{\code{\link{ggquantile}} for a continuous analogue of the boxplot}
\examples{p <- ggplot(mtcars, aesthetics=list(y=mpg, x=factor(cyl)))
p2 <- ggplot(mtcars, aesthetics=list(x=mpg, y=factor(cyl)))
ggpoint(p)
ggboxplot(p)
ggboxplot(p2)
ggboxplot(p, fill="pink", colour="green")
ggpoint(ggboxplot(p))
ggboxplot(p)}
\keyword{hplot}
