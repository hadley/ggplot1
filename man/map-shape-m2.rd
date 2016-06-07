\name{map_shape}
\alias{map_shape}
\title{Aesthetic mapping: glyph shape}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Map values to point shapes.
}
\usage{map_shape(x, solid=FALSE)}
\arguments{
\item{x}{data vector}
\item{solid}{use solid points?}
}

\details{If x is not a factor, will be converted to one by \code{\link{chop_auto}}.
Can display at most 6 different categories.}
\seealso{\url{http://www.public.iastate.edu/~dicook/scgn/v141.pdf}}
\examples{}
\keyword{manip}
