\name{ggplot.default}
\alias{ggplot.default}
\alias{package-ggplot}
\alias{ggplot}
\title{Create a new plot}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Create a new ggplot plot
}
\usage{ggplot.default(data = NULL, formula = . ~ ., margins=FALSE, aesthetics=list(), ...)}
\arguments{
\item{data}{default data frame}
\item{formula}{formula describing row and column layout, see \code{\link[reshape]{reshape}} for more details}
\item{margins}{a vector of names giving which margins to display, can include grand\_row and grand\_col or uss TRUE to display all margins}
\item{aesthetics}{default list of aesthetic mappings (these can be colour, size, shape, line type -- see individual grob functions for more details)}
\item{...}{}
}

\details{This function creates the basic ggplot object which you can then
furnish with graphical objects.  Here you will set
up the default data frame, default aesthetics and the formula that
will determine how the panels are broken apart.  See \code{\link[reshape]{reshape}}
for more details on specifying the facetting formula and margin arguments.
Note that ggplot creates a plot object without a "plot": you need to
grobs (points, lines, bars, etc.) to create something that you can see.

To get started, read the introductory vignette: \code{vignette("introduction", "ggplot")}

Steps to create a plot:

\enumerate{
\item Create a new plot.  (\code{p <- ggplot(mtcars, aesthetics=list(y=hp, x=mpg))})
\item Set scales (if necessary)
\item Add grobs to the plot (\code{ggpoint(p)})
}

or, use \code{\link{qplot}}

Simple grobs:

\itemize{
\item \code{\link{ggabline}}: line with given slope and intercept
\item \code{\link{ggarea}}: area (polygons with base on y=0)
\item \code{\link{ggbar}}: bars (stocked and dodgted)
\item \code{\link{ggjitter}}: jittered points (useful for discrete data)
\item \code{\link{ggline}}: lines (paths sorted by x-axis values)
\item \code{\link{ggpath}}: paths
\item \code{\link{ggpoint}}: points
\item \code{\link{ggribbon}}: ribbon
\item \code{\link{ggtext}}: text
\item \code{\link{ggtile}}: tiles, like a levelplot
}

Complex grobs:

\itemize{
\item \code{\link{ggboxplot}}: box plot
\item \code{\link{ggcontour}}: contour lines
\item \code{\link{ggdensity}}: 1d density plot (continuous analogue of histogram)
\item \code{\link{gg2density}}: 2d density countours
\item \code{\link{gghistogram}}: histogram
\item \code{\link{ggquantile}}: quantile lines from a quantile regression
\item \code{\link{ggsmooth}}: smooths from any model family
}

Look at the documentation of these objects to see many examples of ggplot
in action.

You will also want to add scales to the basic plot to give finer control
over how the data values are mapped to aethetics attributes of the grobs.
For scales that control position of the points see:

\itemize{
\item \code{\link{pscontinuous}}: continuous scales (with optional transformation)
\item \code{\link{pscategorical}}: categorical scales
}

For other scales, see:

\itemize{
\item \code{\link{sccolour}}: colour categorical variables using Brewer colour scales (see also \code{\link{scfill}})
\item \code{\link{scgradient}}: colour continuous scales with a gradient (see also \code{\link{scfillgradient}})
\item \code{\link{schcl}}: map continuous variable to hue, chroma or luminance components (see also \code{\link{scfillhcl}})
\item \code{\link{schsv}}: map continuous variable to hue, saturation or value components (see also \code{\link{scfillhsv}})
\item \code{\link{scmanual}}: no automatic conversion, uses raw values directly
\item \code{\link{sclinetype}}: line type (solid, dashed, dotted, etc.)
\item \code{\link{scrgb}}: map continuous variable to red, green or blue components (see also \code{\link{scfillrgb}})
\item \code{\link{scshape}}: point shape (glyph)
\item \code{\link{scsize}}: point or line size
}

ggplot is different from base and lattice graphics in how you build up the plot.
With ggplot you build up the plot object (rather than the plot on the screen as
in base graphics, or all at once as in lattice graphics.)

Each of the grob and scale functions adds the grob to the plot and returns
the modified plot object.  This lets you quickly experiment with different
versions of the plot, using different grobs or scales.  You can see how this
works in the examples

You can also use \code{summary} to give a quick description of a plot.

If you want to change the background colour, how the panel strips are displayed,
or any other default graphical option, see \code{\link{ggopt}}.}
\seealso{\url{http://had.co.nz/ggplot}, \code{\link[reshape]{stamp}}, \code{\link[reshape]{reshape}}, \code{\link{ggopt}}, \code{vignette("introduction", "ggplot")}}
\examples{p <- ggplot(tips)
summary(p)
ggpoint(p, aesthetic=list(y = tip, x=total_bill))
p <- ggplot(tips, aesthetic=list(y = tip, x=total_bill))
p$title <- "Tips"
summary(p)
ggpoint(p)
ggpoint(p, colour="darkgreen", size=3)
ggpoint(p, list(colour=sex))
ggpoint(ggplot(tips, . ~ sex,aesthetics = list(y = tip, x = total_bill)))
p <- ggplot(tips, smoker ~ sex,aesthetics = list(y = tip, x = total_bill))
ggpoint(p)
ggsmooth(ggpoint(p))
ggsmooth(ggpoint(p), method=lm, formula=y~x)
ggabline(ggpoint(p), slope=c(0.1,0.15,0.2))
(p2 <- ggabline(ggpoint(p, aes=list(colour=tip/total_bill)), slope=c(0.1,0.15,0.2)))
summary(p2)
scgradient(p2)
scgradient(p2, midpoint=0.15, high="green", mid="yellow")

p<-ggplot(tips, sex ~ smoker, aesthetics=list(x=tip/total_bill), margins=TRUE)
gghistogram(p)
gghistogram(p,scale="density", breaks=seq(0,1, length=20))
ggdensity(gghistogram(p))

p<-ggplot(tips, . ~ smoker, aesthetics=list(x=sex, y=tip))
ggboxplot(p)
ggjitter(ggboxplot(p))}
\keyword{hplot}
