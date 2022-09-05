gIntAUC = function(x, y, t1, t2, Outer = "NEAREST")
{
  x = x[is.finite(x)]
  y = y[is.finite(y)]
  n = length(x)  
  if (n == 0 | n != length(y)) return(NA_real_)
  if (is.unsorted(x)) stop("x vector should be sorted!")
  if (t1 > x[n] | t2 < x[1]) return(NA_real_)

  newSeries = gInterpol(x, y, t1, Outer=Outer)
  if (is.na(newSeries[[1]][1])) return(NA_real_) 
  newSeries = gInterpol(newSeries[[1]], newSeries[[2]], t2, Outer=Outer)
  if (is.na(newSeries[[1]][1])) return(NA_real_)
  x = newSeries[[1]]
  y = newSeries[[2]]

  x1 = x[x >= t1 & x <= t2]
  y1 = y[x >= t1 & x <= t2]
  n = length(x1)
  
  Res = sum((x1[-1] - x1[-n])*(y1[-1] + y1[-n]))/2

  return(Res)
}
