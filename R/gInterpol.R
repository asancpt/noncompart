gInterpol = function(x, y, xnew, Outer = "NEAREST")
{
  if (is.unsorted(x)) stop("x vector should be sorted in the ascending order!")
  Result = list(x, y) # Default return value

  n = length(x)
  if (n != length(y)) {
    warning("Interpol: Lengths of x and y are different!")
    newN = min(n, length(y))
    x = x[1:newN]
    y = y[1:newN]
  }

  if (!is.numeric(x) | !is.numeric(y)) return(Result)
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
    ynew = y1 + (y2 - y1)/(x2 - x1)*(xnew - x1)
  } else if (LEFT==FALSE & RIGHT==FALSE) {
    return(list(NA, NA))
  } else if (toupper(trimws(Outer)) == "NEAREST") {
    if (LEFT==TRUE & RIGHT==FALSE) {
      ynew = y[n]
    } else if (LEFT==FALSE & RIGHT==TRUE) {
      ynew = y[1]
    }
  } else {
    return(list(NA, NA))
  }

  Result = list(sort(c(x, xnew)), c(y, ynew)[order(c(x, xnew))])
  return(Result)
}
