

##Little functions that computes return period from non exceedance
##probability and viceversa
rp2prob <- function(retper, npy){
  ##retper   : the return period
  ##npy : the mean Number of events Per Year
  
  if (any(npy <=0))
    stop("``npy'' must be positive !!!")
  if (any(retper < 1/npy))
    stop("return period incompatible with ``npy'' !!!")
  prob <- 1 - 1/(npy * retper)
  
  tab <- cbind(npy = npy, retper = retper, prob = prob)
  rownames(tab) <- 1:length(tab[,1])
  return(tab)
}
prob2rp <- function(prob, npy){
  ##prob   : the probability of non exceedance
  ##npy    : the mean (N)umber of events (P)er (Y)ear
  
  if (any(npy <=0))
    stop("``npy'' must be positive !!!")
  if (any(prob <0) | any(prob >= 1) )
    stop("``prob'' must be in [0,1) !!!")
  
  retper <- 1 / (npy * (1 - prob))
  
  tab <- cbind(npy = npy, retper = retper, prob = prob)
  rownames(tab) <- 1:length(tab[,1])
  return(tab)
} 


