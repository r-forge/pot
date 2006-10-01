pickFunplot <- function(fitted, bound = TRUE, plot = TRUE,
                        ...){

  model <- fitted$model
  alpha <- fitted$param["alpha"]

  if (model == "log"){
    ##Logistic case :
    A <- function(w){
      if ( (w < 0) || (w > 1) )
        return(NaN)
      else
        ((1-w)^(1/alpha) + w^(1/alpha))^alpha
    }
  }
  
  if (model == "nlog"){
    ##Negative logistic case:
    A <- function(w){
      if ( (w < 0) || (w > 1) )
        return(NaN)
      else
        1 - ((1-w)^(-alpha) + w^(-alpha))^(-1/alpha)
    }
  }

  if (model == "alog"){
    ##Asymetric logistic case:
    asCoef1 <- fitted$param["asCoef1"]
    asCoef2 <- fitted$param["asCoef2"]
    A <- function(w){
      if ( (w < 0) || (w > 1) )
        return(NaN)
      else
        (1 - asCoef1)*(1-w) + (1 - asCoef2) * w +
          ( (asCoef1 * (1-w))^(1/alpha) +
           (asCoef2 * w)^(1/alpha) )^alpha
    }
  }

  if (model == "anlog"){
    ##Asymetric negatif logistic case:
    asCoef1 <- fitted$param["asCoef1"]
    asCoef2 <- fitted$param["asCoef2"]
    A <- function(w){
      if ( (w < 0) || (w > 1) )
        return(NaN)
      else
        1 - ( ((1-w)/asCoef1)^(-alpha) +
             (w/asCoef2)^(-alpha) )^(-1/alpha)
    }
  }

  if (model == "mix"){
    ##Mixed model:
    A <- function(w){
      if ( (w < 0) || (w > 1) )
        return(NaN)
      else
        1 - w * (1-w) * alpha
    }
  }

   if (model == "amix"){
    ##Asymetric Mixed model:
     asCoef <- fitted$param["asCoef"]
    A <- function(w){
      if ( (w < 0) || (w > 1) )
        return(NaN)
      else
        1 - (alpha + asCoef) * w + alpha * w^2 +
          asCoef * w^3
    }
  }

  if (plot){
    plot(A, ylim = c(0.5, 1), type = "n")
    
    if (bound){
      lines(x= c(0,1), y = c(1,1), col = "grey", ...)
      lines(x = c(0,0.5,1), y = c(1, 0.5, 1), col = "grey", ...)
    }
    plot(A, ylim = c(0.5, 1), add = TRUE)
  }
  
  attributes(A) <- list(model = model)
  invisible(A)
}
