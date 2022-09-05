BestSlope = function(x, y, adm="Extravascular", TOL=1e-4, excludeDelta=1)
{
  Result = c(R2 = NA,     # R square
             R2ADJ = NA,  # R square adjusted
             LAMZNPT = 0, # Number of points for Lambda z
             LAMZ = NA,   # Lambda z, terminal slope as a positive number
             b0 = NA,     # intercept from OLS, i.e. simple linear regression
             CORRXY = NA, # Correlation of x, y
             LAMZLL = NA, # Lower time for lambda z
             LAMZUL = NA, # Upper time for lambda z
             CLSTP = NA)  # Clast predicted
# Input Check
  if (excludeDelta < 0) stop("Option excludeDelta should be non-negative!") 
  n = length(x)
  if (n == 0 | n != length(y) | !is.numeric(x) | !is.numeric(y) | length(y[y < 0]) > 0) {
    Result["LAMZNPT"] = 0
    return(Result)
  }

  if (length(unique(y)) == 1) { # Case of all the same values
    Result["LAMZNPT"] = 0
    Result["b0"] = unique(y)
    return(Result)
  }

  r0 = Result
  if (toupper(trimws(adm)) == "BOLUS") {
    locStart = which.max(y)      # From Tmax (for Bolus)
  } else {
    locStart = which.max(y) + 1  # From next to Tmax (for the others)
  }
  locLast = max(which(y > 0))    # Till non-zero concentration

  if (is.na(locStart) | is.na(locLast)) {
    Result["LAMZNPT"] = 0
    return(Result)
  }

  if (locLast - locStart < 2) {  # Too few to fit, if this is 2, R2ADJ becomes NaN.
    r0["LAMZNPT"] = 0
  } else {
    tmpMat = matrix(nrow=(locLast - locStart - 1), ncol=length(r0))
    colnames(tmpMat) = names(r0)
    for (i in locStart:(locLast - 2)) {
      tmpMat[i - locStart + 1, 1:8] = Slope(x[i:locLast], log(y[i:locLast]))
    }
    tmpMat = tmpMat[is.finite(tmpMat[,"R2ADJ"]) & tmpMat[,"LAMZNPT"] > 2, , drop=FALSE]

    if (nrow(tmpMat) > 0) {
      maxAdjRsq = max(tmpMat[,"R2ADJ"])
      OKs = ifelse(abs(maxAdjRsq - tmpMat[,"R2ADJ"]) < TOL, TRUE, FALSE)
      nMax = max(tmpMat[OKs,"LAMZNPT"])
      r0 = tmpMat[OKs & tmpMat[,"LAMZNPT"]==nMax,]
      r0["CLSTP"] = exp(r0["b0"] - r0["LAMZ"]*max(x[is.finite(y)]))
    } else {
      r0["LAMZNPT"] = 0
    }
  }

  if (excludeDelta < 1) {
    x1 = x[-n]
    y1 = y[-n]
    r1 = Result

    if (toupper(trimws(adm)) == "BOLUS") {
      locStart = which.max(y1)      # From Tmax (for Bolus)
    } else {
      locStart = which.max(y1) + 1  # From next to Tmax (for the others)
    }
    locLast = max(which(y1 > 0))    # Till non-zero concentration

    if (locLast - locStart < 2) {  # Too few to fit, if this is 2, R2ADJ becomes NaN.
      r1["LAMZNPT"] = 0
    } else {
      tmpMat = matrix(nrow=(locLast - locStart - 1), ncol=length(r1))
      colnames(tmpMat) = names(r1)
      for (i in locStart:(locLast - 2)) {
        tmpMat[i - locStart + 1, 1:8] = Slope(x1[i:locLast], log(y1[i:locLast]))
      }
      tmpMat = tmpMat[tmpMat[,"LAMZNPT"] > 2, , drop=FALSE]

      if (nrow(tmpMat) > 0) {
        maxAdjRsq = max(tmpMat[,"R2ADJ"])
        OKs = ifelse(abs(maxAdjRsq - tmpMat[,"R2ADJ"]) < TOL, TRUE, FALSE)
        nMax = max(tmpMat[OKs,"LAMZNPT"])
        r1 = tmpMat[OKs & tmpMat[,"LAMZNPT"]==nMax,]
        r1["CLSTP"] = exp(r1["b0"] - r1["LAMZ"]*max(x[is.finite(y)]))
      } else {
        r1["LAMZNPT"] = 0
      }
    }

    if (is.na(r1["R2ADJ"])) {
      Result = r0
    } else if (is.na(r0["R2ADJ"])) {
      Result = r1
    } else if (r1["R2ADJ"] - r0["R2ADJ"] > excludeDelta) {
      Result = r1
    } else {
      Result = r0
    }
  } else {
    Result = r0
  }

  if (Result["LAMZNPT"] > 0) {
    attr(Result, "UsedPoints") = which(x==Result["LAMZLL"]):which(x==Result["LAMZUL"])
  } else {
    attr(Result, "UsedPoints") = NULL
  }

  return(Result)
}
