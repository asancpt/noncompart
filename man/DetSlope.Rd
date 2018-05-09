\name{DetSlope}
\alias{DetSlope}
\title{Determine slope for the log(y) and x regression manually}
\description{
You choose a slope for terminal half-life.
}
\usage{DetSlope(x, y, sel.1=0, sel.2=0)}
\arguments{
  \item{x}{vector values of x-axis, usually time}
  \item{y}{vector values of y-axis, usually concentration}
  \item{sel.1}{default index of the first element to use}
  \item{sel.2}{default index of the last element to use}
}
\details{
Sometimes \code{BestSlope} cannot find terminal slope satisfactorily. Then you can use this function to choose manually. It returns the same format result with \code{BestSlope} with an attribute indicating used points.
}
\value{
  \item{R2}{R-squared}
  \item{R2ADJ}{adjusted R-squared}
  \item{LAMZNPT}{number of points used for the slope}
  \item{LAMZ}{negative of the slope, lambda_z}
  \item{b0}{intercept of the regression line}
  \item{CORRXY}{correlation of log(y) and x}
  \item{LAMZLL}{earliest x for lambda_z}
  \item{LAMZUL}{last x for lambda_z}
  \item{CLSTP}{predicted y value at the last point, predicted concentration for the last time point}
}
\author{Kyun-Seop Bae <k@acr.kr>}
\seealso{\code{\link{Slope}}}
\examples{
DetSlope(Theoph[Theoph$Subject==1, "Time"], Theoph[Theoph$Subject==1, "conc"])
DetSlope(Indometh[Indometh$Subject==2, "time"], Indometh[Indometh$Subject==2, "conc"])
}
\keyword{slope}
