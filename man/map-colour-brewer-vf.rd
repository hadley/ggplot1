\name{map_colour_brewer}
\alias{map_colour_brewer}
\alias{map_color_brewer}
\alias{map_color}
\alias{map_colour}
\title{Aesthetic mapping: Brewer colours}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Map categorical variables to Brewer colour scales
}
\usage{map_colour_brewer(x, palette=1)}
\arguments{
\item{x}{data vector}
\item{palette}{palette number to use}
}

\details{If x is not a factor, will be converted to one by \code{\link{chop_auto}}.
Can display at most 9 different categories.

Unordered factors will use qualitative scales.
Ordered factors will use sequential scales.
Ordered factors with negative level will use diverging scales.}

\examples{}
\keyword{manip}
