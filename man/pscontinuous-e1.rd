\name{pscontinuous}
\alias{pscontinuous}
\title{Position: continuous}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Add a continuous position scale to the plot
}
\usage{pscontinuous(plot = .PLOT, variable="x", name="", transform=trans_none, range=c(NA,NA), expand=c(0.05, 0), breaks=NULL)}
\arguments{
\item{plot}{plot}
\item{variable}{variable ("x" or "y")}
\item{name}{name of the scale (used in the legend)}
\item{transform}{transform function and it's inverse in a vector}
\item{range}{range, or leave missing to automatically determine}
\item{expand}{expansion vector (numeric vector, multiplicative and additive expansion)}
\item{breaks}{set breaks manually}
}
\value{modified plot object}
\details{There are a few useful things that you can do with \code{pscontinuous}:

\item set plot limits explicitly (with \code{range})
\item transform the scale (with \code{transform})
\item explicitly set where the axis labels (and grid lines) should appear (with \code{breaks})

Note, that if you explicitly set the axis range, you may want to use
\code{\link{expand_range}} to add a little extra room on each side.

When transforming an axes, you need to supply the transforming function
and it's inverse (used to create pretty axis labels).  I have created
a few common ones for you:

\item \code{trans_log10}: log base 10
\item \code{trans_log2}: log base 2
\item \code{trans_inverse}: inverse
\item \code{trans_sqrt}: square root}

\examples{p <- ggpoint(ggplot(mtcars, aesthetics=list(x=mpg, y=disp)))
pscontinuous(p, "x", range=c(20,30))
pscontinuous(p, "y", breaks=seq(100, 400, 50)) 
pscontinuous(p, "y", transform=trans_inverse)
pscontinuous(p, "x", transform=trans_sqrt)
pscontinuous(p, "x", transform=trans_log10)
pscontinuous(p, "x", transform=trans_log10, breaks=seq(10,30, 5))}
\keyword{hplot}
