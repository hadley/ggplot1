\name{ggsmooth}
\alias{ggsmooth}
\title{Grob function: smooth}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Add a smooth line to a plot
}
\usage{ggsmooth(plot = .PLOT, aesthetics=list(), ..., data=NULL)}
\arguments{
\item{plot}{the plot object to modify}
\item{aesthetics}{named list of aesthetic mappings, see details for more information}
\item{...}{other options, see details for more information}
\item{data}{data source, if not specified the plot default will be used}
}

\details{This grob adds a smoother to the graphic to aid the eye in
seeing important patterns, especially when there is a lot of overplotting.

You can customise this very freely, firstly by choosing the function used
to fit the smoother (eg. \code{\link{loess}}, \code{\link{lm}}, \code{\link{rlm}},
\code{\link{gam}}, \code{\link{glm}}) and the formula used to related the y and x
values (eg. \code{y ~ x}, \code{y ~ poly(x,3)}).

This smoother is automatically restricted to the range of the data.  If you
want to perform predictions (or fit more complicated variabels with covariates)
then you should fit the model and plot the predicted results.

Aesthetic mappings that this grob function understands:

\itemize{
\item \code{x}:x position (required)
\item \code{y}:y position (required)
\item \code{size}:size of the point, in mm (see \code{\link{scsize})}
\item \code{colour}:point colour (see \code{\link{sccolour})}
\item \code{weight}: observation weights
}

These can be specified in the plot defaults (see \code{\link{ggplot}}) or
in the \code{aesthetics} argument.  If you want to modify the position
of the points or any axis options, you will need to add a position scale to
the plot.  These functions start with \code{ps}, eg.
\code{\link{pscontinuous}} or \code{\link{pscategorical}}

Other options:

\itemize{
\item \code{method}:smoothing method (function) to use
\item \code{formula}:formula to use in smoothing function
\item \code{se}:display one standard error on either side of fit? (true by default)
\item other arguments are passed to smoothing function
}}

\examples{p <- ggpoint(ggplot(mtcars, aesthetics=list(y=wt, x=qsec)))
ggsmooth(p)
ggsmooth(p, span=0.9)
ggsmooth(p, method=lm)
ggsmooth(p, method=lm, formula = y~splines::ns(x,3))
ggsmooth(p, method=MASS::rlm, formula = y~splines::ns(x,3))}
\keyword{hplot}
