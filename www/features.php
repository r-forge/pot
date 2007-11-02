The POT package can perform univariate and
bivariate extreme value analysis; first order Markov chains can
also be considered.  For instance, the
(univariate) <acronym title="Generalized Pareto Distribution">
  GPD </acronym> is currently fitted using <strong> 18 </strong>
estimators.  These estimators rely on three different techniques:
<ul>
  <li>Likelihood maximization:
    <acronym title="Maximum Likelihood Estimation"> MLE</acronym>,
    <acronym title="Likelihood Moment Estimation"> LME</acronym>,
    <acronym title="Maximum Penalized Likelihood Estimate"> MPLE</acronym>
  </li>
  <li>Moment Approaches:
    <acronym title="Method of Moment"> MOM</acronym>,
    <acronym title="Probability Weighted Moments"> PWM</acronym>,
    <acronym title="Method of Medians"> MED</acronym>
  </li>
  <li>Distance Minimization:
    <acronym title="Minimum Power Density Divergence">
      MDPD </acronym> and
    <acronym title="Maximum Goodness-of-Fit"> MGF </acronym> estimators.
  </li>
</ul>
<p>
  Contrary to the univariate case, there is no finite
  parametrisation to model bivariate exceedances over
  thresholds.  The POT packages allows 6 parametrisation for the
  bivariate GPD: the logistic, negative logistic and mixed
  models - with their respective asymmetric counterparts.
</p>
<p>
  Lastly, first order Markov chains can be fitted using the
  bivariate GPD for the joint distribution of two consecutive
  observations.
</p>
