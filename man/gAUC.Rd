\name{gAUC}
\alias{gAUC}
\title{General Area Under the Curve}
\description{General AUC function for Emax, TEmax and AUCs}
\usage{
gAUC(x, y, Ymax = "Emax", XofYmax = "TEmax", AUCname = "AUEClast", iAUC = "", 
     Outer = "NEAREST")
}
\arguments{
  \item{x}{usually time}
  \item{y}{usually concentration or effect. This can be negative/}
  \item{Ymax}{usually Cmax or Emax}
  \item{XofYmax}{usually Tmax or TEmax}
  \item{AUCname}{usually AUClast or AUEClast}
  \item{iAUC}{a data.frame to calculate interval AUCs}
  \item{Outer}{indicates how to do the out of x range point}
}
\details{
  This is a general purpose AUC function. It calculates only Cmax(Emax), Tmax(TEmax) and AUCs(AUECs). This can be used for effect(pharmacodynamic) data which has negative values. For concentration data, use \code{IntAUC}.
}
\value{
Column names can vary according to the options.  
  \item{Emax}{maximum y value}
  \item{TEmax}{x value at the maximum y value}
  \item{AUEClast}{Area under the y versus x curve}
  \item{iAUCs}{Columns from iAUC input}
}
\author{Kyun-Seop Bae <k@acr.kr>}

\examples{
# For one subject
x = Theoph[Theoph$Subject=="1", "Time"]
y = Theoph[Theoph$Subject=="1", "conc"]
gAUC(x, y)

iAUC = data.frame(Name=c("AUC[0-12h]","AUC[0-24h]"), Start=c(0,0), End=c(12,24))
gAUC(x, y, iAUC=iAUC)
}
