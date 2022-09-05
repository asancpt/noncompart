\name{IntAUC}
\alias{IntAUC}
\title{Calculate interval AUC}
\description{It calculates interval AUC}
\usage{IntAUC(x, y, t1, t2, Res, down = "Linear")}
\arguments{
  \item{x}{vector values of independent variable, usually time}
  \item{y}{vector values of dependent variable, usually concentration}
  \item{t1}{start time for AUC}
  \item{t2}{end time for AUC}
  \item{Res}{result from \code{sNCA} function}
  \item{down}{either of \code{"Linear"} or \code{"Log"} to indicate the way to calculate AUC}
}
\details{
This calculates an interval (partial) AUC (from t1 to t2) with the given series of x and y.
If t1 and/or t2 cannot be found within x vector, it interpolates according to the \code{down} option.
}
\value{return interval AUC value (scalar)}
\references{
\enumerate{
\item Gabrielsson J, Weiner D. Pharmacokinetic and Pharmacodynamic Data Analysis - Concepts and Applications. 5th ed. 2016.
\item Shargel L, Yu A. Applied Biopharmaceutics and Pharmacokinetics. 7th ed. 2015. 
\item Rowland M, Tozer TN. Clinical Pharmacokinetics and Pharmacodynamics - Concepts and Applications. 4th ed. 2011.
\item Gibaldi M, Perrier D. Pharmacokinetics. 2nd ed. revised and expanded. 1982.
}
}
\author{Kyun-Seop Bae <k@acr.kr>}
\seealso{\code{\link{AUC}}, \code{\link{Interpol}}}
\examples{
Res = sNCA(Theoph[Theoph$Subject==1,"Time"], Theoph[Theoph$Subject==1, "conc"], 
           dose=320, concUnit="mg/L")
IntAUC(Theoph[Theoph$Subject==1, "Time"], Theoph[Theoph$Subject==1, "conc"], t1=0.5, t2=11, Res)
}
\keyword{AUC}
\keyword{interval AUC}
\keyword{partial AUC}
