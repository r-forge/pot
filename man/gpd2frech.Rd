\name{gpd2frech}
\alias{gpd2frech}
\title{Transform GPD observations to Unit Frechet ones}
\description{
  Transform GPD observations to Unit Frechet ones
}
\usage{
gpd2frech(x, loc = 0, scale = 1, shape = 0, pat = 1)
}
\arguments{
  \item{x}{The vector of observations.}
  \item{loc,scale,shape}{The location, scale and shape parameters
    respectively.}
  \item{pat}{The proportion above the threshold, i.e. Pr[X > log] =
    pat.}  
}
\value{
  A numeric vector.
}
\details{
  Let \eqn{x_i}{x_i}, \eqn{i=1,\ldots,n}{i=1,\dots,n} be the realisation
  of a GPD random variable. Thus, the transformation to unit Frechet is
  defined as:

  \deqn{z_i = - \frac{1}{\log\left[1 - pat \left(1 + shape \frac{x_i -
	loc}{scale}\right)_+^{-1/shape}\right]}}{z_i = -1 / log [1 - pat
	(1 + shape *(x_i - loc) / scale)_+^(-1/shape)]}
}
\examples{
x <- rgpd(10, 0, 1, 0.25)
gpd2frech(x, 0, 1, 0.25)
}
\author{Mathieu Ribatet}
\keyword{manip}
