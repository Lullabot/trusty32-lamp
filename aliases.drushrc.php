<?php

/**
 * Need to include the following via ~/.drushrc.php. This walks up the tree
 * looking for alias files.
 */
// $dir = getcwd();
// while (!in_array($dir, $options['alias-path'])) {
//   $options['alias-path'][] = $dir;
//   $dir = dirname($dir);
// }

// Generates an alias for the current project from HOSTNAME in the Vagrantfile.
$vagrant_directory = dirname(__FILE__);
$vagrantfile = $vagrant_directory . '/Vagrantfile';

if (!file_exists($vagrantfile)) {
  return;
}

$contents = file_get_contents($vagrantfile);
$matches = array();
preg_match('!HOSTNAME *= *"([^"]*)".*!', $contents, $matches);

if (isset($matches[1])) {
  $hostname = $matches[1];
  $fqdn = $hostname . '.local';
  $aliases[$fqdn] = array(
    'uri' => $fqdn,
    'remote-host' => $fqdn,
    'remote-user' => 'vagrant',
    'ssh-options' => '-i ~/.vagrant.d/insecure_private_key',
    'root' => '/var/www/docroot',
  );
}
