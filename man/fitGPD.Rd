\name{Fit the GP Distribution}
\alias{fitgpd}
\alias{printpot}
\alias{gpdmoments}
\alias{gpdpwmu}
\alias{gpdpwmb}
\alias{gpdmle}
\alias{gpdpickands}
\alias{gpdmdpd}

\title{Fitting a POT model through a GP distribution}
\description{Maximum Likelihood, Unbiased Probability Weigthed Moments,
  Biased Probability Weighted Moments and Moments Estimator to fit Peaks
  Over a Threshold to a GP distribution.}

\usage{fitgpd(data, threshold, method, \dots)}
\arguments{
  \item{data}{A numeric vector.}
  \item{threshold}{A numeric value giving the threshold for the
    GPD. \code{'mle'} method allows varying threshold; so that threshold
  could be for this case a numeric vector. Be careful, varying
  thresholds are used cyclically if length doesn't match with
  \code{data}.}
  \item{method}{A string giving the names of the estimator. It can be
    \code{'mle'}, \code{'moments'}, \code{'pwmu'}, \code{'pwmb'},
    \code{'mdpd'} and \code{'pickands'} for the maximum likelihood,
    moments, unbiased probability weighted moments, biased probability
    weigthed moments,  minimum density power divergence and pickands'
    estimators respectively.}
  \item{\dots}{Other optional arguments to be passed to
    \code{\link{gpdmoments}}, \code{\link{gpdpwmu}},
    \code{\link{gpdpwmb}} and \code{\link{gpdmle}} functions.}
}
\value{
  This function returns a list with  composants:
  \item{estimate}{A vector containing the maximum likelihood estimates.}
  \item{std.err}{A vector containing the standard errors.}
  \item{fixed}{A vector containing the parameters of the model that
    have been held fixed.}
  \item{param}{A vector containing all parameters (optimized and fixed).}
  \item{deviance}{The deviance at the maximum likelihood estimates.}
  \item{corr}{The correlation matrix - for the \code{mle} method.}
  \item{convergence, counts, message}{Components taken from the
    list returned by \code{\link{optim}} - for the \code{mle} method.}
  \item{threshold}{The threshold passed to argument \code{threshold}.}
  \item{nhigh}{The number of exceedences.}
  \item{nat, pat}{The number and proportion of exceedences.}
  \item{data}{The data passed to the argument \code{data}.}
  \item{exceedances}{The exceedences, or the maxima of the clusters
    of exceedences.}
  \item{scale}{The scale parameter for the fitted generalized Pareto
    distribution.}
  \item{std.err.type}{The standard error type - for \code{'mle'}
    only. That is \code{Observed} or \code{Expected} Information matrix
    of Fisher.}
  \item{var.thresh}{Logical. Specify if the threshold is a varying one -
    \code{'mle'} only. For \code{'moments'}, \code{'pwmu'} and
    \code{'pwmb'} estimates, threshold is always constant
    i.e. \code{var.thresh = FALSE}.}
}
\note{The Maximum Likelihood estimator is obtained through a sligthly
  modified version of Alec Stephenson's \code{fpot.norm} function in the
  \code{evd} package.
}
\references{
  Coles, S. (2001) \emph{An Introduction to Statistical
    Modelling of Extreme Values}. Springer Series in Statistics. London.

  Hosking, J. and Wallis, J. (1987) Parameters and Quantile Estimation
  for the Generalized Pareto Distribution. Technometrics
  \bold{29}:339--349.

  Juarez, S. and Schucany, W. (2004) Robust and Efficient Estimation for
  the Generalized Pareto Distribution. Extremes \bold{7}:237--251.
  
}
\examples{
data(ardieres)
plot(ardieres)
flows <- ardieres[, "flows"]
mle <- fitgpd(flows, 7, 'mle')
}
\author{Mathieu Ribatet}
\keyword{htest}
