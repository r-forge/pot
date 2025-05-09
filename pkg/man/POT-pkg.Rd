\name{POT-package}
\alias{POT}
\alias{POT-package}
\title{Overview of the \pkg{POT} package}

\description{

The \pkg{POT} package aims to provide operational tools to analyze peak over threshold. 
This package relies on the extreme value theory (EVT) to model the tail of any continuous distribution.
Tail modelling, in particular POT modelling, is of great importance for many financial 
and environmental applications.

The \pkg{POT} package was first committed to the CRAN in April 2005 and is 
still in development. 
The package is hosted in \href{https://pot.r-forge.r-project.org/}{R-forge}.
Since November 2016, the package has a new maintainer.

The main motivation was to provide practical tools for 
probabilistic modelling of high flood flows. However, the strength of the EVT is 
that results do not depend on the process to be modelled. 
Thus, one can use the \pkg{POT} package to analyze precipitations, 
floods, financial times series, earthquakes and so on... 


The \pkg{POT} package can perform univariate and bivariate extreme value analysis; 
first order Markov chains can also be considered. 
For instance, the (univariate) GPD is currently fitted using 18 estimators. 
These estimators rely on three different techniques:
\itemize{
\item Likelihood maximization: MLE, LME, MPLE
\item Moment Approaches: MOM, PWM, MED
\item Distance Minimization: MDPD and MGF estimators.
}

Contrary to the univariate case, there is no finite parametrisation to model bivariate 
exceedances over thresholds. The POT packages allows 6 parametrisation for the 
bivariate GPD: the logistic, negative logistic and mixed models - 
with their respective asymmetric counterparts.

Lastly, first order Markov chains can be fitted using the bivariate GPD for the joint 
distribution of two consecutive observations. 

The \pkg{POT} package proposes several S3 classes to handle fits. 
The overal class is \code{"pot"} which provides usual generic functions 
\code{\link{coef.pot}}, \code{\link{logLik.pot}}, \code{\link{summary.pot}}.
\itemize{
\item 
  Inheriting from \code{"pot"} class, the class \code{"uvpot"} provides univariate POT
  objects (see \code{\link{fitgpd}} and \code{\link{fitpp}}) with the usual generic functions 
  \itemize{
  \item \code{\link{anova.uvpot}} for analysis of deviance,
  \item \code{\link{confint.uvpot}} for confidence interval, 
  \item \code{\link{plot.uvpot}} for plots,
  \item \code{\link{print.uvpot}} for print, 
  }
  as well as new generic functions 
  \itemize{
  \item \code{\link{convassess.uvpot}} for convergence assessment,
  \item \code{\link{dens.uvpot}} for density plot,
  \item \code{\link{pp.uvpot}} for probability plot, 
  \item \code{\link{qq.uvpot}} for quantile plot,
  \item \code{\link{retlev.uvpot}} for return level plot.  
  }
\item 
  Inheriting from \code{"pot"} class, the class \code{"bvpot"} provides bivariate POT
  objects (see \code{\link{fitbvgpd}}) with the usual generic functions 
  \itemize{
  \item \code{\link{anova.bvpot}} for analysis of deviance,
  \item \code{\link{plot.bvpot}} for plots,
  \item \code{\link{print.bvpot}} for print, 
  }
  as well as new generic functions 
  \itemize{
  \item \code{\link{convassess.bvpot}} for convergence assessment,
  \item \code{\link{retlev.bvpot}} for return level plot.  
  }
\item 
  Inheriting from \code{"uvpot"} class, the class \code{"mcpot"} provides Markov Chain POT
  objects (see \code{\link{fitmcgpd}}) with the usual generic functions   
  \itemize{
  \item \code{\link{plot.mcpot}} for plots,
  \item \code{\link{print.mcpot}} for print, 
  }
  as well as new generic functions 
  \itemize{
  \item \code{\link{convassess.mcpot}} for convergence assessment,
  \item \code{\link{retlev.mcpot}} for return level plot.  
  }
}



We have written a package \href{../doc/POT.pdf}{vignette} to help new users. 
This users guide is a part of the package - just run \code{vignette("POT")} 
once the package is loaded.


}

\author{ 
Mathieu Ribatet and Christophe Dutang.
}

