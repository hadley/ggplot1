\name{scsize}
\alias{scsize}
\title{Scale: size}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Linearly map size to a variable.
}
\usage{scsize(plot = .PLOT, name="", to=c(0.8, 5))}
\arguments{
\item{plot}{plot to add scale to.}
\item{name}{name of the scale (used in the legend)}
\item{to}{size range in mm (numeric vector, length 2)}
}

\details{The mapping between size and the original variable value is not
linear, but square rooted.  This is because the human brain tends to
percieve area rather than radius.

You can manipulate the range of the result by modifying the \code{to}
argument.}

\examples{p <- ggplot(mtcars, aes=list(x=mpg, y=hp))
ggpoint(p)
ggpoint(p, list(size=wt))
scsize(ggpoint(p, list(size=wt)), c(1,10))
scsize(ggpoint(p, list(size=sqrt(wt))), c(1,5))}
\keyword{hplot}
