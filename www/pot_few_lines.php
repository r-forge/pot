In this section, we explicit some of the most useful function of
the package. However, for a full description, users may want to
have a look to the package vignette and the html help of the
package.
<center>
  <table border="0" cellspacing="12" cellpadding="0">
    <tr> 
      <td> <strong>GPD Computations</strong> </td> 
      <td> <strong>GPD Fitting</strong> </td>
      <td> <strong>Plots</strong> </td>
    </tr>
    <tr>
      <td> <span class="Rcomments"> ##Simulate a 100-sample from a
	  GPD(0,1,0.2)</span><br/> <a href="#" class="Routs"> x
	  <- rgpd(100, 0, 1, 0.2) <span> [1] 0.123422302
	     0.297063966 ... </span> </a> <br/>
	     <span class="Rcomments">
	       ##Evaluate density at x=3 and probability of
	       non-exceedance
	     </span>
	     <br/> <a href="#"
		      class="Routs">
	       dgpd(3, 0, 1, 0.2); pgpd(3, 0, 1, 0.2)
	       <span>
		 [1] 0.05960464<br/> 
		 [1] 0.9046326
	       </span>
	     </a>
	     <br/>
	     
	     <span class="Rcomments">
	       ##Compute the quantile with non-exceedance
	       probability 0.95
	     </span>
	     <br/>
	     <a href="#" class="Routs">
	       qgpd(0.95, 0, 1, 0.2)
	       <span>
		 [1] 4.102821
	       </span>
	     </a>
	     <br/>
	     <span class="Rcomments">
	       ##What about the bivariate case? Just the same
	     </span>
	     <br/> <a href="#" class="Routs">
	       y <- rbvgpd(100, model = "alog", alpha = 0.2,
		    asCoef1 = 0.8,<br/> asCoef2 = 0.2, mar1 = c(0, 1,
		    0.2), mar2 = c(10, 1, 0.5))
		    <span>
		      <table>
			<tr>
			  <td> </td> <td> [,1] </td> <td> [,2]</td>
			</tr>
			<tr>
			  <td> [1,] </td> <td>
			    0.203216197 </td> <td> 10.62681 </td>
			</tr>
			<tr>
			  <td> [2,] </td> <td>
			    0.038458815 </td> <td> 11.47168 </td>
			</tr>
			<tr>
			  <td> [3,] </td> <td>
			    ... </td> <td> </td>
			</tr>
		      </table>
		    </span>
	     </a>
	     <br/>
	     <span class="Rcomments">
	       ##Evaluate the probability to not exceed (5,14)
	     </span>
	     <br/> 
	     <a href="#" class="Routs">
	       pbvgpd(c(3,15), model = "alog", alpha = 0.2,
	       asCoef1 = 0.8,<br/> asCoef2 = 0.2, mar1 = c(0, 1,
	       0.2), mar2 =	c(10, 1, 0.5))
	       <span>
		 [1] 0.8450499
	       </span>
	     </a>
	     <br/>
      </td>
      <td>
	<span class="Rcomments">
	  ##Maximum likelihood estimate (threshold = 0):
	</span>
	<br/> 
	<a href="#" class="Routs">
	  mle <- fitgpd(x, 0)
		 <span>
		   <?php $tab = include "Routs/mle.out"; ?>
		 </span>
	</a>
	<br/>
	<span class="Rcomments">
	  ##Probability Weighted Moments
	</span>
	<br/>
	<a href="#" class="Routs">
	  pwu <- fitgpd(x, 0, est = "pwmu")
		 <span>
		   <?php $tab = include "Routs/pwu.out"; ?>
		 </span>
	</a>
	<br/>
	<span class="Rcomments">
	  ##Maximum Goodness-of-Fit estimators:
	</span><br/>
	<a href="#" class="Routs">
	  adr <- fitgpd(x, 0, est = "mgf", stat = "ADR")
		 <span>
		   <?php $tab = include "Routs/adr.out"; ?>
		 </span>
	</a>  
	<br/>
	<span class="Rcomments">
	  ##Specifying a known parameter:
	</span><br/>
	<a href="#" class="Routs">
	  fitgpd(x, 0, est = "mple", shape = 0.2)
	  <span>
	    <?php $tab = include "Routs/mple.out"; ?>
	  </span>
	</a>  
	<br/>
	<span class="Rcomments">
	  ##Specifying starting values for numerical optimizations:
	</span><br/>
	<a href="#" class="Routs">
	  fitgpd(x, 0, "mdpd", start = list(scale = 1, shape = 0.2))
	  <span>
	    <?php $tab = include "Routs/mdpd.out"; ?>
	  </span>
	</a>
	<br/>
	<span class="Rcomments">
	  ##Fit a bivariate GPD with a logistic dependence:
	</span><br/>
	<a href="#" class="Routs">
	  log <- fitbvgpd(y, c(0,10), model = "log")
		 <span>
		   <?php $tab = include "Routs/bvlog.out"; ?>
		 </span>
	</a>  
	<br/>
      </td>
      <td> 
	<span class="Rcomments">
	  ##Generic function for the univariate and bivariate
	  cases</span>
	<br/>
	<a href="images/plotmle.png" class="Routs">
	  plot(mle);
	  <span>
	    <img src="images/plotmle.png"
		 title="Generic univariate plot"
		 height="300"/>
	  </span>
	</a>
	<a href="images/plotbvlog.png" class="Routs">
	  plot(log)
	  <span>
	    <img src="images/plotbvlog.png"
		 title="Generic bivariate plot"
		 height="150"/>
	  </span>
	</a>
	<br/>
	<span class="Rcomments">
	  ##Return level plots:</span><br/>
	<a href="images/retlevmle.png" class="Routs">
	  retlev(mle, npy = 2);
	  <span>
	    <img src="images/retlevmle.png" 
		 title="Univariate return level plot"
		 height="300"/>
	  </span>
	</a>
	<a href="images/retlevbvlog.png" class="Routs">
	  retlev(log)
	  <span>
	    <img src="images/retlevbvlog.png"
		 title="Bivariate return level plot"
		 height="300"/>
	  </span>
	</a>
	<br/>
	<span class="Rcomments">
	  ##Probability-Probability and Q-Q plots
	</span>
	<br/>
	<a href="images/ppqqmle.png" class="Routs">
	  pp(mle); qq(mle)
	  <span>
	    <img src="images/ppqqmle.png"
		 title="PP and QQ-plots"
		 height="150"/>
	  </span>
	</a>
	<br/>
	<span class="Rcomments">
	  ##Plot the density:
	</span><br/>
	<a href="images/densmle.png" class="Routs">
	  dens(mle)<br/>
	  <span>
	    <img src="images/densmle.png"
		 title="Univariate denstiy plot"
		 height="300"/>
	  </span>
	</a>
	<span class="Rcomments">
	  ##Plot the Pickands' dependence function:
	</span>
	<br/> 
	<a href="images/pickdep.png" class="Routs">
	  pickdep(log)
	  <span>
	    <img src="images/pickdep.png"
		 title="Pickands' dependance function"
		 height="300"/>
	  </span>
	</a>
	<br/>
	<span class="Rcomments">
	  ##Spectral density plot
	</span><br/>
	<a href="images/specdens.png" class="Routs">
	  specdens(log)
	  <span>
	    <img src="images/specdens.png"
		 title="Spectral density plot"
		 height="300"/>
	  </span>
	</a>
      </td>
    </tr>
  </table>
</center>
