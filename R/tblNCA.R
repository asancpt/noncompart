tblNCA = function(concData, key="Subject", colTime="Time", colConc="conc", dose=0,
         adm="Extravascular", dur=0, doseUnit="mg", timeUnit="h", concUnit="ug/L",
         down="Linear", R2ADJ=0, MW=0, iAUC="", excludeDelta=1)
{
  class(concData) = "data.frame"
  nKey = length(key)
  for (i in 1:nKey) {
    if (sum(is.na(concData[,key[i]])) > 0) stop(paste(key[i], "has NA value, which is not allowed!"))
  }
  
  IDs = unique(as.data.frame(concData[,key], ncol=nKey))
  nID = nrow(IDs)

  if (length(dose) == 1) {
    dose = rep(dose, nID)
  } else if (length(dose) != nID) {
    stop("Count of dose does not match with number of NCAs!")
  }

  Res = vector()
  for (i in 1:nID) {
    strHeader = paste0(key[1], "=", IDs[i, 1])
    strCond = paste0("concData[concData$", key[1], "=='", IDs[i, 1], "'")
    if (nKey > 1) {
      for (j in 2:nKey) {
        strCond = paste0(strCond, " & concData$", key[j], "=='", IDs[i,j], "'")
        strHeader = paste0(strHeader, ", ", key[j], "=", IDs[i,j])
      }
    }
    strCond = paste0(strCond, ",]")
    tData = eval(parse(text=strCond))
    if (nrow(tData) > 0) {
      tRes = sNCA(tData[,colTime], tData[,colConc], dose=dose[i], adm=adm, dur=dur,
                doseUnit=doseUnit, timeUnit=timeUnit, concUnit=concUnit, R2ADJ=R2ADJ,
                down=down, MW=MW, iAUC=iAUC, Keystring=strHeader, excludeDelta=excludeDelta)
      Res = rbind(Res, tRes)
    }
  }
  Res = cbind(IDs, Res)
  rownames(Res) = NULL
  colnames(Res)[1:nKey] = key
  attr(Res, "units") = c(rep("", nKey), attr(tRes, "units"))
  return(Res)
}


