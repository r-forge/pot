##This file contains new methods for the R package



qq <- function(fitted, ...)
  UseMethod("qq")
qq.default <- function(fitted, ...)
  return(fitted)

