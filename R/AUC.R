AUC = function(x, y, down="Linear")
{
# Author: Kyun-Seop Bae k@acr.kr
# Last modification; 2017-07-24
# Called by: sNCA
# Calls: UT
# INPUT
#    x: time or similar vector
#    y: concentration or similar vector

  n = length(x)
# RETURNS
  Result = c(AUC = rep(NA_real_, n),   # vector of cumulative AUC
             AUMC = rep(NA_real_, n))  # vector of cumulative AUMC
# Input check  
  if (n != length(y) | !is.numeric(x) | !is.numeric(y)) return(Result)  

#
  Res = matrix(nrow=n, ncol=2) # temporary result
  Res[1,] = c(0, 0)
  for (i in 2:n) {
    if (y[i] >= y[i - 1]) { # if upward
      Res[i,1] = (x[i] - x[i-1])*(y[i] + y[i-1])/2 
      Res[i,2] = (x[i] - x[i-1])*(x[i]*y[i] + x[i-1]*y[i-1])/2
    } else if (toupper(trimws(down)) == "LINEAR") { # downward & linear
      Res[i,1] = (x[i] - x[i-1])*(y[i] + y[i-1])/2 
      Res[i,2] = (x[i] - x[i-1])*(x[i]*y[i] + x[i-1]*y[i-1])/2
    } else if (toupper(trimws(down)) == "LOG") { # downward & log
      k = (log(y[i - 1]) - log(y[i]))/(x[i] - x[i-1]) # -k slope in y-log scale
      Res[i,1] = (y[i-1] - y[i])/k
      Res[i,2] = (x[i-1]*y[i-1] - x[i]*y[i])/k + (y[i-1] - y[i])/k/k
    } else {
      Res[i,1] = NA_real_
      Res[i,2] = NA_real_
    }
  }
  Result = cbind(AUC=cumsum(Res[,1]), AUMC=cumsum(Res[,2]))
  return(Result)
}
