

fitexi <- function(data, threshold){
  
   
  if (any(is.na(data))){
    warning("NA's are not allowed in object ``data''.\nReplacing them by the threshold !!!")
    data[is.na(data)] <- threshold
  }

  idx <- which(data > threshold)
  nat <- length(idx)
  interTim <- diff(idx)

  if (max(interTim) == 1)
    exi <- 0

  else{
    if (max(interTim) <= 2){
      exi <- 2 * sum(interTim - 1)^2 / (nat - 1) /
        sum((interTim - 1) * (interTim - 2)) 
      exi <- min(1, exi)
    }
    
    else{
      exi <- 2 * sum(interTim)^2 / (nat - 1) /
        sum(interTim^2)
      exi <- min(1, exi)
    }
  }
    
  C <- floor(exi * nat) + 1
  sortInterTim <- sort(interTim, decreasing = TRUE)

  if (C <= length(interTim))
    TC <- sortInterTim[C]

  else
    TC <- max(interTim)
  
  return(list(exi = exi, tim.cond = TC))
}

  
