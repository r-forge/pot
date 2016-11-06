##This file contains new methods for the R package



dens <- function(fitted, ...)
  UseMethod("dens")
dens.default <- function(fitted, ...)
  return(fitted)

