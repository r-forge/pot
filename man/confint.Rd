\name{confint}
\alias{confint}
\title{Generic Function to Compute (Profile) Confidence Intervals}
\description{
  Compute (profile) confidence intervals for the scale, shape GPD
  parameters and also for GPD quantiles.
}
\usage{
confint(fitted, range, prob, prof = TRUE, var = "quant", conf = 0.95,
\dots)
}
\arguments{
  \item{fitted}{\code{R} object given by function \code{\link{fitgpd}}.}
  \item{range}{Vector of dimension two. It gives the lower and upper
    bound on which the profile likelihood is performed. Only required
    when "prof = TRUE".}
  \item{prob}{The probability of non exceedance.}
  \item{prof}{Logical. If \code{TRUE} (the default), profile confidence
    intervals are computed. Otherwise, it is Fisher ones.}
  \item{var}{Charater string specifies for which variable confidence
    intervals are computed. One of \code{"quant"}, \code{"scale"} or
    \code{"shape"}.}
  \item{conf}{Numeric. The confidence level.}
  \item{\dots}{Optional parameters. See details.}  
}
\value{
  Returns a vector of the lower and upper bound for the (profile) confidence
  interval.  Moreover, a graphic of the profile likelihood function is
  displayed when \code{prof = TRUE}.
}
\details{
  Additional options can be passed using "\dots" in the function
  call. Possibilites are related to the specific functions:
  \code{link{gpd.fiscale}}, \code{link{gpd.fishape}},
  \code{link{gpd.firl}}, \code{link{gpd.pfscale}},
  \code{link{gpd.pfshape}}, \code{link{gpd.pfrl}}.
}
\seealso{
  \code{link{gpd.fiscale}}, \code{link{gpd.fishape}},
  \code{link{gpd.firl}}, \code{link{gpd.pfscale}},
  \code{link{gpd.pfshape}} and \code{link{gpd.pfrl}}
}
\examples{
}
\author{Mathieu Ribatet}
\keyword{htest}