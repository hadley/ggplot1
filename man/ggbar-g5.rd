\name{ggbar}
\alias{ggbar}
\title{Grob function: bars}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Add bars to a plot
}
\usage{ggbar(plot = .PLOT, aesthetics=list(), ..., data=NULL)}
\arguments{
\item{plot}{the plot object to modify}
\item{aesthetics}{named list of aesthetic mappings, see details for more information}
\item{...}{other options, see details for more information}
\item{data}{data source, if not specified the plot default will be used}
}

\details{The bar grob produces bars from the y-position to the y=0.

Aesthetic mappings that this grob function understands:

\itemize{
\item \code{x}:x position (required)
\item \code{y}:y position (required)
\item \code{fill}:fill colour (see \code{\link{sccolour})}
}

These can be specified in the plot defaults (see \code{\link{ggplot}}) or
in the \code{aesthetics} argument.  If you want to modify the position
of the points or any axis options, you will need to add a position scale to
the plot.  These functions start with \code{ps}, eg.
\code{\link{pscontinuous}} or \code{\link{pscategorical}}

Other options:

\itemize{
\item \code{avoid}: how should overplotting be dealt with?
"none" (default) = do nothing, "stack" = stack bars on top of one another,
"dodge" = dodge bars from side to side
\item \code{sort}: Should the values of the bars be sorted
}}
\seealso{\code{\link{ggrect}}}
\examples{cyltab <- as.data.frame(table(cyl=mtcars$cyl))
p <- ggplot(cyltab, aes=list(y=Freq, x=cyl))
ggbar(p)
ggbar(p, fill="white", colour="red")
#Can also make a stacked bar chart
p <- ggplot(mtcars, aes=list(y=1, x=factor(cyl)))
ggbar(p, avoid="stack")
ggbar(p, avoid="stack", colour="red") # Made up of multiple small bars
p <- ggplot(mtcars, aes=list(y=mpg, x=factor(cyl)))
ggbar(p, avoid="stack")
ggbar(p, avoid="dodge", sort=TRUE)
ggbar(p, aes=list(fill=mpg), avoid="dodge", sort=TRUE)
ggbar(p, avoid="stack", sort=TRUE)}
\keyword{hplot}
