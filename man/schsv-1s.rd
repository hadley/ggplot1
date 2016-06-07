\name{schsv}
\alias{schsv}
\alias{scfillhsv}
\title{Scale: colour (hsv)}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Scale continuous variables to hue, saturation and value components of colour.
}
\usage{schsv(plot = .PLOT, name="", to=list())}
\arguments{
\item{plot}{}
\item{name}{}
\item{to}{}
}

\details{Use multiple mappings with care

Note: alpha mappings only work with the Quartz and PDF devices.}
\seealso{\code{\link{map_colour_hsv}}, \code{\link{hsv}}}
\examples{p <- schsv(ggplot(movies, aes=list(y=rating, x=year)))
ggpoint(p, list(h=year))
schsv(ggpoint(p, list(h=year)), list(h.to=c(0.3,0.5)))
ggpoint(p, list(s=rating))
ggpoint(p, list(v=rating, h=0.3, s=rating))
ggpoint(p, list(h=rating, v=year))}
\keyword{hplot}
