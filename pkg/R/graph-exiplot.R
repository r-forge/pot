

exiplot <- function(data, u.range, tim.cond = 1, n.u = 50,
                    xlab, ylab, ...){

  if (all(data <= u.range[1]))
    stop("No data above u.range[1] !!! Please specify suitable value.")

  if (missing(xlab))
    xlab <- "Threshold"

  if (missing(ylab))
    ylab <- "Extremal Index"

  if (missing(u.range))
    u.range <- c(min(data[,"obs"]), quantile(data[,"obs"], 0.9))
  
  u.range <- seq(u.range[1], u.range[2], length.out = n.u)

  exi <- rep(NA, n.u)
  
  for (i in 1:n.u)
    exi[i] <- attributes(clust(data, u.range[i], tim.cond = tim.cond))$exi

  plot(u.range, exi, xlab = xlab, ylab = ylab, ...)

  invisible(cbind(thresh = u.range, exi = exi))

}
    
