\name{ggerrorbar}
\alias{ggerrorbar}
\title{Grob function: error bars}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Add error bars to a plot
}
\usage{ggerrorbar(plot = .PLOT, aesthetics = list(), ..., data = NULL)}
\arguments{
\item{plot}{the plot object to modify}
\item{aesthetics}{named list of aesthetic mappings, see details for more information}
\item{...}{other options, see details for more information}
\item{data}{data source, if not specified the plot default will be used}
}

\details{The error bar grob adds error bars to a plot.  Thanks to Timm
Danker for supplying some initial code and the motivation to include
it in ggplot.

Aesthetic mappings that this grob function understands:

\itemize{
\item \code{x}:x position (required)
\item \code{y}:y position (required)
\item \code{plus}:length of error bar in positive direction (required)
\item \code{minus}:length of error bar in negative direction (defaults to -plus)
\item \code{colour}:line colour (see \code{\link{sccolour})}
\item \code{size}:size of the line, in mm (see \code{\link{scsize})}
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
}}
\seealso{\code{\link{ggbar}}}
\examples{df <- data.frame(x = factor(c(1, 1, 2, 2)), y = c(1, 5, 3, 4), g = c(1, 2, 1, 2), bar = c(0.1, 
0.3, 0.3, 0.2))
df2<-df[c(1,3),];df2

p <- ggbar(ggplot(data=df, aes=list(fill=g, y=y, x=x)))
ggerrorbar(p, aes=list(plus=bar))
qplot(x,y,df,types=list("bar","errorbar"), avoid="dodge",aes=list(fill=g,plus=bar))
qplot(x,y,df,types=list("bar","errorbar"), avoid="dodge",aes=list(fill=g,plus=bar, minus=-2*bar))
qplot(x,y,df2,types=list("point","errorbar"), aes=list(plus=bar), width=0.1)
qplot(x,y,df2,types=list("bar","line","point","errorbar"), aes=list(fill=g,plus=bar,barcolour=g))
qplot(x,y,df2,types=list("jitter","errorbar"), aes=list(plus=bar))
qplot(x,y,df,types=list("point","line","errorbar"), aes=list(plus=bar,id=g), width=0.1)}
\keyword{hplot}
