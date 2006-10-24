##The generic function for graphical diagnostic of a Markov chain
##pot object
plot.mcpot <- function(x, npy, mains, which = 1:4,
                       ask = nb.fig < length(which) &&
                       dev.interactive(), acf.type = "partial",
                       ...){

  if (!is.numeric(which) || any(which < 1) || any(which > 4)) 
        stop("`which' must be in 1:4")

  if (missing(npy)){
    warning("Argument ``npy'' is missing. Setting it to 1.")
    npy <- 1
  }
  
  if(missing(mains))
    mains <- c("Auto-correlation Plot", "Pickands' Dependence Function",
               "Bivariate Return Level Plot", "Spectral Density")

  else
    if (length(mains) != 4){
      warning("``mains'' must be of length two. Passing to default titles.")
      mains <- c("Auto-correlation Plot", "Pickands' Dependence Function",
                 "Bivariate Return Level Plot", "Spectral Density")
    }


  show <- rep(FALSE, 4)
  show[which] <- TRUE
  nb.fig <- prod(par("mfcol"))
  
  if (ask){
    op <- par(ask = TRUE)
    on.exit(par(op))
  }

  if (show[1])
    acf(x$data, main = mains[1], type = acf.type, ...)
  if (show[2])
    pickdep(x, main = mains[2], ...)
  if (show[3])
    retlev(x, npy = npy, main = mains[3], points = FALSE, ...)
  if (show[4])
    specdens(x, main = mains[4], ...)

}
