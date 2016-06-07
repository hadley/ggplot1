\name{mosaicdata}
\alias{mosaicdata}
\alias{plotmosaicdata}
\title{Mosaic data}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Construct a data frame for producing a mosaic plot
}
\usage{mosaicdata(df, direction, offset, xrange=c(0,1), yrange=c(0,1))}
\arguments{
\item{df}{data frame, with values in last column}
\item{direction}{character vector of direction ("v" or "h") to split in}
\item{offset}{vector of offsets to use}
\item{xrange}{xrange}
\item{yrange}{yrange}
}

\details{Take a data frame, with last column value and then
recursively create a data frame that reflects the position of each cell}

\examples{}
\keyword{hplot}
\keyword{internal}
