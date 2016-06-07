\name{mdf}
\alias{mdf}
\title{Mosaic plot}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{

}
\usage{mdf(formula=~., df, direction, offset, xrange=c(0,1), yrange=c(0,1))}
\arguments{
\item{formula}{}
\item{df}{}
\item{direction}{}
\item{offset}{}
\item{xrange}{}
\item{yrange}{}
}

\details{}

\examples{library(grid)
tt <- as.data.frame(Titanic)
mdf(~ Class, tt)  # counts
mdf(Freq ~ Class, tt) # with a weighting variable
mdf(Freq ~ Class + Sex + Age, tt)
mdf(Freq ~ Class + Sex + Age, tt, direction=c("v","h","v"))}
\keyword{internal}
