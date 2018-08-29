tblNCA = function(concData, key="Subject", colTime="Time", colConc="conc", dose=0,
         adm="Extravascular", dur=0, doseUnit="mg", timeUnit="h", concUnit="ug/L",
         down="Linear", R2ADJ=0.9, MW=0)
{
# Author: Kyun-Seop Bae k@acr.kr
# Last modification: 2018.7.10
# Called by:
# Calls: sNCA
# INPUT
#   key: columns names of concData to be shown at the output table
#   colTime: column for time in concData table
#   colConc: column for concentration in concData table
#   dose: vector of dose
#   adm: administration method, "Extravascular", "Bolus", or "Infusion"
#   dur: duration of infusion
#   doseUnit: dose unit (not per kg or per m2)
#   timeUnit: time unit
#   concUnit: concentration unit
#   iAUC: data frame for interval AUC. See the example for the detail
#   down: trapezoidal downward caculation. "Linear" or "Log"
#   MW: molecular weight
# RETURNS
#   table of NCA result

  nKey = length(key)
  IDs = unique(as.data.frame(concData[,key], ncol=nKey))
  nID = nrow(IDs)

  if (length(dose) == 1) {
    dose = rep(dose, nID)
  } else if (length(dose) != nID) {
    stop("Count of dose does not match with number of NCAs!")
  }

  Res = vector()
  for (i in 1:nID) {
    strCond = paste0("concData[concData$", key[1], "=='", IDs[i, 1], "'")
    if (nKey > 1) {
      for (j in 2:nKey) strCond = paste0(strCond, " & concData$", key[j], "=='", IDs[i,j], "'")
    }
    strCond = paste0(strCond, ",]")
    tData = eval(parse(text=strCond))
    if (nrow(tData) > 0) {
      tRes = sNCA(tData[,colTime], tData[,colConc], dose=dose[i], adm=adm, dur=dur,
                doseUnit=doseUnit, timeUnit=timeUnit, concUnit=concUnit, R2ADJ=R2ADJ,
                down=down, MW=MW)
      Res = rbind(Res, tRes)
    }
  }
  Res = cbind(IDs, Res)
  rownames(Res) = NULL
  colnames(Res)[1:nKey] = key
  attr(Res, "units") = c(rep("", nKey), attr(tRes, "units"))
  return(Res)
}


