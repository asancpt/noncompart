\name{UnitUrine}
\alias{UnitUrine}
\title{
Retuns a conversion factor for the amount calculation from urine concentration and volume  
}
\description{
You can get a conversion factor for the multiplication: conc * vol * factor = amount in the given unit.
}
\usage{
UnitUrine(conU = "ng/mL", volU = "mL", amtU = "mg", MW = 0)
}
\arguments{
  \item{conU}{concentration unit}
  \item{volU}{volume unit}
  \item{amtU}{amount unit}
  \item{MW}{molecular weight}
}
\value{
  \item{Factor}{conversion factor for multiplication with the unit in name}
}
\author{Kyun-Seop Bae <k@acr.kr>}
\examples{
UnitUrine()
UnitUrine("ng/mL", "mL", "mg")
UnitUrine("ug/L", "mL", "mg")
UnitUrine("ug/L", "L", "mg")

UnitUrine("ng/mL", "mL", "g")

UnitUrine("ng/mL", "mL", "mol", MW=500)
UnitUrine("ng/mL", "mL", "mmol", MW=500)
UnitUrine("ng/mL", "mL", "umol", MW=500)
}


