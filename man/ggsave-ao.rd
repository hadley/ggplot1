\name{ggsave}
\alias{ggsave}
\title{ggsave}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Save a ggplot with sensible defaults
}
\usage{ggsave(plot = .PLOT, filename=default_name(plot), device=default_device(filename), scale=1, width=par("din")[1], height=par("din")[2], grid="normal", dpi=96, ...)}
\arguments{
\item{plot}{plot to save}
\item{filename}{file name/path of plot}
\item{device}{device to use, automatically extract from file name extension}
\item{scale}{scaling factor}
\item{width}{width (in inches)}
\item{height}{height (in inches)}
\item{grid}{grid to use, normal for white on pale grey, print for pale grey on white}
\item{dpi}{dpi to use for raster graphics}
\item{...}{other arguments passed to device function}
}

\details{}

\examples{}
\keyword{file}
