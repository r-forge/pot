##A function to transform GPD observations to a unit Frechet scale
gpd2frech <- function(x, loc = 0, scale = 1, shape = 0, pat = 1){
  z <- pgpd(x, loc, scale, shape, lower.tail = FALSE)
  z <- -1 / log(1 - pat * z)
  return(z)
}
