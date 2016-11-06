

logLik.pot <- function(object, ...){
  if (!inherits(object, "pot"))
    stop("Use only with 'pot' objects")
  
  llk <- object$logLik
  attr(llk, "df") <- length(fitted(object))
  class(llk) <- "logLik"
  return(llk)
}


