\name{scrgb}
\alias{scrgb}
\alias{scfillrgb}
\title{Scale: colour (rgb)}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Scale continuous variables to red, green and blue components of colour.
}
\usage{scrgb(plot = .PLOT, name="", to=list())}
\arguments{
\item{plot}{plot to add scale to}
\item{name}{name of the scale (used in the legend)}
\item{to}{named list of target ranges (r.to, g.to, b.to, a.to)}
}

\details{The RGB colour space is NOT perceptually uniform.  Use
this scale with care.  It is extremely ill-advised to map variables to more
than one of r, g, b, or a.

Note: alpha mappings only work with the Quartz and PDF devices.}
\seealso{\code{\link{map_colour_rgb}}, \code{\link{rgb}}}
\examples{p <- scrgb(ggplot(movies, aes=list(y=rating, x=year)))
ggpoint(p, list(r=year))
ggpoint(p, list(b=rating))
ggpoint(p, list(b=rating, r=1))
scrgb(ggpoint(p, list(b=rating, r=1)), list(b.to=c(0.25,0.75)))
ggpoint(p, list(b=rating, r=year))
ggpoint(p, list(b=rating, r=year, g=year))}
\keyword{hplot}
