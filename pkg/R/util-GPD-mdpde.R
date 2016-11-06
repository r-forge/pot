

##   6) Minimum Density Power Divergence Estimator



##MDPD estimators for the GPD.
gpdmdpd <- function(x, threshold, a, start, ...,
                    method = "BFGS", warn.inf = TRUE){
  
  if ( length(unique(threshold)) != 1){
    warning("Threshold must be a single numeric value for est = 'mdpd'. Taking only the first value !!!")
    threshold <- threshold[1]
  }
  
  if (missing(a))
    a <- .1
  
  nn <- length(x)
  
  threshold <- rep(threshold, length.out = nn)
  
  high <- (x > threshold) & !is.na(x)
  threshold <- as.double(threshold[high])
  exceed <- as.double(x[high])
  nat <- length(exceed)
  
  excess <- exceed - threshold
  
  if(!nat) stop("no data above threshold")
  
  pat <- nat/nn
    
  if(missing(start)) {
    start <- list(scale = 0, shape = 0.01)
    start$scale <- mean(exceed) - min(threshold)
  }

  start <- c(scale = start$scale, shape = start$shape)
  
  pddf <- function(param){
    ## Evaluates the (P)ower (D)ensity (D)ivergence (F)unction which is
    ## criterion function of the MDPDE
    scale <- param[1]
    shape <- param[2]
    
    if ( ((max(excess)  < (-scale / shape)) && (shape < 0)) ||
        (shape > 0) ){
      y <- pmax(0, 1 + shape * excess / scale)^
      ((-1/shape - 1) * a)
      c1 <- 1 / (scale^a * (1 + a + a * shape))
      c2 <- (1 + 1/a ) / scale^a
      div <- c1 - c2 * mean(y)
    }

    else
      div <- 1e6
    
    return(div)
  }
  
  opt <- optim(start, pddf, hessian = TRUE, ..., method = method)
  
  if ((opt$convergence != 0) || (opt$value == 1e6)) {
    warning("optimization may not have succeeded")
    if(opt$convergence == 1) opt$convergence <- "iteration limit reached"
  }
  
  else opt$convergence <- "successful"
  
  shape <- opt$par[2]
  scale <- opt$par[1]
  
  param <- c(scale, shape)
  names(param) <- c("scale", "shape")
  
  std.err <- std.err.type <- var.cov <- corr <- NULL
  
  var.thresh <- FALSE
  
  list(fitted.values = opt$par, std.err = std.err, std.err.type = std.err.type,
       var.cov = var.cov, fixed = NULL, param = param,
       deviance = NULL, corr = corr, convergence = opt$convergence,
       counts = opt$counts, message = opt$message, threshold = threshold,
       nat = nat, pat = pat, data = x, exceed = exceed,
       scale = scale, var.thresh = var.thresh, est = "MDPD",
       opt.value = opt$value)
}





