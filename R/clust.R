clust <- function(data, u, tim.cond = 1, clust.max = FALSE,
                  plot = FALSE, only.excess = FALSE, ...){
  
  if ( !any(colnames(data) == "obs") )
    stop("``data'' should have a column named ``obs''...")

  if ( !any(colnames(data) == "time") )
    stop("``data'' should have a column named ``time''...")
  
  obs <- data[,"obs"]
  tim <- data[,"time"]

  if (all(obs <= u))
    stop("No data above the threshold !!!")
  
  idx.excess <- which(obs > u)
  n.excess <- length(idx.excess)
  
  diff.tim <- diff(tim[idx.excess])
  
  clust <- .C("clustts", as.integer(n.excess), as.double(idx.excess),
              as.double(diff.tim), as.double(tim.cond),
              clust = double(2*n.excess), PACKAGE = "POT")$clust
  
  clust <- clust[clust != 0]
  
  clust <- matrix(clust[!is.na(clust)], ncol = 2,
                  byrow = TRUE)
  colnames(clust) <- c("start","end")
  n.clust <- length(clust[,1])
  
  if (clust.max){
    idx <- NULL
    for (i in 1:n.clust){
      temp <- which.max(obs[clust[i,1]:clust[i,2]]) - 1
      idx <- c(idx, clust[i,1] + temp)
    }
    
    events <- rbind(time = tim[idx], obs = obs[idx])
    colnames(events) <- 1:n.clust
  }

  else{
    events <- list()
    for (i in 1:n.clust)
      events <- c(events, list(rbind(time = tim[clust[i,1]:clust[i,2]],
                                     obs = obs[clust[i,1]:clust[i,2]])))

    names(events) <- paste("cluster", 1:n.clust)
  }

  exi <- n.clust / n.excess
  attributes(events)$exi <- exi

  if (plot) {
    plot(tim, obs, type = "n", ...)

    rect(tim[clust[,"start"]], rep(min(obs), n.clust), tim[clust[,"end"]],
         rep(max(obs), n.clust), col = "lightgrey")

    if (only.excess){
      tim <- tim[idx.excess]
      obs <- obs[idx.excess]
    }
    
    points(tim, obs)
  }
  
  return(events)
}
