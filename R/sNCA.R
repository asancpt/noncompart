sNCA = function(x, y, dose=0, adm="Extravascular", dur=0, doseUnit="mg", timeUnit="h", concUnit="ug/L", iAUC="", down="Linear", R2ADJ=0.9, MW=0, returnNA=FALSE)
{
# Author: Kyun-Seop Bae k@acr.kr
# Last modification: 2017.8.14
# Called by: tblNCA
# Calls: BestSlope, IntAUC, Unit, UT
# INPUT
#   x: time or similar vector
#   y: concentration or similar vector
#   dose: dose, actually given dose, not per kg or per square meter dose!
#   adm: administration method, "Extravascular", "Bolus", or "Infusion"
#   dur: duration of infusion
#   doseUnit: dose unit (not per kg or per m2)
#   timeUnit: time unit
#   concUnit: concentration unit
#   iAUC: data frame for interval AUC. See the example for the detail
#   down: trapezoidal downward caculation. "Linear" or "Log"
#   MW: molecular weight
#   returnNA: deprecated one, just for backward compatibility
# RETURNS
#   NCA result

  if (!(is.numeric(x) & is.numeric(y) & is.numeric(dose) & is.numeric(dur) & is.character(adm) & is.character(down))) stop("Check input types!")
  if (UT(adm) == "INFUSION" & !(dur > 0)) stop("Infusion mode should have dur larger than 0!")

  NApoints = is.na(x) | is.na(y)
  x = x[!NApoints]             # remove NA points in x
  y = y[!NApoints]             # remove NA points in y
  n = length(x)

  RetNames1 = c("b0", "CMAX", "CMAXD", "TMAX", "TLAG", "CLST", "CLSTP", "TLST", "LAMZHL", "LAMZ",
             "LAMZLL", "LAMZUL", "LAMZNPT", "CORRXY", "R2", "R2ADJ", "AUCLST", "AUCALL",
             "AUCIFO", "AUCIFOD", "AUCIFP", "AUCIFPD", "AUCPEO", "AUCPEP",
             "AUMCLST", "AUMCIFO", "AUMCIFP", "AUMCPEO", "AUMCPEP")
  if (UT(adm) == "BOLUS") {
    RetNames1 = union(RetNames1, c("C0", "AUCPBEO", "AUCPBEP"))
  }
  if (UT(adm) == "EXTRAVASCULAR") {
    RetNames1 = union(RetNames1, c("VZFO", "VZFP", "CLFO", "CLFP", "MRTEVLST", "MRTEVIFO", "MRTEVIFP"))
  } else {
    RetNames1 = union(RetNames1, c("VZO", "VZP", "CLO", "CLP", "MRTIVLST", "MRTIVIFO", "MRTIVIFP", "VSSO", "VSSP"))
  }
  Res = rep(NA_real_, length(RetNames1))
  names(Res) = RetNames1

  if (n == 0 | n != length(y) | length(y[y < 0]) > 0) {
    Res["LAMZNPT"] = 0
    return(Res)
  }

  uY = unique(y)
  if (length(uY) == 1) { # Case of all the same values
    Res["CMAX"] = uY
    if (dose > 0) Res["CMAXD"] = uY / dose
    Res["TMAX"] = x[y==uY][1] # First Tmax
    if (which(y==uY)[1] > 1) {
      Res["TLAG"] = x[which(y==uY) - 1]
    } else {
      Res["TLAG"] = 0
    }
    Res["CLST"] = uY
    Res["TLST"] = x[y==uY][1]
    Res["LAMZNPT"] = 0
    Res["b0"] = uY
    return(Res)
  }

  iLastNonZero = max(which(y > 0)) # Index of last non-zero y
  x0 = x[1:iLastNonZero] # Till Non-zero concentration. i.e. removing trailing zeros
  y0 = y[1:iLastNonZero] # Till Non-zero concentration. i.e. removing trailing zeros

  x1 = x0[y0 != 0]       # remove all points with zeros in y (including mid) for LAMZ
  y1 = y0[y0 != 0]       # remove all points with zeros in y

  if (UT(adm) == "BOLUS") {
    if (y[1] > y[2] & y[2] > 0) {
      C0 = exp(-x[1]*(log(y[2]) - log(y[1]))/(x[2] - x[1]) + log(y[1]))
    } else {
      C0 = y[x==min(x[y > 0])]
    }
    x2 = c(0, x)
    y2 = c(C0, y)
    x3 = c(0, x0)
    y3 = c(C0, y0)
  } else {
    if (is.na(x[x==0][1])) {
      x2 = c(0, x)
      y2 = c(0, y)
      x3 = c(0, x0)
      y3 = c(0, y0)
    } else {
      x2 = x             # for AUCALL including trailing zero y values
      y2 = y
      x3 = x0            # for AUCLST without trailing zero y values
      y3 = y0
    }
  }

  tRes = BestSlope(x1, y1, adm)
  if (R2ADJ > 0) {
    if (tRes["LAMZNPT"] < 2) {
      tRes = DetSlope(x1, y1)
    } else if (tRes["R2ADJ"] < R2ADJ) {
      tRes = DetSlope(x1, y1, sel.1=which(x1 == tRes["LAMZLL"]), sel.2=which(x1 == tRes["LAMZUL"]))
    }
  }
  
  attr(tRes, "UsedPoints") = attr(tRes, "UsedPoints") + which(x==tRes["LAMZLL"]) - which(x1==tRes["LAMZLL"]) ###
  Res[c("R2", "R2ADJ", "LAMZNPT", "LAMZ", "b0", "CORRXY", "LAMZLL", "LAMZUL", "CLSTP")] = tRes
  tabAUC = AUC(x3, y3, down)
  Res[c("AUCLST","AUMCLST")] = tabAUC[length(x3),]
  Res["AUCALL"] = AUC(x2, y2, down)[length(x2),1]
  Res["LAMZHL"] = log(2)/Res["LAMZ"]
  Res["TMAX"] = x[which.max(y)][1]
  Res["CMAX"] = max(y)
  Res["TLST"] = x[iLastNonZero]
  Res["CLST"] = y[iLastNonZero]
  Res["AUCIFO"] = Res["AUCLST"] + Res["CLST"]/Res["LAMZ"]
  Res["AUCIFP"] = Res["AUCLST"] + Res["CLSTP"]/Res["LAMZ"]
  Res["AUCPEO"] = (1 - Res["AUCLST"]/Res["AUCIFO"])*100
  Res["AUCPEP"] = (1 - Res["AUCLST"]/Res["AUCIFP"])*100
  Res["AUMCIFO"] = Res["AUMCLST"] + Res["CLST"]*Res["TLST"]/Res["LAMZ"] + Res["CLST"]/Res["LAMZ"]/Res["LAMZ"]
  Res["AUMCIFP"] = Res["AUMCLST"] + Res["CLSTP"]*Res["TLST"]/Res["LAMZ"] + Res["CLSTP"]/Res["LAMZ"]/Res["LAMZ"]
  Res["AUMCPEO"] = (1 - Res["AUMCLST"]/Res["AUMCIFO"])*100
  Res["AUMCPEP"] = (1 - Res["AUMCLST"]/Res["AUMCIFP"])*100

  if (!is.na(dose) & dose > 0) {
    Res["CMAXD"] = Res["CMAX"]/dose
    Res["AUCIFOD"] = Res["AUCIFO"]/dose
    Res["AUCIFPD"] = Res["AUCIFP"]/dose
  }

  if (UT(adm) == "BOLUS") {
    Res["C0"] = C0                      # Phoneix WinNonlin 6.4 User's Guide p27
    Res["AUCPBEO"] = tabAUC[2,1]/Res["AUCIFO"]*100
    Res["AUCPBEP"] = tabAUC[2,1]/Res["AUCIFP"]*100
  } else {
    if (sum(y0==0) > 0) Res["TLAG"] = x0[max(which(y0==0))] # Trailing zero should not exist
    else Res["TLAG"] = 0
    if (!is.na(x0[x0==0][1])) {
      if (y0[x0==0] > 0) Res["TLAG"] = 0    # This is WinNonlin logic
    }
  }

  if (UT(adm) == "EXTRAVASCULAR") {
    Res["VZFO"] = dose/Res["AUCIFO"]/Res["LAMZ"]
    Res["VZFP"] = dose/Res["AUCIFP"]/Res["LAMZ"]
    Res["CLFO"] = dose/Res["AUCIFO"]
    Res["CLFP"] = dose/Res["AUCIFP"]
    Res["MRTEVLST"] = Res["AUMCLST"]/Res["AUCLST"]
    Res["MRTEVIFO"] = Res["AUMCIFO"]/Res["AUCIFO"]
    Res["MRTEVIFP"] = Res["AUMCIFP"]/Res["AUCIFP"]
  } else {
    Res["VZO"] = dose/Res["AUCIFO"]/Res["LAMZ"]
    Res["VZP"] = dose/Res["AUCIFP"]/Res["LAMZ"]
    Res["CLO"] = dose/Res["AUCIFO"]
    Res["CLP"] = dose/Res["AUCIFP"]
    Res["MRTIVLST"] = Res["AUMCLST"]/Res["AUCLST"] - dur/2
    Res["MRTIVIFO"] = Res["AUMCIFO"]/Res["AUCIFO"] - dur/2
    Res["MRTIVIFP"] = Res["AUMCIFP"]/Res["AUCIFP"] - dur/2
    Res["VSSO"] = Res["MRTIVIFO"]*Res["CLO"]
    Res["VSSP"] = Res["MRTIVIFP"]*Res["CLP"]
  }

  Units = Unit(doseUnit=doseUnit, timeUnit=timeUnit, concUnit=concUnit, MW=MW)
  for (i in 1:length(Res)) Res[i] = Res[i] * Units[names(Res[i]),2]

  if (is.data.frame(iAUC)) { # eg iAUC = data.frame(Name=c("AUC[0-12h]","AUC[0-24h]"), Start=c(0,0), End=c(12,24))
    niAUC = nrow(iAUC)
    if (niAUC > 0) {
       RetNames = union(RetNames1, as.character(iAUC[,"Name"]))
       for (i in 1:niAUC) {
        if (adm == "BOLUS") Res[as.character(iAUC[i,"Name"])] = IntAUC(x2, y2, iAUC[i,"Start"], iAUC[i,"End"], Res, down=down)
        else Res[as.character(iAUC[i,"Name"])] = IntAUC(x, y, iAUC[i,"Start"], iAUC[i,"End"], Res, down=down)
      }
    }
  } else {
    niAUC = 0
  }

  attr(Res, "units") = c(Units[RetNames1,1], rep(Units["AUCLST",1], niAUC))
  attr(Res, "UsedPoints") = attr(tRes, "UsedPoints")
  return(Res)
}

