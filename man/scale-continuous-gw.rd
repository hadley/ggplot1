\name{scale_continuous}
\alias{scale_continuous}
\alias{trans_log10}
\alias{trans_log2}
\alias{trans_sqrt}
\alias{trans_inverse}
\alias{trans_none}
\title{Scale: general continuous (incl. transformations)}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Transform scale with a monotone function
}
\usage{scale_continuous(variable="x", name="", transform=trans_none, range=c(NA,NA), expand=c(0, 0), breaks=NULL, to=NULL, ...)}
\arguments{
\item{variable}{variable name}
\item{name}{name of the scale (used in the legend)}
\item{transform}{vector of length two, first element the transforming function and the second its inverse}
\item{range}{range of values to display on guides}
\item{expand}{expansion factor for guides}
\item{breaks}{manually specified breaks to use}
\item{to}{if non-null, scale variable to this range after transformation}
\item{...}{}
}
\value{modified plot object}
\details{You shouldn't call this function yourself.  Please use one of:

\item \code{\link{scsize}}
\item \code{\link{scgradient}}
\item \code{\link{pscontinuous}}

The continuous scale is the most complicated of the scale functions
as it accepts so many options.

Making pretty axis labels for transformed data isn't a trivial
problem.  Here I use a simple heuristic, and compute pretty breaks
on the transformed range and then back transform to the original
scale.

There are a few common transformation vectors defined: \code{trans_log10},
\code{trans_log2}, \code{trans_sqrt}, \code{trans_inverse}}

\examples{}
\keyword{hplot}
\keyword{internal}
