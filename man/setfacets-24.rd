\name{setfacets}
\alias{setfacets}
\title{Set facetting formula and margins for a plot}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Set the function that controls how the plot is facetted into multiple panels.
}
\usage{setfacets(p = .PLOT, formula = . ~ . , margins = FALSE)}
\arguments{
\item{p}{plot object, if not specified will use current plot}
\item{formula}{formula describing row and column layout, see \code{\link[reshape]{reshape}} for more details}
\item{margins}{a vector of names giving which margins to display, can include grand\_row and grand\_col or uss TRUE to display all margins}
}

\details{}

\examples{}
\keyword{hplot}
