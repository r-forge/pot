<!-- This is the project specific website template -->
<!-- It can be changed as liked or replaced by other content -->

<?php
   
   $domain=ereg_replace('[^\.]*\.(.*)$','\1',$_SERVER['HTTP_HOST']);
   $group_name=ereg_replace('([^\.]*)\..*$','\1',$_SERVER['HTTP_HOST']); 
   $themeroot='http://r-forge.r-project.org/themes/rforge/';
   
   echo '<?xml version="1.0" encoding="UTF-8"?>';
   ?>
<!DOCTYPE html
	  PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en   "> 
  
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"
	  /> 
    <title><?php echo $group_name; ?></title>
    <link href="<?php echo $themeroot; ?>styles/estilo1.css"
	  rel="stylesheet" type="text/css" /> 
  </head>
  
  <body>
    
    <! --- R-Forge Logo --- >
    <table border="0" width="100%" cellspacing="0" cellpadding="0">
      <tr><td>
	  <a href="/"><img src="<?php echo $themeroot;
				?>/images/logo.png" border="0"
			   alt="R-Forge Logo" /> </a> </td> </tr> 
    </table>
    <h1>Welcome to the POT package homepage!</h1>
    <p>
      The POT package aims to provide operational tools to
      analyze <acronym title="Peaks Over Threshold">
	POT </acronym>. This package relies on
      the <acronym title="Extreme Value Theory"> EVT </acronym> to
      model the tail of any continuous distribution. Tail modeling, in
      particular POT modeling, is of great importance for many
      financial and environmental applications.
    </p>
    <p>
      The POT package was first commited
      to the <a href="http://www.r-project.org/">
	<acronyme title="Comprehensive R Archive Network">
	  CRAN </acronym> </a> in April 2005 and is still in active
      development.The main motivation was to provide practical tools
      to model high flood flows. However, the strength of the EVT is
      that results do not depend on the process to be modeled. Thus,
      one can use the POT package to analyze precipitations, floods,
      financial times series, earthquake and so on...
    </p>
    <h2>Features</h2> The POT package can perform univariate and
    bivariate extreme value analysis; first order Markov chains can
    also be considered. For instance, the
    (univariate) <acronym title="Generalized Pareto Distribution">
      GPD </acronym> is currently fitted using <strong> 18 </strong>
    estimators. These estimators rely on three different techniques:
    <ul>
      <li>Likelihood maximization:
	<acronym title="Maximum Likelihood Estimation"> MLE</acronym>,
	<acronym title="Likelihood Moment Estimation"> LME</acronym>,
	<acronym title="Maximum Penalized Likelihood Estimate"> MPLE</acronym>
      </li>
      <li>Moment Approaches:
	<acronym title="Method of Moment"> MOM </acronym>,
	<acronym title="Probability Weighted Moments"> PWM </acronym>,
	<acronym title="Method of Medians"> MED
	</li>
      <li>Distance Minimization:
	<acronym title="Minimum Power Density Divergence">
	  MDPD </acronym> and
	<acronym title="Maximum Goodness-of-Fit"> MGF </acronym> estimators.
      </li>
      </ul>
      <p>
	Contrary to the univariate case, there is no finite
	parametrization to model bivariate exceedances over
	thresholds. The POT packages allows 6 parametrisation for the
	bivariate GPD: the logistic, negative logistic and mixed
	models - with their respective asymmetric counterparts.
      </p>
      <p>
	Lastly, first order Markov chains can be fitted using the
	bivariate GPD for the joint distribution of two consecutive
	observations.
      </p>
      <h2>Screenshots</h2>
      <p align="center"> <img src="images/screenshot.png"/> </p>
      <h2>Manuals</h2> We have written
      a <a href="../pkg/inst/doc/guide.pdf"> package vignette </a> to
      help new users. This user's guide is a part of the package -
      just run <strong> vignette(POT) </strong> once the package is loaded.
      <p>
	For a quick overview, one can have a look at
	the <a href="docs/RNews_2007-1.pdf"> R News (7):1</a> article
	or by running the univariate and bivariate demos -
	i.e. <strong> demo(POT)</strong> and <strong>
	demo(bvPOT)</strong>.
      </p>
      <h3>Contact</h3>
      Any suggestions, features request,
      bugs: <a href="http://r-forge.r-project.org/tracker/?group_id=76">
      appropriate tracker</a>
    </body>
  </html>
