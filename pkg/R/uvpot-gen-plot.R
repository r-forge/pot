## This file contains several functions to plot Peaks Over a Threshold.



plot.uvpot <- function(x, npy, main, which = 1:4,
                       ask = nb.fig < length(which) && 
                       dev.interactive(),ci = TRUE, ...){
  if(!inherits(x, "uvpot"))
    stop("Use only with 'uvpot' objects")
  
  if (!is.numeric(which) || any(which < 1) || any(which > 4)) 
        stop("`which' must be in 1:4")
    
  show <- rep(FALSE, 4)
  show[which] <- TRUE
  nb.fig <- prod(par("mfcol"))
  
  if (ask) {
    op <- par(ask = TRUE)
    on.exit(par(op))
  }
  if (show[1]) {
    pp.uvpot(x, ci = ci, main, xlim = c(0, 1), ylim = c(0, 1),
             ...)
  }
  if (show[2]) {
    qq.uvpot(x, ci = ci, main, ...)
  }
  if (show[3]) {
    dens.uvpot(x, main, ...)
  }
  if (show[4]) {
    retlev.uvpot(x, npy, main, ...)
  }
}
