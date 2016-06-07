\name{plot_add}
\alias{plot_add}
\title{Plot add.}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Add graphical objects using specific mapping.
}
\usage{plot_add(plot=.PLOT, data=NULL, map="point", aesthetics=list(), ...)}
\arguments{
\item{plot}{plot object}
\item{data}{data to use}
\item{map}{how to map data into graphics object}
\item{aesthetics}{arguments passed down to mapping object specifying (eg.) aesthetics to use}
\item{...}{}
}

\details{This is the powerhouse function that you use to actually display
stuff on your plot.

You should really keep track of the new plot object that is created
by this function, but if you're lazy and don't want to, it automatically
stores the result in the "global" variable \code{.PLOT}}

\examples{}
\keyword{hplot}
\keyword{internal}
