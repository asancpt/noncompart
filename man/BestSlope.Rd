\name{BestSlope}
\alias{BestSlope}
\title{Choose the best-fit slope for the log(y) and x regression by the criteria of adjusted R-square.}
\description{
It sequentially fits (log(y) ~ x) from the last point of x to the previous points with at least 3 points.
It chooses a slope the highest adjusted R-square.
If the difference is less then 1e-4, it pickes longer slope.
}
\usage{
  BestSlope(x, y, adm = "Extravascular", TOL=1e-4, excludeDelta = 1)
}
\arguments{
  \item{x}{vector values of x-axis, usually time}
  \item{y}{vector values of y-axis, usually concentration}
  \item{adm}{one of \code{"Bolus"} or \code{"Infusion"} or \code{"Extravascular"} to indicate drug administration mode}
  \item{TOL}{tolerance. See Phoneix WinNonlin 6.4 User's Guide p33 for the detail.}
  \item{excludeDelta}{Improvement of R2ADJ larger than this value could exclude the last point. Default value 1 is for the compatibility with other software.}
}
\details{
Choosing the best terminal slope (y in log scale) in pharmacokinetic analysis is somewhat challenging, and it could vary by analysis performer.
Pheonix WinNonlin chooses a slope with highest adjusted R-squared and the longest one. The difference of adjusted R-Squared less than TOL considered to be 0.  
This function uses ordinary least square method (OLS). Author recommends to use \code{excludeDelta} option with about 0.3.
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
  \item{CLSTP}{predicted y value at the last point, predicted concentration for the last time point}
}
\author{Kyun-Seop Bae <k@acr.kr>}
\seealso{\code{\link{Slope}}}
\examples{
BestSlope(Theoph[Theoph$Subject==1, "Time"], Theoph[Theoph$Subject==1, "conc"])
BestSlope(Indometh[Indometh$Subject==1, "time"], Indometh[Indometh$Subject==1, "conc"],
          adm="Bolus")
}
\keyword{slope}
