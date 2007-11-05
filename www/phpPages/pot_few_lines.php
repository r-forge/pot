In this section, we explicit some of the most useful function of
the package. However, for a full description, users may want to
have a look to the package vignette and the html help of the
package.

<h4>GPD Computations:</h4>
<div class="Rcodes">
<span class="Rcomments"> 
  ##Simulate a sample from a GPD(0,1,0.2):<br/>
</span>
<a class="Routs">
  <code> x &lt- rgpd(100, 0, 1, 0.2) </code>
	      <span>
		[1] 0.123422302 0.297063966 ...
	      </span>
</a>
<br/>
<span class="Rcomments">
   ##Evaluate density at x=3 and probability of non-exceedance:<br/>
</span>
<a class="Routs">
  <code>dgpd(3, 0, 1, 0.2); pgpd(3, 0, 1, 0.2)</code>
  <span>
    [1] 0.05960464<br/> 
    [1] 0.9046326
  </span>
</a>
<br/>
<span class="Rcomments">
   ##Compute the quantile with non-exceedance probability 0.95:<br/> 
</span>
<a class="Routs">
  <code>qgpd(0.95, 0, 1, 0.2)</code>
  <span>
    [1] 4.102821
  </span>
</a>
<br/>
<span class="Rcomments">
   ##What about the bivariate case?  Just the same
</span>
<br/>
<a class="Routs">
  <code>y &lt- rbvgpd(100, model = "alog", alpha = 0.2,
	     asCoef1 = 0.8, asCoef2 = 0.2, mar1 = c(0, 1,
	     0.2), mar2 = c(10, 1, 0.5))</code>
	     <span>
	       <?php $tab = include "Routs/rbvgpd.out"; ?>
	     </span>
</a>
<br/>
<span class="Rcomments">
  ##Evaluate the probability to not exceed (5,14)
</span>
<br/> 
<a class="Routs">
  <code>pbvgpd(c(3,15), model = "alog", alpha = 0.2,
    asCoef1 = 0.8, asCoef2 = 0.2, mar1 = c(0, 1,
    0.2), mar2 = c(10, 1, 0.5))</code>
  <span>
    [1] 0.8450499
  </span>
</a>
</div>
<h4>GPD Fitting</h4>
<div class="Rcodes">
<span class="Rcomments">
   ##Maximum likelihood estimate (threshold = 0):<br/>
</span>
<a class="Routs">
  <code>mle &lt- fitgpd(x, 0)</code>
	       <span>
		 <?php $tab = include "Routs/mle.out"; ?>
	       </span>
</a>
<br/>
<span class="Rcomments">
   ##Probability Weighted Moments:<br/> 
</span>
<a class="Routs">
  <code>pwu &lt- fitgpd(x, 0, "pwmu")</code>
	       <span>
		 <?php $tab = include "Routs/pwu.out"; ?>
	       </span>
</a>
<br/>
<span class="Rcomments">
   ##Maximum Goodness-of-Fit estimators:<br/>
</span>
<a class="Routs">
  <code>adr &lt- fitgpd(x, 0, "mgf", stat = "ADR")</code>
	       <span>
		 <?php $tab = include "Routs/adr.out"; ?>
	       </span>
</a>  
<br/>
<span class="Rcomments">
   ##Specifying a known parameter:<br/>
</span>
<a class="Routs">
  <code>fitgpd(x, 0, "mple", shape = 0.2)</code>
  <span>
    <?php $tab = include "Routs/mple.out"; ?>
  </span>
</a>  
<br/>
<span class="Rcomments">
   ##Specifying starting values for numerical optimizations:<br/>
</span>
<a class="Routs">
  <code>fitgpd(x, 0, "mdpd", start = list(scale = 1, shape = 0.2))</code>
  <span>
    <?php $tab = include "Routs/mdpd.out"; ?>
  </span>
</a>
<br/>
<span class="Rcomments">
   ##Fit a bivariate GPD with a logistic dependence:<br/>
</span>
<a class="Routs">
  <code>log &lt- fitbvgpd(y, c(0,10), "log")</code>
	       <span>
		 <?php $tab = include "Routs/bvlog.out"; ?>
	       </span>
</a>
</div>  
<h4>Plots</h4>
<div class="Rcodes">
<span class="Rcomments">
   ##Generic function for the univariate and bivariate
  cases:<br/></span>
<a href="images/plotmle.png" class="Routs">
  <code class="Routs">plot(mle);</code>
  <span>
    <img src="images/plotmle.png"
	 alt="Generic univariate plot"
	 height="300"/>
  </span>
</a>
<a class="Routs" href="images/plotbvlog.png">
  <code class="Routs">plot(log)</code>
  <span>
    <img src="images/plotbvlog.png"
	 alt="Generic bivariate plot"
	 height="150"/>
  </span>
</a>
<br/>
<span class="Rcomments">
   ##Return level plots:<br/> </span>
<a class="Routs" href="images/retlevmle.png">
  <code class="Routs">retlev(mle, npy = 2);</code>
  <span>
    <img src="images/retlevmle.png" 
	 alt="Univariate return level plot"
	 height="300"/>
  </span>
</a>
<a class="Routs" href="images/retlevbvlog.png">
  <code class="Routs">retlev(log)</code>
  <span>
    <img src="images/retlevbvlog.png"
	 alt="Bivariate return level plot"
	 height="300"/>
  </span>
</a>
<br/>
<span class="Rcomments">
   ##Probability-Probability and Q-Q plots:<br/> 
</span>
<a class="Routs" href="images/ppqqmle.png">
  <code class="Routs">pp(mle); qq(mle)</code>
  <span>
    <img src="images/ppqqmle.png"
	 alt="PP and QQ-plots"
	 height="150"/>
  </span>
</a>
<br/>
<span class="Rcomments">
   ##Plot the density:<br/> 
</span>
<a class="Routs" href="images/densmle.png">
  <code class="Routs">dens(mle)</code>
  <span>
    <img src="images/densmle.png"
	 alt="Univariate denstiy plot"
	 height="300"/>
  </span>
</a>
<br/>
<span class="Rcomments">
   ##Plot the Pickands' dependence function:<br/> 
</span>
<a class="Routs" href="images/pickdep.png">
  <code class="Routs">pickdep(log)</code>
  <span>
    <img src="images/pickdep.png"
	 alt="Pickands' dependance function"
	 height="300"/>
  </span>
</a>
<br/>
<span class="Rcomments">
   ##Spectral density plot:<br/> 
</span>
<a class="Routs" href="images/specdens.png">
  <code class="Routs">specdens(log)</code>
  <span>
    <img src="images/specdens.png"
	 alt="Spectral density plot"
	 height="300"/>
  </span>
</a>
<br/>
<span class="Rcomments">
   ##Profile Likelihood (quantiles):<br/> 
</span>
<a class="Routs" href="images/proflik.png">
  <code class="Routs">confint(mle, prob = 0.95)</code>
  <span>
    <img src="images/proflik.png"
	 alt="Profile likelihood"
	 height="300"/>
  </span>
</a>
<br/>
<span class="Rcomments">
   ##Profile Likelihood (parameters):<br/> 
</span>
<a class="Routs" href="images/proflik2.png">
  <code class="Routs">confint(mle, "scale"); confint(mle, "shape")</code>
  <span>
    <img src="images/proflik2.png"
	 alt="Profile likelihood"
	 height="300"/>
  </span>
</a>
</div>
