\name{build_df}
\alias{build_df}
\title{Build data frame}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Build data frome for a plot with given data and ... (dots) arguments
}
\usage{build_df(plot, data = plot$data, aesthetics=NULL)}
\arguments{
\item{plot}{plot object}
\item{data}{data frame to use}
\item{aesthetics}{extra arguments supplied by user that should be used first}
}

\details{Depending on the arguments supplied to \code{\link{plot_add}} we need
to stitch together a data frame using the defaults from plot\$defaults
where the user hasn't explicitly specified otherwise.

Arguments in dots are evaluated in the context of \code{data} so that
column names can easily be references.

Also makes sure that it contains all the columns required to correctly
place the output into the row+column structure defined by the formula,
by using \code{\link[reshape]{expand.grid.df}} to add in extra columns if needed.}

\examples{}
\keyword{hplot}
\keyword{internal}
