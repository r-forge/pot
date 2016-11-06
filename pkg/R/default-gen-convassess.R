##This file contains new methods for the R package



convassess <- function(fitted, n = 50)
  UseMethod("convassess")
convassess.default <- function(fitted, n = 50)
  return(fitted)
