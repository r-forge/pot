

dexi <- function(x, n.sim = 1000, n.mc = length(x$data),
                 plot = TRUE, ...){
  
  thresh <- x$threshold
  scale <- x$param["scale"]
  shape <- x$param["shape"]
  alpha <- x$param["alpha"]
  pat <- x$pat
  model <- x$model
  
  scale.new <- shape * thresh / (pat^(-shape) - 1)

  if (model %in% c("log", "nlog"))
    param <- list(alpha = alpha)

  if (model %in% c("alog", "anlog"))
    param <- list(alpha = alpha, asCoef1 = x$param["asCoef1"],
                  asCoef2 = x$param["asCoef2"])

  if (model == "mix")
    param <- list(alpha = alpha, asCoef = 0)
  
  if (model == "amix")
    param <- list(alpha = alpha, asCoef = x$param["asCoef"])

  param <- c(param, list(n = n.mc, model = model))

  exi <- rep(0, n.sim)
  mc <- rep(0, n.mc)
  
  for (i in 1:n.sim){
    mc <- do.call("simmc", param)
    mc <- qgpd(mc, 0, scale.new, shape)

    while(sum(mc > thresh) < 2){
      mc <- do.call("simmc", param)
      mc <- qgpd(mc, 0, scale.new, shape)
    }
    
    exi[i] <- fitexi(mc, thresh)$exi
  }

  if (plot)
    plot(density(exi, bw = sd(exi) /2), ...)
  
  invisible(exi)
}
