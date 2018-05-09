\name{Unit}
\alias{Unit}
\title{
Display CDISC standard units and multiplied factor of NCA results  
}
\description{
It displays CDISC PP output units and multiplication factor for them.
}
\usage{
Unit(code = "", timeUnit = "h", concUnit = "ng/mL", doseUnit = "mg", MW = 0)
}
\arguments{
  \item{code}{vector of PPTESTCD}
  \item{timeUnit}{unit of time}
  \item{concUnit}{unit of concentration}
  \item{doseUnit}{unit of dose}
  \item{MW}{molecular weight of drug}
}
\value{
  \item{row names}{PPTESTCD}
  \item{Unit}{unit}
  \item{Factor}{internal mulitplication factor}
}
\author{Kyun-Seop Bae <k@acr.kr>}
\examples{
Unit(concUnit="ug/L", doseUnit="mg")
Unit(concUnit="ng/L", doseUnit="mg")

Unit(concUnit="umol/L", doseUnit="mmol")
Unit(concUnit="nmol/L", doseUnit="mmol")

Unit(concUnit="mmol/L", doseUnit="mg", MW=500)
Unit(concUnit="umol/L", doseUnit="mg", MW=500)
Unit(concUnit="nmol/L", doseUnit="mg", MW=500)
Unit(concUnit="nmol/mL", doseUnit="mg", MW=500)

Unit(concUnit="ug/L", doseUnit="mmol", MW=500)
Unit(concUnit="ug/L", doseUnit="mol", MW=500)
Unit(concUnit="ng/L", doseUnit="mmol", MW=500)
Unit(concUnit="ng/mL", doseUnit="mmol", MW=500)

Unit(concUnit="nmol/L", doseUnit="mg")
Unit(concUnit="ug/L", doseUnit="mmol")
}


