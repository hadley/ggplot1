\name{scale_categorical}
\alias{scale_categorical}
\title{Scale: general categorical}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Create a categorical scale for the specified variable
}
\usage{scale_categorical(variable="x", name="", expand=c(0,0), transform="as.numeric", ...)}
\arguments{
\item{variable}{variable that this scale is for}
\item{name}{name of the scale (used in the legend)}
\item{expand}{expansion factor for scale}
\item{transform}{transformation function}
\item{...}{}
}

\details{A categorical scale is a simple mapping from the levels of
the categorical factor to values of the aesthetic attribute.
These mappings are created by the aesthetic mapping functions
\code{\link{map_colour}}, and \code{\link{map_linetype}}.
You will want to refer to those to see the possible options
that can be used to control the mapping.

You should not call this function yourself.  Instead use:

\item \code{\link{pscategorical}}
\item \code{\link{sccolour}}
\item \code{\link{sclinetype}}
\item \code{\link{scshape}}

If you use a continuous variable with this scale, it will automatically
be converted to a categorical variable using \code{\link{chop_auto}}.  If
you want more control over the conversion you will want to use
\code{\link{chop}} yourself.  However, be careful to do all the chopping
in one place, otherwise you may end up with different scales in different grobs.

This categorical scale places evenly spaces the levels of the factor
along the intergers.  If you want to change the order of the levels
you will need to change the levels in the original factor.}

\examples{}
\keyword{hplot}
\keyword{internal}
