summary.pot <- function(object, ...)
{
  if (!inherits(object, "pot"))
    stop("Use only with 'pot' objects")
  str(object, ...)
}
  