gpdobre <- function(data, threshold, ...){

  if ( length(unique(threshold)) != 1){
    warning("Threshold must be a single numeric value for method = 'med'. Taking only the first value !!!")
    threshold <- threshold[1]
  }
  
  nn <- length(x)
  
  threshold <- rep(threshold, length.out = nn)
  
  high <- (x > threshold) & !is.na(x)
  threshold <- as.double(threshold[high])
  exceed <- as.double(x[high])
  nhigh <- nat <- length(exceed)
  
  excess <- exceed - threshold

  if(!nhigh) stop("no data above threshold")
  
  pat <- nat/nn
  param <- c("scale", "shape")
     
  start <- c(scale = 0, shape = 0.1)
  start["scale"] <- mean(exceed) - min(threshold)

  iter <- 1

  a11 <- 1 / (start[1]^2 * (1 + 2*start[2]))
  a12 <- 1 / (start[1] * (1+start[2]) * (1 + 2*start[2]))
  a22 <- 2 / ( (1+start[2]) * (1+2*start[2]) )

  J <- fish.gpd(start[1], start[2])
  J.eig <- eigen(J)

  if (any(J.eig$values < 0))
    return("Expected Information Matrix of Fisher is singular !")

  A <- t(J.eig$vector %*% diag( 1 / sqrt(J.eig$values) ))
  a.vec <- matrix(c(0,0), nrow = 2)
  
  while( iter < maxit){
    iter <- iter + 1

    score <- score.gpd(excess, start[1], start[2])
    idx <- which(score == NaN | !is.finite(score)) %% nhigh ##A trick to get only the row number
    Wp <- rep(NA, nhigh)
    Wp[idx] <- 0
    Wp[-idx] <- k / sqrt(colSums(A%*%(score-a.vec)^2))
    Wp <- min(1, Wp)^2

    M22 <- mean(S.shape^2 * Wp)
    M11 <- mean(S.scale^2 * Wp)
    M12 <- mean(S.scale * S.shape * Wp)

    Delta <- M11 * M22 - M12^2
    M2.inv <- matrix(c(M22, -M12, -M12, M11), nrow = 2) / Delta

    M2.inv.eigen <- eigen(M2.inv)

    if (any(M2.inv.eigen$values <= 0))
      return("Matrix M2 is singular !!!")

    else {
      A <- t(M2.inv.eigen$vectors %*% diag(sqrt(M2.inv.eigen$values)))
      a.vec <- update.aVec(scale, shape, A, a.vec, tol, k)

      eps1 <- dist(A - AOld)
      eps2 <- sqrt(sum((aVec - aVecOld)^2))

      if (eps1 < tolA & eps2 < tolaVec)
        
      
    
      }
  }
}

##Compute the score for the GPD
score.gpd <- function(excess, scale, shape){
  s.scale <- (excess - scale) / (scale * shape * excess + scale^2)
  s.shape <- log( shape * excess / scale + 1) / shape^2 -
    (1/shape + 1) * excess / (scale * (shape * excess / scale + 1))

  return(rbind(scale = s.scale, shape = s.shape))
}

##Compute the Expected Information of Fisher for the GPD
fish.gpd <- function(scale, shape){
  a11 <- 1 / (scale^2 * (1 + 2*shape))
  a12 <- 1 / (scale * (1+shape) * (1 + 2*shape))
  a22 <- 2 / ( (1+shape) * (1+2*shape) )

  fish <- matrix(c(a11, a12, a12, a22), nrow = 2)
  colnames(fish) <- rownames(fish) <- c("scale", "shape")
  return(fish)
}

update.aVec <- function(scale, shape, A, a.vec, tol, k){
  ##For the denominator
  integrand <- function(x)
    weights(scale, shape, x, A, a.vec, k) * pgpd(x, 0, scale, shape)

  if (shape < 0)
    denom <- integrate(integrand, lower = 0, upper = -scale/shape)$value

  else
    denom <- integrate(integrand, lower = 0, upper = Inf)$value

  ##For the scale parameter
  integrand <- function(x)
    score.gpd(x, scale, shape)["scale",] * weights(scale, shape, x, A, a.vec, k) *
      pgpd(x, 0, scale, shape)

  if (shape < 0)
    numScale <- integrate(integrand, lower = 0, upper = -scale/shape)$value

  else
    numScale <- integrate(integrand, lower = 0, upper = Inf)$value

  ##For the shape parameter
  integrand <- function(x)
    score.gpd(x, scale, shape)["shape",] * weights(scale, shape, x, A, a.vec, k) *
      pgpd(x, 0, scale, shape)

  if (shape < 0)
    numShape <- integrate(integrand, lower = 0, upper = -scale/shape)$value

  else
    numShape <- integrate(integrand, lower = 0, upper = Inf)$value

  
  aVec <- c(scale = numScale, shape = numShape) / denom

  return(aVec)
}
  
