\name{gIntAUC}
\alias{gIntAUC}
\title{Calculate interval AUC of general form}
\description{It calculates interval AUC of general form. This is useful for pharmacodynamic data.}
\usage{gIntAUC(x, y, t1, t2, Outer = "NEAREST")}
\arguments{
  \item{x}{vector values of independent variable, usually time}
  \item{y}{vector values of dependent variable, usually concentration}
  \item{t1}{start time for AUC}
  \item{t2}{end time for AUC}
  \item{Outer}{indicates how to do the out of x range point}
}
\details{
This calculates an interval (partial) AUC (from t1 to t2) with the given series of x and y.
If t1 and/or t2 cannot be found within x vector, it interpolates.
If t1 and/or t2 are out of x range, it uses the nearest value.
For concentration data, use \code{IntAUC}.
}
\value{return interval AUC value (scalar)}
\author{Kyun-Seop Bae <k@acr.kr>}
\seealso{\code{\link{gAUC}}, \code{\link{gInterpol}}, \code{\link{tblAUC}}}
\examples{
gIntAUC(Theoph[Theoph$Subject==1, "Time"], Theoph[Theoph$Subject==1, "conc"], t1=0.5, t2=11)
}
\keyword{AUC}
\keyword{interval AUC}
\keyword{partial AUC}
