

print.bvpot <- function (x, digits = max(3, getOption("digits") -
                              3), ...) {
  if (!inherits(x, "bvpot"))
    stop("Use only with 'bvpot' objects")
  cat("\nCall:", deparse(x$call), "\n")
  cat("Estimator:", x$est, "\n")

  if (x$model == "log")
    model <- "Logistic"
  if (x$model == "alog")
    model <- "Asymetric Logistic"
  if (x$model == "nlog")
    model <- "Negative Logistic"
  if (x$model == "anlog")
    model <- "Asymetric Negative Logistic"
  if (x$model == "mix")
    model <- "Mixed"
  if (x$model == "amix")
    model <- "Asymetric Mixed"
  
  cat("Dependence Model and Strength:\n")
  cat("\tModel :", model, "\n")
  cat("\tlim_u Pr[ X_1 > u | X_2 > u] =", round(x$chi, 3),
      "\n")

  if (x$est == "MLE"){
    cat("Deviance:", x$deviance, "\n")
    cat("     AIC:", AIC(x), "\n")
  }
  cat("\nMarginal Threshold:", round(x$threshold, digits), "\n")
  cat("Marginal Number Above:", x$nat[1:2], "\n")
  cat("Marginal Proportion Above:", round(x$pat[1:2], digits), "\n")
  cat("Joint Number Above:", x$nat[3], "\n")
  cat("Joint Proportion Above:", round(x$pat[3], digits),"\n")
  cat("Number of events such as {Y1 > u1} U {Y2 > u2}:",
      x$nat[4], "\n")
  cat("\nEstimates\n")
  print.default(format(fitted(x), digits = digits), print.gap = 2, 
                quote = FALSE)
  if (!is.null(x$std.err)) {
    cat("\nStandard Errors\n")
    print.default(format(x$std.err, digits = digits), print.gap = 2, 
                  quote = FALSE)
  }
  if (!is.null(x$var.cov)) {
    cat("\nAsymptotic Variance Covariance\n")
    print.default(format(x$var.cov, digits = digits), print.gap = 2, 
                  quote = FALSE)
  }
  if (!is.null(x$corr)) {
    cat("\nCorrelation\n")
    print.default(format(x$corr, digits = digits), print.gap = 2, 
                  quote = FALSE)
  }
  cat("\nOptimization Information\n")
  cat("\tConvergence:", x$convergence, "\n")
  cat("\tFunction Evaluations:", x$counts["function"], "\n")
  if (!is.na(x$counts["gradient"])) 
    cat("\tGradient Evaluations:", x$counts["gradient"], 
        "\n")
  if (!is.null(x$message)) 
    cat("\nMessage:", x$message, "\n")
  cat("\n")
}

