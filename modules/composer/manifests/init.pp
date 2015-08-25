# = Class: composer
#
# == Parameters:
#
# [*target_dir*]
#   Where to install the composer executable.
#
# [*command_name*]
#   The name of the composer executable.
#
# [*user*]
#   The owner of the composer executable.
#
# [*auto_update*]
#   Whether to run `composer self-update`.
#
# == Example:
#
#   include composer
#
#   class { 'composer':
#     'target_dir'   => '/usr/local/bin',
#     'user'         => 'root',
#     'command_name' => 'composer',
#     'auto_update'  => true
#   }
#
class composer (
  $target_dir   = 'UNDEF',
  $command_name = 'UNDEF',
  $user         = 'UNDEF',
  $auto_update  = false
) {

  include composer::params

  $composer_target_dir = $target_dir ? {
    'UNDEF' => $::composer::params::target_dir,
    default => $target_dir
  }

  $composer_command_name = $command_name ? {
    'UNDEF' => $::composer::params::command_name,
    default => $command_name
  }

  $composer_user = $user ? {
    'UNDEF' => $::composer::params::user,
    default => $user
  }

  wget::fetch { 'composer-install':
    source      => $::composer::params::phar_location,
    destination => "${composer_target_dir}/${composer_command_name}",
    execuser    => $composer_user,
  }

  exec { 'composer-fix-permissions':
    command => "chmod a+x ${composer_command_name}",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => $composer_target_dir,
    user    => $composer_user,
    unless  => "test -x ${composer_target_dir}/${composer_command_name}",
    require => Wget::Fetch['composer-install'],
  }

  if $auto_update {
    exec { 'composer-update':
      command     => "${composer_command_name} self-update",
      environment => [ "COMPOSER_HOME=${composer_target_dir}" ],
      path        => "/usr/bin:/bin:/usr/sbin:/sbin:${composer_target_dir}",
      user        => $composer_user,
      require     => Exec['composer-fix-permissions'],
    }
  }
}
