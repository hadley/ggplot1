\name{gg_add}
\alias{gg_add}
\title{gg add}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Convenience method to make writing gg\_XXXX functions easier.
}
\usage{gg_add(map, plot, aesthetics=list(), ..., data=NULL)}
\arguments{
\item{map}{type of grob mapping to add}
\item{plot}{plot object}
\item{aesthetics}{list of aesthetic mappings}
\item{...}{parameters passed to grob function}
\item{data}{data frame}
}
\value{modified plot object}
\details{Will automatically add scales if needed.}

\examples{}
\keyword{hplot}
\keyword{internal}
