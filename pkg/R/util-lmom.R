

## First, we need a function which computes the samples L-moments

samlmu <- function (x, nmom = 4, sort.data = TRUE)
{
  xok <- x[!is.na(x)]
  n <- length(xok)
  if (nmom <= 0) return(numeric(0))
  if (nmom <= 2) rnames <- paste("l", 1:nmom, sep = "_")
  else rnames <- c("l_1", "l_2", paste("t", 3:nmom, sep = "_"))
  lmom <- rep(NA, nmom)
  names(lmom) <- rnames
  if (n == 0) return(lmom)
  if (sort.data == TRUE) xok <- sort(xok)
  nmom.actual <- min(nmom, n)
  
  lmom <- .C("samlmu", as.double(xok), as.integer(nmom.actual),
             as.integer(n), lmom = double(nmom.actual),
             PACKAGE = "POT")$lmom
  names(lmom) <- rnames
  return(lmom)
}



