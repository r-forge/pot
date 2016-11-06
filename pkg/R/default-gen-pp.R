##This file contains new methods for the R package


pp <- function(fitted, ...)
  UseMethod("pp")
pp.default <- function(fitted, ...)
  return(fitted)

