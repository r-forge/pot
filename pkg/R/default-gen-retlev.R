##This file contains new methods for the R package
retlev <- function(fitted, ...)
  UseMethod("retlev")
retlev.default <- function(fitted, ...)
  return(fitted)

