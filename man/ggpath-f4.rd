\name{ggpath}
\alias{ggpath}
\title{Grob function: path}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Add a path (a line between points in the order that they appear in the dataset) to the plot
}
\usage{ggpath(plot = .PLOT, aesthetics=list(), ..., data=NULL)}
\arguments{
\item{plot}{the plot object to modify}
\item{aesthetics}{named list of aesthetic mappings, see details for more information}
\item{...}{other options, see details for more information}
\item{data}{data source, if not specified the plot default will be used}
}

\details{Aesthetic mappings that this grob function understands:

\itemize{
\item \code{x}:x position (required)
\item \code{y}:y position (required)
\item \code{id}:identifier variable used to break up into multiple paths
\item \code{size}:size of the line, in mm (see \code{\link{scsize}})
\item \code{colour}:line colour (see \code{\link{sccolour}})
\item \code{linetype}:line style/type (see \code{\link{sclinetype}})
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

\examples{myear <- do.call(rbind, by(movies, movies$year, function(df) data.frame(year=df$year[1], mean.length = mean(df$length), mean.rating=mean(df$rating))))
p <- ggplot(myear, aesthetics=list(x=mean.length, y=mean.rating))
ggpath(p)
ggpath(p, list(size=year))
ggpath(p, list(colour=year))
ggpath(scsize(p, c(0.5,1)), list(size=year))
ggpath(scsize(p, c(0.5,1)), list(size=year))
p <- ggplot(mtcars, aesthetics=list(x=drat, y=wt))
ggpath(p)
ggpath(p, list(id=cyl))}
\keyword{hplot}
