Interpol = function(x, y, xnew, Slope=0, b0=0, down="Linear")
{
# Author: Kyun-Seop Bae k@acr.kr
# Last modification: 2017.7.24
# Called by: IntAUC
# INPUT
#   x: time or similar vector
#   y: concentration or similear vector
#   xnew: new x point to be interpolated
#   Slope: terminal slope of log(y) ~ x
#   b0: intercept of log(y) ~ x
#   down: "Linear" or "Log"
# RETURNS
  Result = list(x, y) # Default return value

# Input check
  n = length(x)
  if (n != length(y)) {
    warning("Interpol: Length of x and y are different!")
    newN = min(n, length(y))
    x = x[1:newN]
    y = y[1:newN]
  }

  if (!is.numeric(x) | !is.numeric(y) | !is.character(down)) {
    return(Result)
  }

  if (xnew %in% x) return(Result)

  if (sum(x < xnew) > 0) {
    LEFT = TRUE
    x1 = x[max(which(x < xnew))]
    y1 = y[max(which(x < xnew))]
  } else LEFT = FALSE

  if (sum(x > xnew) > 0) {
    RIGHT = TRUE
    x2 = x[min(which(x > xnew))]
    y2 = y[min(which(x > xnew))]
  } else RIGHT = FALSE

  if (LEFT==TRUE & RIGHT==TRUE) {
    if (toupper(trimws(down)) == "LOG" & y2 < y1 & y2 > 0) {
      ynew = exp(log(y1) + (log(y2) - log(y1))/(x2 - x1)*(xnew - x1))
    } else {
      ynew = y1 + (y2 - y1)/(x2 - x1)*(xnew - x1)
    }
  }

  if (LEFT==TRUE & RIGHT==FALSE) ynew = exp(b0 - Slope*xnew)  # NOT ynew = exp(log(y1) - Slope*(xnew - x1))
  if (LEFT==FALSE & RIGHT==TRUE) ynew = y2/x2 * xnew
  if (LEFT==FALSE & RIGHT==FALSE) return(Result)

  Result = list(sort(c(x, xnew)), c(y, ynew)[order(c(x, xnew))])
  return(Result)
}
