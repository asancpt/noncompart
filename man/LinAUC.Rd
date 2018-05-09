\name{LinAUC}
\alias{LinAUC}
\title{Area Under the Curve(AUC) and Area Under the first Moment Curve(AUMC) by linear trapezoidal method}
\description{It calculates AUC and AUMC using the linear trapezoidal method}
\usage{LinAUC(x, y)}
\arguments{
  \item{x}{vector values of the independent variable, usually time}
  \item{y}{vector values of the dependent variable, usually concentration}
}
\details{
This function returns AUC and AUMC by the linear trapezoidal method.
}
\value{
  \item{AUC}{area under the curve}
  \item{AUMC}{area under the first moment curve}
}
\references{
\enumerate{
\item Gabrielsson J, Weiner D. Pharmacokinetic and Pharmacodynamic Data Analysis - Concepts and Applications. 5th ed. 2016.
\item Shargel L, Yu A. Applied Biopharmaceutics and Pharmacokinetics. 7th ed. 2015. 
\item Rowland M, Tozer TN. Clinical Pharmacokinetics and Pharmacodynamics - Concepts and Applications. 4th ed. 2011.
\item Gibaldi M, Perrier D. Pharmacokinetics. 2nd ed. revised and expanded. 1982.
}
}
\author{Kyun-Seop Bae <k@acr.kr>}
\seealso{\code{\link{LogAUC}}, \code{\link{AUC}}}
\examples{
LinAUC(Theoph[Theoph$Subject==1, "Time"], Theoph[Theoph$Subject==1, "conc"])
AUC(Theoph[Theoph$Subject==1, "Time"], Theoph[Theoph$Subject==1, "conc"]) # compare the last line
}
\keyword{AUC}
