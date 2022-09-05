IntAUC = function(x, y, t1, t2, Res, down="Linear")
{
# Author: Kyun-Seop Bae k@acr.kr
# Last modification: 2017.7.24
# Called by: sNCA
# Calls: Interpol, LinAUC, LogAUC, UT
# INPUT
#    x: time
#    y: natural log of concentration
#   t1: time of start. This could be interpolated, if this is not included in x.
#   t2: time of end. This could be interpolated, if this is not included in x.
#  Res: result of sNCA
#  down: "Linear" or "Log" 
# RETURN
#  Interval AUC

# Input check
  if (all(y == 0) & min(x, na.rm=T) <= t1 & max(x, na.rm=T) >= t2) return(0)
  n = length(x)  
  if (n != length(y) | !is.numeric(x) | !is.numeric(y)) return(NA_real_)
  if (is.na(Res["TLST"]) | t1 > Res["TLST"]) return(NA_real_)

  tL = Res["TLST"]
  if (t2 > max(x[!is.na(y)]) & is.na(Res["LAMZ"])) return(NA_real_)

  newSeries = Interpol(x, y, t1, Res["LAMZ"], Res["b0"], down=down)
  newSeries = Interpol(newSeries[[1]], newSeries[[2]], t2, Res["LAMZ"], Res["b0"], down=down)
  x = newSeries[[1]]
  y = newSeries[[2]]

  if (toupper(trimws(down))=="LINEAR") {
    if (t2 <= tL) {
      Result = LinAUC(x[x>=t1 & x<=t2], y[x>=t1 & x<=t2])[[1]]
    } else {
      Result = LinAUC(x[x>=t1 & x<=tL], y[x>=t1 & x<=tL])[[1]] + LogAUC(x[x>=tL & x<=t2], y[x>=tL & x<=t2])[[1]]
    }
  } else if (toupper(trimws(down))=="LOG") {
    Result = LogAUC(x[x>=t1 & x<=t2], y[x>=t1 & x<=t2])[[1]]
  } else {
    Result = NA_real_
  }

  return(Result)
}
