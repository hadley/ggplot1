\name{ggarea}
\alias{ggarea}
\title{Grob function: area}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Add an filled area to a plot.
}
\usage{ggarea(plot = .PLOT, aesthetics=list(), ..., data=NULL)}
\arguments{
\item{plot}{x positions}
\item{aesthetics}{y positions}
\item{...}{id variable used to separate observations into different areas}
\item{data}{colour}
\item{}{pattern}
\item{}{...}
}

\details{Aesthetic mappings that this grob function understands:

\itemize{
\item \code{x}:x position (required)
\item \code{y}:y position (required)
\item \code{id}:identifier variable used to break up into multiple paths
\item \code{colour}:line colour (see \code{\link{sccolour}})
\item \code{fill}:fill colour (see \code{\link{sccolour}})
\item \code{linetype}:line style/type (see \code{\link{sclinetype}})
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

\examples{huron <- data.frame(year = 1875:1972, level = as.vector(LakeHuron))
p <- ggplot(huron, aes=list(y=level, x=year))
ggarea(p)
ggarea(p, colour="black")
ggline(ggarea(p)) # better
qplot(year, level, data=huron, type=c("area", "line"))
ggarea(p, fill=alpha("grey80", 0.5))
pscontinuous(ggarea(p), "y", range=c(0,NA))}
\keyword{hplot}
\keyword{internal}
