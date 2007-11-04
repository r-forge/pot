<?
$fichier = fopen("counts.dat","r+");
$visitea = fgets($fichier,255);
$visitea++;
fseek($fichier,0);
fputs($fichier,$visitea);
fclose($fichier);
?>
