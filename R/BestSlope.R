BestSlope = function(x, y, adm="Extravascular", TOL=1e-4)
{
# Author: Kyun-Seop Bae k@acr.kr
# Last modification: 2017.7.19
# Called by : sNCA
# Calls : Slope, UT
# INPUT
#    x: time or similar vector
#    y: concentration or similar vector
#    adm: method of drug administration "Bolus", "Infusion", or "Extravascular"
#    TOL: Tolerance, see Phoneix WinNonlin 6.4 User's Guide p33
# RETURNS
  Result = c(R2 = NA,     # R square
             R2ADJ = NA,  # R square adjusted
             LAMZNPT = 0, # Number of points for Lambda z
             LAMZ = NA,   # Lambda z, terminal slope as a positive number
             b0 = NA,     # intercept from OLS, i.e. simple linear regression
             CORRXY = NA, # Correlation of x, y
             LAMZLL = NA, # Lower time for lambda z
             LAMZUL = NA, # Upper time for lambda z
             CLSTP = NA)  # Concentration last predicted in original scale
# Input Check
  n = length(x)
  if (n != length(y) | !is.numeric(x) | !is.numeric(y) | length(y[y < 0]) > 0) {
    Result["LAMZNPT"] = 0
    return(Result)
  }

  if (length(unique(y)) == 1) { # Case of all the same values
    Result["LAMZNPT"] = 0
    Result["b0"] = unique(y)
    return(Result)
  }

  if (UT(adm) == "BOLUS") {
    locStart = which.max(y)      # From Tmax (for Bolus)
  } else {
    locStart = which.max(y) + 1  # From next to Tmax (for the others)
  }
  locLast = max(which(y > 0))    # Till non-zero concentration

  if (locLast - locStart < 2) {  # Too few to fit, if this is 2, R2ADJ becomes NaN.
    Result["LAMZNPT"] = 0
    return(Result)
  }

  tmpMat = matrix(nrow=(locLast - locStart - 1), ncol=length(Result))
  colnames(tmpMat) = names(Result)
  for (i in locStart:(locLast - 2)) {
    tmpMat[i - locStart + 1,] = Slope(x[i:locLast], log(y[i:locLast]))
  }
  tmpMat = tmpMat[tmpMat[,"LAMZNPT"] > 2,,drop=FALSE]
  if (nrow(tmpMat) > 0) {
    maxAdjRsq = max(tmpMat[,"R2ADJ"])
    OKs = ifelse(abs(maxAdjRsq - tmpMat[,"R2ADJ"]) < TOL, TRUE, FALSE)
    nMax = max(tmpMat[OKs,"LAMZNPT"])
    Result = tmpMat[OKs & tmpMat[,"LAMZNPT"]==nMax,]
  } else {
    Result["LAMZNPT"] = 0
  }
  if (Result["LAMZNPT"] > 0) {
    attr(Result, "UsedPoints") = which(x==Result["LAMZLL"]):which(x==Result["LAMZUL"])
  } else {
    attr(Result, "UsedPoints") = NULL
  }
  return(Result)
}
