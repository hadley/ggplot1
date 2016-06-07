\name{schcl}
\alias{schcl}
\alias{scfillhcl}
\title{Scale: colour (hcl)}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Scale continuous variables to hue, chroma and luminance components of colour
}
\usage{schcl(plot = .PLOT, name="", to=list())}
\arguments{
\item{plot}{}
\item{name}{}
\item{to}{}
}

\details{This colour map is the most perceptually uniform.  However, use multiple
mappings with care.  It is often a good idea to restrict the range of the
hue, as shown in the example.

Note: alpha mappings only work with the Quartz and PDF devices.}
\seealso{\code{\link{map_colour_hcl}}, \code{\link{hcl}}}
\examples{p <- schcl(ggplot(movies, aes=list(y=rating, x=year)))
ggpoint(p, list(h=year))
schcl(ggpoint(p, list(h=year)), list(h.to=c(45,60)))
ggpoint(p, list(c=rating))
ggpoint(p, list(l=length))
ggpoint(p, list(h=rating, l=year))
ggpoint(p, list(h=rating, c=year, l=year))}
\keyword{hplot}
