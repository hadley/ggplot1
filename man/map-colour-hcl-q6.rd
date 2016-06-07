\name{map_colour_hcl}
\alias{map_colour_hcl}
\alias{map_color_hcl}
\title{Aesthetic mapping: hcl components of colour}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Map variables to hue, chroma or luminance.
}
\usage{map_colour_hcl(h=0, c=80, l=50, a=1, h.to=c(0,360), c.to=c(0,200), l.to=c(0,100), a.to=c(0,1), h.from = range(h, na.rm=TRUE), c.from = range(c, na.rm=TRUE), l.from = range(l, na.rm=TRUE), a.from = range(a, na.rm=TRUE))}
\arguments{
\item{h}{hue}
\item{c}{chroma}
\item{l}{luminance}
\item{a}{alpha}
\item{h.to}{hue to}
\item{c.to}{chroma to}
\item{l.to}{luminance to}
\item{a.to}{alpha to}
\item{h.from}{}
\item{c.from}{}
\item{l.from}{}
\item{a.from}{}
}

\details{Using hue is the best.}

\examples{}
\keyword{hplot}
