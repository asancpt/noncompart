\name{NonCompart-package}
\alias{NonCompart-package}
\alias{NonCompart}
\docType{package}
\title{Noncompartmental Analysis for Pharmacokinetic Data}
\description{
It conducts a noncompartmental analysis(NCA) with industrial strength.
}
\details{
The main functions are
\preformatted{
tblNCA   to perform NCA for many subjects.

sNCA     to perform NCA for one subject.
}
}
\author{Kyun-Seop Bae <k@acr.kr>}

\references{
\enumerate{
\item Gabrielsson J, Weiner D. Pharmacokinetic and Pharmacodynamic Data Analysis - Concepts and Applications. 5th ed. 2016.
\item Shargel L, Yu A. Applied Biopharmaceutics and Pharmacokinetics. 7th ed. 2015. 
\item Rowland M, Tozer TN. Clinical Pharmacokinetics and Pharmacodynamics - Concepts and Applications. 4th ed. 2011.
\item Gibaldi M, Perrier D. Pharmacokinetics. 2nd ed. revised and expanded. 1982.
}
}
\examples{
# Theoph and Indometh data: dose in mg, conc in mg/L, time in h
tblNCA(Theoph, key="Subject", colTime="Time", colConc="conc", dose=320,
       adm="Extravascular", doseUnit="mg", concUnit="mg/L")

tblNCA(Indometh, key="Subject", colTime="time", colConc="conc", dose=25, 
       adm="Infusion", dur=0.5, doseUnit="mg", concUnit="mg/L", R2ADJ=0.9)

# For individual NCA
iAUC = data.frame(Name=c("AUC[0-12h]","AUC[0-24h]"), Start=c(0,0), End=c(12,24)) ; iAUC

x = Theoph[Theoph$Subject=="1","Time"]
y = Theoph[Theoph$Subject=="1","conc"]

sNCA(x, y, dose=320, doseUnit="mg", concUnit="mg/L", timeUnit="h", iAUC=iAUC)
sNCA(x, y, dose=320, concUnit="mg/L", iAUC=iAUC)
}
