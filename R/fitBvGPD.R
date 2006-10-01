fitbvgpd <- function (data1, data2, threshold, model, start,
                      ..., obs.fish = TRUE, corr = FALSE,
                      warn.inf = TRUE, method = "BFGS"){

  call <- match.call()
  n1 <- length(data1)
  exceed1 <- data1[data1>threshold[1] & !is.na(data1)]
  nhigh1 <- nat1 <- length(exceed1)
  pat1 <- nat1 / (n1)
  
  if (!nhigh1)
    stop("No data above threshold for margin 1")

  n2 <- length(data2)
  exceed2 <- data2[data2>threshold[2] & !is.na(data2)]
  nhigh2 <- nat2 <- length(exceed2)
  pat2 <- nat2 / (n2)

  
  if (n1 != n2)
    stop("data1 does not have the same length as data2")

  else
    n <- n1

  nhigh <- c(nhigh1, nhigh2)
  nat <- c(nat1, nat2)
  pat <- c(pat1, pat2)
  names(nhigh) <- names(nat) <- names(pat) <- paste("Marge", 1:2)
  names(threshold) <- paste("Marge", 1:2)
  
  if (!nhigh2)
    stop("No data above threshold for margin 2")

  if (any(is.na(data1))){
    warning("NAs present in data1. Replacing them by the threshold.")
    data1[is.na(data1)] <- threshold[1]
  }
  if (any(is.na(data2))){
    warning("NAs present in data2. Replacing them by the threshold.")
    data2[is.na(data2)] <- threshold[2]
  }

  param <- c("scale1", "scale2", "shape1", "shape2", "alpha")
  
  ##Creating suited starting values according to the chosen
  ##model (if needed) that is MLE estimates on margin data
  if (missing(start)){
    start <- list(scale1 = 0, scale2 = 0, shape1 = 0,
                  shape2 = 0)
    temp <- gpdmle(exceed1, threshold[1])$param
    start$scale1 <- temp[1]
    start$shape1 <- temp[2]
    temp <- gpdmle(exceed2, threshold[2])$param
    start$scale2 <- temp[1]
    start$shape2 <- temp[2]
        
    if (model == "log")
      start <- c(start, list(alpha = 0.75))
    if (model == "nlog")
      start <- c(start, list(alpha = 0.6))
    if (model == "alog")
      start <- c(start, list(alpha = 0.75, asCoef1 = 0.75,
                             asCoef2 = 0.75))
    if (model == "anlog")
      start <- c(start, list(alpha = 0.6, asCoef1 = 0.75,
                             asCoef2 = 0.75))
    if (model == "mix")
      start <- c(start, list(alpha = 0.25))
    if (model == "amix")
      start <- c(start, list(alpha = 0.75, asCoef = 0))
  }

  start <- start[!(param %in% names(list(...)))]

  if (!is.list(start)) 
    stop("`start' must be a named list")
  if (!length(start)) 
    stop("there are no parameters left to maximize over")

  ##Creating suited negative log-likelihood according to the
  ##specified model
  if (model == "log")
    nlbvpot <- function(scale1, shape1, scale2, shape2, alpha)
      -.C("gpdbvlog", data1, data2, n, pat1, pat2, threshold,
          scale1, shape1, scale2, shape2, alpha,
          dns = double(1))$dns
  if (model == "nlog")
    nlbvpot <- function(scale1, shape1, scale2, shape2, alpha)
      -.C("gpdbvnlog", data1, data2, n, pat1, pat2, threshold,
          scale1, shape1, scale2, shape2, alpha, dns = double(1))$dns    
  if (model == "alog"){
    nlbvpot <- function(scale1, shape1, scale2, shape2, alpha,
                        asCoef1, asCoef2)
      -.C("gpdbvalog", data1, data2, n, pat1, pat2, threshold,
          scale1, shape1, scale2, shape2, alpha, asCoef1,
          asCoef2, dns = double(1))$dns
    param <- c(param, "asCoef1", "asCoef2")
  }
  if (model == "anlog"){
    nlbvpot <- function(scale1, shape1, scale2, shape2, alpha,
                        asCoef1, asCoef2)
      -.C("gpdbvanlog", data1, data2, n, pat1, pat2, threshold,
          scale1, shape1, scale2, shape2, alpha, asCoef1,
          asCoef2, dns = double(1))$dns
    param <- c(param, "asCoef1", "asCoef2")
  }
  if (model == "mix")
    nlbvpot <- function(scale1, shape1, scale2, shape2, alpha)
      -.C("gpdbvmix", data1, data2, n, pat1, pat2, threshold,
          scale1, shape1, scale2, shape2, alpha,
          dns = double(1))$dns
  if (model == "amix"){
    nlbvpot <- function(scale1, shape1, scale2, shape2, alpha,
                        asCoef)
      -.C("gpdbvamix", data1, data2, n, pat1, pat2, threshold,
          scale1, shape1, scale2, shape2, alpha, asCoef,
          dns = double(1))$dns
    param <- c(param, "asCoef")
  }    
  
  nm <- names(start)
  l <- length(nm)
  f <- formals(nlbvpot)
  names(f) <- param
  m <- match(nm, param)
  
  if (any(is.na(m))) 
    stop("`start' specifies unknown arguments")
  
  formals(nlbvpot) <- c(f[m], f[-m])
  nllh <- function(p, ...) nlbvpot(p, ...)

  if (l > 1) 
    body(nllh) <- parse(text = paste("nlbvpot(", paste("p[", 
                          1:l, "]", collapse = ", "), ", ...)"))
  
  fixed.param <- list(...)[names(list(...)) %in% param]

  if (any(!(param %in% c(nm, names(fixed.param))))) 
    stop("unspecified parameters")
  
  start.arg <- c(list(p = unlist(start)), fixed.param)
  
  if (warn.inf && do.call("nllh", start.arg) == 1e+06) 
    warning("negative log-likelihood is infinite at starting values")

  opt <- optim(start, nllh, hessian = TRUE, ..., method = method)

  if (opt$convergence != 0) {
    warning("optimization may not have succeeded")

    if (opt$convergence == 1) 
      opt$convergence <- "iteration limit reached"
  }
  
  else opt$convergence <- "successful"

  tol <- .Machine$double.eps^0.5

  if(obs.fish) {
    
    var.cov <- qr(opt$hessian, tol = tol)
    if(var.cov$rank != ncol(var.cov$qr)){
      warning("observed information matrix is singular.")
      obs.fish <- FALSE
      return
    }
    
    if (obs.fish){
      var.cov <- solve(var.cov, tol = tol)
      
      std.err <- diag(var.cov)
      if(any(std.err <= 0)){
        warning("observed information matrix is singular.")
        obs.fish <- FALSE
      }

      else{
        std.err <- sqrt(std.err)
        
        if(corr) {
          .mat <- diag(1/std.err, nrow = length(std.err))
          corr.mat <- structure(.mat %*% var.cov %*% .mat,
                                dimnames = list(nm,nm))
          diag(corr.mat) <- rep(1, length(std.err))
        }
        else {
          corr.mat <- NULL
        }
      
        std.err.type <- "Observed"
    
        colnames(var.cov) <- nm
        rownames(var.cov) <- nm
        names(std.err) <- nm
      }
    }

    if(!obs.fish)
      std.err.type <- std.err <- corr.mat <- var.cov <- NULL
  }
  
  param <- c(opt$par, unlist(fixed.param))
  
  var.thresh <- !all(threshold == threshold[1])

  fitted <- list(fitted.values = opt$par, std.err = std.err, std.err.type = std.err.type,
                 var.cov = var.cov, fixed = unlist(fixed.param), param = param,
                 deviance = 2*opt$value, corr = corr.mat, convergence = opt$convergence,
                 counts = opt$counts, message = opt$message, threshold = threshold,
                 nhigh = nhigh, nat = nat, pat = pat, data1 = data1, data2 = data2,
                 exceedances1 = exceed1, exceedances2 = exceed2, call = call,
                 var.thresh = var.thresh, type = "MLE", model = model,
                 logLik = -opt$value)

  chi <- 2 * (1 - pickFunplot(fitted, plot = FALSE)(0.5))
  fitted <- c(fitted, list(chi = chi))
  class(fitted) <- c("bvpot", "pot")
  print(fitted)
  invisible(fitted)
}
