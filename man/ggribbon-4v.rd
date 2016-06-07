\name{ggribbon}
\alias{ggribbon}
\title{Grob function: ribbon}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Add a ribbon to the plot
}
\usage{ggribbon(plot = .PLOT, aesthetics=list(), ..., data=NULL)}
\arguments{
\item{plot}{the plot object to modify}
\item{aesthetics}{named list of aesthetic mappings, see details for more information}
\item{...}{other options, see details for more information}
\item{data}{data source, if not specified the plot default will be used}
}

\details{Aesthetic mappings that this grob function understands:

\itemize{
\item \code{x}:x position (required)
\item \code{upper}: position of upper edge of ribbon  (required)
\item \code{lower}: position of lower edge of ribbon (required)
\item \code{id}:identifier variable used to break up into multiple paths
\item \code{colour}:line colour (see \code{\link{sccolour}})
}

These can be specified in the plot defaults (see \code{\link{ggplot}}) or
in the \code{aesthetics} argument.  If you want to modify the position
of the points or any axis options, you will need to add a position scale to
the plot.  These functions start with \code{ps}, eg.
\code{\link{pscontinuous}} or \code{\link{pscategorical}}

Other options:

\itemize{
\item none
}}

\examples{mry <- do.call(rbind, by(movies, round(movies$rating), function(df) { 
nums <- tapply(df$length, df$year, length)
data.frame(rating=round(df$rating[1]), year = as.numeric(names(nums)), number=as.vector(nums))
}))
p <- ggplot(mry, aesthetics = list(x=year, y=number, id=rating))
ggribbon(p, aes=list(upper=number+5, lower=number-5), fill="white", colour=NA)
ggribbon(p, aes=list(y=number, plus=5, minus=-5), fill="white", colour=NA)
ggribbon(p, aes=list(upper=number*1.1, lower=number*0.9), fill="white", colour=NA)
ggribbon(p, aes=list(upper=number+5, lower=number-5), fill="pink")
ggribbon(p, aes=list(upper=number+5, lower=number-5, fill=rating), colour=NA)
scfillgradient(ggribbon(p, aes=list(upper=number+5, lower=number-5, fill=rating), colour=NA), midpoint=5, low="red", high="darkgreen")}
\keyword{hplot}
