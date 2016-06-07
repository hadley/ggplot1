\name{"update<-.scales"}
\alias{update<-.scales}
\title{Update scales.}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
This function updates an entire set of scales with data.
}
\usage{"update<-.scales"(x, value)}
\arguments{
\item{x}{scales object}
\item{value}{data}
}

\details{Update needs to be able to deal with the multiple possible
data formats it could recieve:

* a single data frame (representing one panel from one grob function)
* a matrix of data frames (all panels from a grob function)
* a list of matrix of data frames (all panels from all grob functions)}

\examples{}
\keyword{hplot}
\keyword{internal}
