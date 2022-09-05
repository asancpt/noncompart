\name{gInterpol}
\alias{gInterpol}
\title{Interpolate y value for general y value not for concentration}
\description{It interpolates y value when a corresponding x value (xnew) does not exist within x vector}
\usage{gInterpol(x, y, xnew, Outer="NEAREST")}
\arguments{
  \item{x}{vector values of x-axis, usually time}
  \item{y}{vector values of y-axis, usually concentration}
  \item{xnew}{new x point to be interpolated, usually new time point}
  \item{Outer}{indicates how to do the out of x range point}
}
\details{
This function interpolate y value, if xnew is not in x vector.
If xnew is in the x vector, it just returns the given x and y vector.
This function usually is called by \code{gIntAUC} function
Returned vector is sorted in the order of increasing x values.
}
\value{new x and y vector containing xnew and ynew point}
\author{Kyun-Seop Bae <k@acr.kr>}
\seealso{\code{\link{gIntAUC}}}
\examples{
x = 1:10 + 0.1
y = -2*x + 40.2
gInterpol(x, y, 1.5)
gInterpol(x, y, 0.5) # Out of range, Left
gInterpol(x, y, 11) # Out of range, Left
}
\keyword{interpolation}
\keyword{interval AUC}
\keyword{partial AUC}
