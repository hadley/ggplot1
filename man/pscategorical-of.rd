\name{pscategorical}
\alias{pscategorical}
\title{Position: categorical}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Add a categorical position scale to the plot
}
\usage{pscategorical(plot = .PLOT, variable="x", name="", expand=c(0.01, 0.6))}
\arguments{
\item{plot}{ggplot object}
\item{variable}{axis ("x" or "y")}
\item{name}{name of the scale (used in the legend)}
\item{expand}{expansion vector (numeric vector, multiplicative and additive expansion).  Defaults to adding 0.6 on either end of the scale.}
}

\details{A categorical scale converts a factor into a numerical representation
very simply: by using \code{as.numeric}.  This means that levels
will be placed a integer locations in the same order that they
appear in the levels of the factor (see \code{\link{levels}}).

If you want to reorder (or combine) categories, currently the best way
to do this is to modify the original factors.  In a future version of ggplot
I will probably expand the categorical scale so that you can do that here.

This scale is added to the plot automatically when you use a categorical
variable in the x or y aesthetics.  You shouldn't need to to call this function
unless (for some reason) you want to change the expansion factor.}

\examples{p <- ggpoint(ggplot(mtcars, aesthetics=list(x=cyl, y=mpg)))
pscategorical(p, "x") # no change, because already categorical
pscategorical(p, "y") # chops into discrete segments}
\keyword{hplot}
