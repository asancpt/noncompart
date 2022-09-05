gAUC = function(x, y, Ymax = "Emax", XofYmax = "TEmax", AUCname = "AUEClast", iAUC = "", Outer = "NEAREST")
{
  if (!(is.numeric(x) & is.numeric(y))) stop("Check the input type!")

  NApoints = is.na(x) | is.na(y)
  x = x[!NApoints]             # remove NA points in x
  if (is.unsorted(x)) stop("Check if the x is sorted!")
  y = y[!NApoints]             # remove NA points in y
  n = length(x)

  Res = list()
  Res[as.character(Ymax)]    = max(y)
  Res[as.character(XofYmax)] = x[which.max(y)][1]
  Res["Tfrst"] = x[1]
  Res["Tlast"] = x[n]
  Res[as.character(AUCname)] = sum((x[-1] - x[-n]) * (y[-1] + y[-n]))/2

  if (is.data.frame(iAUC)) { # eg iAUC = data.frame(Name=c("AUC[0-12h]","AUC[0-24h]"), Start=c(0,0), End=c(12,24))
    niAUC = nrow(iAUC)
    if (niAUC > 0) {
       for (i in 1:niAUC) {
          Res[as.character(iAUC[i,"Name"])] = gIntAUC(x, y, iAUC[i,"Start"], iAUC[i,"End"], Outer=Outer)
       }
    }
  }

  return(Res)
}
