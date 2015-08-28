<?php

/**
 * Need to include the following via ~/.drushrc.php. This walks up the tree
 * looking for alias files in a site-aliases directory.
 */
// $dir = getcwd();
// while ($dir != '/') {
//   if (in_array('site-aliases', scandir($dir))) {
//     $options['alias-path'][] = $dir . '/site-aliases';
//     break;
//   }
//   $dir = dirname($dir);
// }

// Generates an alias for the current project from HOSTNAME in the Vagrantfile.
$vagrant_directory = dirname(dirname(__FILE__));
$vagrantfile = $vagrant_directory . '/Vagrantfile';

if (!file_exists($vagrantfile)) {
  return;
}

$contents = file_get_contents($vagrantfile);
$matches = array();
preg_match('!HOSTNAME *= *"([^"]*)".*!', $contents, $matches);

$private_key = "~/.vagrant.d/insecure_private_key";
$providers = array('virtualbox', 'vmware_fusion', 'vmware_workstation');
foreach ($providers as $provider) {
  $unique_key = $vagrant_directory . "/.vagrant/machines/default/$provider/private_key";
  if (file_exists($unique_key)) {
    $private_key = $unique_key;
    break;
  }
}

if (isset($matches[1])) {
  $fqdn = $matches[1];
  $aliases[$fqdn] = array(
    'uri' => $fqdn,
    'remote-host' => $fqdn,
    'remote-user' => 'vagrant',
    'ssh-options' => "-i " . $private_key,
    'root' => '/var/www/docroot',
  );
}
