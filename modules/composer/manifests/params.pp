# = Class: composer::params
#
# This class defines default parameters used by the main module class composer.
# Operating Systems differences in names and paths are addressed here.
#
# == Variables:
#
# Refer to composer class for the variables defined here.
#
# == Usage:
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes.
#
class composer::params {
  $phar_location = 'https://getcomposer.org/composer.phar'
  $target_dir    = '/usr/local/bin'
  $command_name  = 'composer'
  $user          = 'root'
}
