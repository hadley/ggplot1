\name{ggquantile}
\alias{ggquantile}
\title{Grob function: quantiles}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Add quantile lines from a quantile regression
}
\usage{ggquantile(plot = .PLOT, aesthetics=list(), ..., data=NULL)}
\arguments{
\item{plot}{the plot object to modify}
\item{aesthetics}{named list of aesthetic mappings, see details for more information}
\item{...}{other options, see details for more information}
\item{data}{data source, if not specified the plot default will be used}
}

\details{This can be used a continuous analogue of a boxplot (see \code{\link{grob_boxplot}})
Lines will be automatically sized to reflect their distance from the median.

Aesthetic mappings that this grob function understands:

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
\item \code{quantiles}:quantiles to display
\item \code{formula}:formula to use in quantile regression
}}
\seealso{\code{\link[quantreg]{rq}} for the code used to fit the quantile regression}
\examples{\dontrun{
m <- ggplot(movies, aesthetics=list(y=length, x=rating))
ggquantile(m)
}}
\keyword{hplot}
