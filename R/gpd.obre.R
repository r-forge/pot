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

  J <- matrix(c(a11, a12, a12, a22), nrow = 2)
  J.eig <- eigen(J)

  if (any(J.eig$values < 0))
    return("Expected Information Matrix of Fisher is singular !")

  A <- t(J.eig$vector %*% diag( 1 / sqrt(J.eig$values) ))
  a.vec <- matrix(c(0,0), nrow = 2)
  
  while( iter < maxit){
    iter <- iter + 1

    y <- 1 + start[2] * excess / start[1]
    S.shape <- -1/start[2] * log(y) + 1/start[2]*(1/start[2] - 1) *
      (1 - 1/y) - a.vector[1]
    S.scale <- -1/(start[1] * start[2]) + 1/start[1] (1/start[2] - 1) / y -
      a.vector[2]

    score <- rbind(S.scale, S.shape)
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
      a.vec <- 
      
    
      }
  }
}
