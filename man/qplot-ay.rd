\name{qplot}
\alias{qplot}
\title{Quick plot.}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Quick plot is a convenient wrapper function for creating simple ggplot plot objects.
}
\usage{qplot(x, y = NULL, data, facets = . ~ ., margins=FALSE, types = "point", colour = NULL, size = NULL, shape = NULL, linetype = NULL, fill = NULL, id=NULL, weight=NULL, xlim = c(NA, NA), ylim = c(NA, NA), log = "", main = NULL, xlab = deparse(substitute(x)), ylab = deparse(substitute(y)), add=NULL, ...)}
\arguments{
\item{x}{x values}
\item{y}{y values}
\item{data}{data frame to use (optional)}
\item{facets}{facetting formula to use}
\item{margins}{grob type(s) to draw (can be a vector of multiple names)}
\item{types}{vector to use for colours}
\item{colour}{vector to use for sizes}
\item{size}{vector to use for shapes}
\item{shape}{vector to use for line type}
\item{linetype}{vector to use for fill colour}
\item{fill}{vector to use for ids}
\item{id}{vector to use for weights}
\item{weight}{limits for x axis (defaults to range of data)}
\item{xlim}{limits for y axis (defaults to range of data)}
\item{ylim}{which variables to log transform ("x", "y", or "xy")}
\item{log}{character vector or expression for plot title}
\item{main}{character vector or expression for x axis label}
\item{xlab}{character vector or expression for y axis label}
\item{ylab}{if specified, build on top of this ggplot, rather than creating a new one}
\item{add}{other arguments passed on to the grob functions}
\item{...}{}
}

\details{FIXME: describe how to get more information
FIXME: add more examples

\code{qplot} provides a quick way to create simple plots.}

\examples{qplot(LETTERS[1:5], 1:5, type="rect", main="Blah", xlab="Hi")
qplot(LETTERS[1:5], 1:5, type=c("tile", "point"), main="Blah", xlab="Hi", ylim=c(0,10), col=1:5)
qplot(wt, mpg, data=mtcars, col=cyl, shape=cyl, size=wt)}
\keyword{hplot}
