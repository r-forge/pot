##A function to compute spectral densities for each dependance
##models



##The generic function for graphical diagnostic of a bivariate
##pot object
plot.bvpot <- function(x, mains, which = 1:3,
                       ask = nb.fig < length(which) &&
                       dev.interactive(), ...){
  if (!inherits(x, "bvpot"))
    stop("Use only with 'bvpot' objects")

  if (!is.numeric(which) || any(which < 1) || any(which > 3)) 
        stop("`which' must be in 1:3")

  if(missing(mains))
    mains <- c("Pickands' Dependence Function",
               "Bivariate Return Level Plot", "Spectral Density")

  else
    if (length(mains) != 3){
      warning("``mains'' must be of length two. Passing to default titles.")
      mains <- c("Pickands' Dependence Function",
                 "Bivariate Return Level Plot", "Spectral Density")
    }


  show <- rep(FALSE, 3)
  show[which] <- TRUE
  nb.fig <- prod(par("mfcol"))
  
  if (ask){
    op <- par(ask = TRUE)
    on.exit(par(op))
  }

  if (show[1])
    pickdep(x, main = mains[1], ...)

  if (show[2])
    retlev(x, main = mains[2], ...)

  if (show[3])
    specdens(x, main = mains[3], ...)

}
