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
    <link rel="stylesheet" media="screen" type="text/css"
	  title="Design" href="style.css" />
  </head>
  
  <body>
    
    <! --- R-Forge Logo --- >
    <table border="0" width="100%" cellspacing="0" cellpadding="0">
      <tr><td>
	  <a href="/"><img src="<?php echo $themeroot;
				?>/images/logo.png" border="0"
			   alt="R-Forge Logo" /> </a> </td> 
      <td>
	<h1>Welcome to the POT package homepage!</h1><br/>
      </td>
      </tr> 
    </table>
    <center>
      <h2> A R Package to Model Peaks Over a Threshold</h2> 
    </center>
    
    <?php include "welcome.php"; ?>

    <h2>Features</h2>
    <?php include "features.php"; ?>

    <h2>Screen Shots</h2>
    <?php include "screen_shots.php"; ?>

    <h2>The POT Package in a Few Lines</h2>
    <?php include "pot_few_lines.php"; ?>

    <h2>Manuals</h2> 
    <?php include "manuals.php"; ?>

    <h2>Contact</h2> Any suggestions, feature requests,
    bugs: <a href="http://r-forge.r-project.org/tracker/?group_id=76">
      select the appropriate tracker</a><br/> Author: Mathieu
    Ribatet <a href="http://www.lyon.cemagref.fr/hh/hydrologie/scientifiques/ribatet/hydrology-english.shtml">
      (homepage)</a><br/> $LastChangedDate$
  </body>
</html>

