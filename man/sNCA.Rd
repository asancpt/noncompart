\name{sNCA}
\alias{sNCA}
\title{Simplest NCA}
\description{This is the work-horse function for NCA.}
\usage{
sNCA(x, y, dose = 0, adm = "Extravascular", dur = 0, doseUnit = "mg", timeUnit = "h", 
     concUnit = "ug/L", iAUC = "", down = "Linear", R2ADJ = 0.9, MW = 0, returnNA = FALSE)
}
\arguments{
  \item{x}{usually time}
  \item{y}{usually concentration}
  \item{dose}{given amount}
  \item{adm}{one of \code{"Bolus"} or \code{"Infusion"} or \code{"Extravascular"} to indicate drug administration mode}
  \item{dur}{duration of infusion}
  \item{doseUnit}{unit of dose}
  \item{timeUnit}{unit of time}
  \item{concUnit}{unit of concentration}
  \item{iAUC}{interval AUCs to calculate}
  \item{down}{either of \code{"Linear"} or \code{"Log"} to indicate the way to calculate AUC and AUMC}
  \item{R2ADJ}{Lowest threshold of adjusted R-square value to do manual slope determination}
  \item{MW}{molecular weight of the drug}
  \item{returnNA}{deprecated, just for backward compatibility}
}
\details{
  This will replace \code{IndiNCA}.
}
\value{
  \item{CMAX}{maximum concentration, Cmax}
  \item{CMAXD}{dose normalized Cmax, CMAX / Dose, Cmax / Dose}
  \item{TMAX}{time of maximum concentration, Tmax}
  \item{TLAG}{time to observe the first non-zero concentration, for extravascular administration only}
  \item{CLST}{last positive concentration observed, Clast}
  \item{CLSTP}{last positive concentration predicted, Clast_pred}
  \item{TLST}{time of last positive concentration, Tlast}
  \item{LAMZHL}{half-life by lambda z, ln(2)/LAMZ}
  \item{LAMZ}{lambda_z negative of the best-fit terminal slope}
  \item{LAMZLL}{earliest time for LAMZ}
  \item{LAMZUL}{last time for LAMZ}
  \item{LAMZNPT}{number of points for LAMZ}
  \item{CORRXY}{correlation of log(concentration) and time}
  \item{R2}{R-squared}
  \item{R2ADJ}{R-squared adjusted}
  \item{C0}{back extrapolated concentration at time 0, for intravascular bolus administration only}
  \item{AUCLST}{AUC from 0 to TLST}
  \item{AUCALL}{AUC using all the given points, including trailing zero concentrations}
  \item{AUCIFO}{AUC infinity observed}
  \item{AUCIFOD}{AUCIFO / Dose}
  \item{AUCIFP}{AUC infinity predicted using CLSTP instead of CLST}
  \item{AUCIFPD}{AUCIFP / Dose}
  \item{AUCPEO}{AUC \% extrapolation observed}
  \item{AUCPEP}{AUC \% extrapolated for AUCIFP}
  \item{AUCPBEO}{AUC \% back extrapolation observed, for bolus IV administration only}
  \item{AUCPBEP}{AUC \% back extrapolation predicted with AUCIFP, for bolus IV administration only}
  \item{AUMCLST}{AUMC to the TLST}
  \item{AUMCIFO}{AUMC infinity observed using CLST}
  \item{AUMCIFP}{AUMC infinity determined by CLSTP}
  \item{AUMCPEO}{AUMC \% extrapolated observed}
  \item{AUMCPEP}{AUMC \% extrapolated predicted}
  \item{MRTIVLST}{mean residence time (MRT) to TLST, for intravascular administration}
  \item{MRTIVIFO}{mean residence time (MRT) infinity using CLST, for intravascular administration}
  \item{MRTIVIFP}{mean residence time (MRT) infinity using CLSTP, for intravascular administration}
  \item{MRTEVLST}{mean residence time (MRT) to TLST, for extravascular administration}
  \item{MRTEVIFO}{mean residence time (MRT) infinity using CLST, for extravascular administration}
  \item{MRTEVIFP}{mean residence time (MRT) infinity using CLSTP, for extravascular administration}
  \item{VZO}{volume of distribution determined by LAMZ and AUCIFO, for intravascular administration}
  \item{VZP}{volume of distribution determined by LAMZ and AUCIFP, for intravascular administration}
  \item{VZFO}{VZO for extravascular administration, VZO/F, F is bioavailability}
  \item{VZFP}{VZP for extravascular administration, VZP/F, F is bioavailability}
  \item{CLO}{clearance using AUCIFO, for intravascular administration}
  \item{CLP}{clearance using AUCIFP, for intravascular administration}
  \item{CLFO}{CLO for extravascular administration, CLO/F, F is bioavailability}
  \item{CLFP}{CLP for extravascular administration, CLP/F, F is bioavailability}
  \item{VSSO}{volume of distribution at steady state using CLST, for intravascular administration only}
  \item{VSSP}{volume of distribution at steady state using CLSTP, for intravascular administration only}
}
\references{
Gabrielsson J, Weiner D. Pharmacokinetic and Pharmacodynamic Data Analysis - Concepts and Applications. 5th ed. 2016.
}
\author{Kyun-Seop Bae <k@acr.kr>}

\seealso{
\code{\link{help}}, \code{\link{tblNCA}} 
}
\examples{
# For one subject
x = Theoph[Theoph$Subject=="1","Time"]
y = Theoph[Theoph$Subject=="1","conc"]

sNCA(x, y, dose=320, doseUnit="mg", concUnit="mg/L", timeUnit="h")
sNCA(x, y, dose=320, concUnit="mg/L")

iAUC = data.frame(Name=c("AUC[0-12h]","AUC[0-24h]"), Start=c(0,0), End=c(12,24))
sNCA(x, y, dose=320, doseUnit="mg", concUnit="mg/L", timeUnit="h", iAUC=iAUC)

MW = 180.164 # Molecular weight of theophylline

sNCA(x, y/MW, dose=320, doseUnit="mg", concUnit="mmol/L", timeUnit="h")
sNCA(x, y/MW, dose=320, doseUnit="mg", concUnit="mmol/L", timeUnit="h", MW=MW)
sNCA(x, y, dose=320/MW, doseUnit="mmol", concUnit="mg/L", timeUnit="h", MW=MW)
sNCA(x, y/MW, dose=320/MW, doseUnit="mmol", concUnit="mmol/L", timeUnit="h", MW=MW)

sNCA(x, y/MW, dose=320/MW, doseUnit="mmol", concUnit="mmol/L", timeUnit="h", MW=MW)
sNCA(x, y/MW, doseUnit="mmol", concUnit="mmol/L", timeUnit="h", MW=MW)
sNCA(x, y/MW, dose=as.numeric(NA), doseUnit="mmol", concUnit="mmol/L", timeUnit="h", 
     MW=MW)

sNCA(x, y, dose=320, concUnit="mg/L", timeUnit="hr")
sNCA(x*60, y, dose=320, concUnit="mg/L", timeUnit="min")
}
\keyword{Output Form}
