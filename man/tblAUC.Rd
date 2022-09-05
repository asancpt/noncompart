\name{tblAUC}
\alias{tblAUC}
\title{Table output of gAUCs}
\description{Do multiple AUCs and returns a result table. See \code{gNCA} for more detail i.e. \code{iAUC}}
\usage{
tblAUC(Data, key = "Subject", colX = "Time", colY = "Y", iAUC = "",
       Ymax = "Emax", XofYmax = "TEmax", AUCname = "AUEClast", Outer = "NEAREST")
}
\arguments{
  \item{Data}{data table name}
  \item{key}{column names of Data to be shown in the output table}
  \item{colX}{column name for x axis}
  \item{colY}{column name for y axis}
  \item{iAUC}{a data.frame to calculate interval AUCs}
  \item{Ymax}{usually Cmax or Emax}
  \item{XofYmax}{usually Tmax or TEmax}
  \item{AUCname}{usually AUClast or AUEClast}
  \item{Outer}{indicates how to do the out of x range point}
}
\details{
  Tabular output of AUC with many subjects. This calculates only Cmax(Emax), Tmax(TEmax), AUCs
}
\value{Basically same with \code{\link{gAUC}}}
\author{Kyun-Seop Bae <k@acr.kr>}
\seealso{
\code{\link{help}}, \code{\link{gAUC}}
}
\examples{
tblAUC(Theoph, key="Subject", colX="Time", colY="conc")

iAUC = data.frame(Name=c("AUC[0-12h]","AUC[0-24h]"), Start=c(0,0), End=c(12,24))
tblAUC(Indometh, key="Subject", colX="time", colY="conc", iAUC=iAUC)
}

