\name{Clusters}
\alias{clust}
\title{Clustering Techniques}
\description{
  A function to identify clusters of exceedences of a time series.
}
\usage{
clust(data, u, tim.cond = 1, clust.max = FALSE, plot = FALSE,
only.excess = TRUE, \dots)
}
\arguments{
  \item{data}{A matrix/data.frame with two columns. Columns names \bold{must
      be} ``obs'' for observations and ``time'' for the associated date of
    each observation.}
  \item{u}{Numeric. A value giving the threshold.}
  \item{tim.cond}{A time condition to ensure independence between
    events. Should be in the same unit that \code{data[,"time"]}.}
  \item{clust.max}{Logical. If \code{FALSE} (the default), a list
    containing the clusters of exceedences is returned. Else, a matrix
    containing the cluster maxima and related dates is returned.}
  \item{plot}{Logical. If \code{TRUE}, identified
    clusters are displayed. Else (the default), no plot is produced.}
  \item{only.excess}{Logical. If \code{TRUE} (the default), only
    exceedences are plotted. Else, all observations are displayed.}
  \item{\dots}{Optional parameters to be passed in \code{\link{plot}}
    function.}
}
\value{
  If \code{clust.max} is \code{FALSE}, a list containing the clusters of
  exceedences is returned. Else, a matrix containing the cluster maxima
  and related dates is returned.

  In any case, thre returned object has an attribute \code{exi} giving
  an estimation of the Extremal Index, that is the inverse of the
  average cluster size.
}
\details{
  The clusters of exceedences are defined as follows:
  \begin{enumerate}
  \item The first exceedence initiates the first cluster;
  \item The current cluster is still ``active'' while two consecutive
  exceedences do not verify the \code{tim.cond} condition;
  \item When \code{tim.cond} holds, a new cluster is initiated.
  \item The process is iterated as needed.
  \end{enumerate}

  
  This function differs from the function \code{\link{clusters}} of
  \code{evd} Package as independence condition i.e. \code{tim.cond}
  could be a ``temporal'' condition. That is, two events are considered
  independent if the inter-arrival time is greater than a fixed
  duration.

  However, it is also possible to used the ``index'' independence as in
  \code{\link{clust}} by setting \code{data[,"time"] =
  1:length(data[,"obs"])}.
}
\seealso{
  \code{\link{clusters}} of package \code{evd}.
}
\examples{
data(ardieres)
clust(ardieres, 4, 10 / 365)
clust(ardieres, 4, 10 / 365, clust.max = TRUE)
clust(ardieres, 4, 10 / 365, clust.max = TRUE, plot = TRUE)
##The same but with optional arguments passed to function ``plot''
clust(ardieres, 4, 10 / 365, clust.max = TRUE, plot = TRUE,
xlab = "Time (Years)", ylab = "Flood discharges")
}
\author{Mathieu Ribatet}
\keyword{manip}
