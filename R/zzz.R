".First.lib" <-
function(lib, pkg)
{
  library.dynam("POTBeta", package = pkg, lib.loc = lib)
  return(invisible(0))
}

