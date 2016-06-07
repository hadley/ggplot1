\name{scmanual}
\alias{scmanual}
\title{Scale: manual}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Create a manual scale
}
\usage{scmanual(plot = .PLOT, variable="x", name="", breaks=NULL, labels=as.character(breaks), grob=function(x) grob_point(x, unique=FALSE))}
\arguments{
\item{plot}{plot object to add scale to}
\item{variable}{variable to scale}
\item{name}{name of the scale (used in the legend)}
\item{breaks}{numeric vector of break points}
\item{labels}{character vector of break labels}
\item{grob}{grob function to use when drawing legend}
}

\details{This scale function allows you complete control over the
scale.

Supply labels and breaks to produce a legend.}
\seealso{\code{\link{ggfluctuation}} for a use}
\examples{}
\keyword{hplot}
