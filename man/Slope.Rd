\name{Slope}
\alias{Slope}
\title{Get the Slope of regression log(y) ~ x}
\description{
It calculates the slope with linear regression of log(y) ~ x
}
\usage{Slope(x, y)}
\arguments{
  \item{x}{vector values of the independent variable, usually time}
  \item{y}{vector values of the dependent variable, usually concentration}
}
\details{
With time-concentration curve, you frequently need to estimate slope in log(concentration) ~ time.
This function is usually called by \code{BestSlope} function, and you seldom need to call this function directly.
}
\value{
  \item{R2}{R-squared}
  \item{R2ADJ}{adjusted R-squared}
  \item{LAMZNPT}{number of points used for slope}
  \item{LAMZ}{negative of the slope, lambda_z}
  \item{b0}{intercept of the regression line}
  \item{CORRXY}{correlation of log(y) and x}
  \item{LAMZLL}{earliest x for lambda_z}
  \item{LAMZUL}{last x for lambda_z}
}
\author{Kyun-Seop Bae <k@acr.kr>}
\seealso{\code{\link{BestSlope}}}
\examples{
Slope(Indometh[Indometh$Subject==1, "time"], Indometh[Indometh$Subject==1, "conc"])
}
\keyword{slope}
