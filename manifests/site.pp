class { 'apt':
  always_apt_update    => true,
  apt_update_frequency => 'always',
  fancy_progress       => false
}

apt::ppa {
  'ppa:ondrej/php':
}

class { 'composer':
  command_name => 'composer',
  target_dir   => '/usr/local/bin'
}

exec { "apt-get dist-upgrade":
  require => Class['apt'],
  command => "/usr/bin/apt-get -y --auto-remove dist-upgrade",
  logoutput => 'true',
  timeout => 0,
}

exec { "clean apt-cache":
  command => "/bin/rm -rf /var/cache/apt/archives",
  require => Exec["apt-get dist-upgrade"],
}

# We change vagrant's group to www-data to prevent permissions conflicts with
# drush and apache processes.
user { 'vagrant':
  gid => 'www-data',
  groups => ['vagrant', 'adm'],
  shell  => "/bin/zsh",
  require => Package['zsh'],
}

file { 'php-debug':
  path => '/usr/local/bin/php-debug',
  ensure => 'link',
  target => '/vagrant/php-debug',
}

file { 'xhgui config':
  path => '/opt/xhgui/config/config.php',
  ensure => 'link',
  target => '/etc/php5/xhgui/config.php',
}

file { 'xhgui htaccess':
  path => '/opt/xhgui/webroot/.htaccess',
  ensure => 'link',
  target => '/etc/php5/xhgui/htaccess',
}

file { 'lmm':
  path => '/usr/local/sbin/lmm',
  ensure => 'link',
  target => '/opt/lmm/lmm',
}

vcsrepo { '/opt/drush':
  ensure => 'present',
  provider => git,
  source => 'https://github.com/drush-ops/drush.git',
  revision => '8.1.2',
}

exec { "composer drush":
  command => "/usr/local/bin/composer install --working-dir=/opt/drush",
  environment => ["HOME=/home/vagrant"],
}

# Remove drush8
file { '/opt/drush8':
  ensure => 'absent',
  force => true,
}

file { 'drush8':
  path => '/usr/local/bin/drush8',
  ensure => 'absent',
}

# ensure => 'latest' is currently broken, so we use explicit revisions.
# https://tickets.puppetlabs.com/browse/MODULES-1800
vcsrepo { '/opt/lmm':
  ensure => 'present',
  provider => git,
  source => 'https://github.com/Lullabot/lmm.git',
  revision => '2d2b9ff8a01a4de98f0578ebe776d447b0244eaf',
}

vcsrepo { '/opt/mysql-parallel':
  ensure => 'present',
  provider => git,
  source => 'https://github.com/deviantintegral/mysql-parallel.git',
  revision => 'ab233aa28f747c2cc64035ecea39bfc7082f5b75',
}

vcsrepo { '/opt/xhgui':
  ensure => 'present',
  provider => git,
  source => 'https://github.com/perftools/xhgui.git',
}

vcsrepo { '/home/vagrant/.oh-my-zsh':
  ensure => 'present',
  provider => git,
  source => 'https://github.com/robbyrussell/oh-my-zsh.git',
  revision => 'master',
  owner => 'vagrant',
}

file { 'zshrc':
  path => '/home/vagrant/.zshrc',
  ensure => 'present',
  source => '/home/vagrant/.oh-my-zsh/templates/zshrc.zsh-template',
  owner => 'vagrant',
  require => Vcsrepo["/home/vagrant/.oh-my-zsh"],
}

package { 'apache2':
  ensure => 'latest',
}
package { 'avahi-daemon':
  ensure => 'latest',
}
package { 'bash-completion':
  ensure => 'latest',
}
package { 'build-essential':
  ensure => 'latest',
}
package { 'byobu':
  ensure => 'latest',
}
package { 'curl':
  ensure => 'latest',
}
package { 'diffutils':
  ensure => 'latest',
}
package { 'dkms':
  ensure => 'latest',
}
package { 'etckeeper':
  ensure => 'latest',
}
package { 'git':
  ensure => 'latest',
}
package { 'htop':
  ensure => 'latest',
}
package { 'lbzip2':
  ensure => 'latest',
}
package { 'lvm2':
  ensure => 'latest',
}
package { 'mariadb-client-5.5':
  ensure => 'latest',
}
package { 'mariadb-client-core-5.5':
  ensure => 'latest',
}
package { 'mariadb-common':
  ensure => 'latest',
}
package { 'mariadb-server':
  ensure => 'latest',
}
package { 'mariadb-server-5.5':
  ensure => 'latest',
}
package { 'mariadb-server-core-5.5':
  ensure => 'latest',
}
package { 'memcached':
  ensure => 'latest',
}
package { 'mongodb-clients':
  ensure => 'latest',
}
package { 'mongodb-server':
  ensure => 'latest',
}
package { 'parallel':
  ensure => 'latest',
}
package { 'php-pear':
  ensure => 'latest',
}
package { 'php5':
  ensure => 'latest',
}
package { 'php5-apcu':
  ensure => 'latest',
}
package { 'php5-cli':
  ensure => 'latest',
}
package { 'php5-common':
  ensure => 'latest',
}
package { 'php5-curl':
  ensure => 'latest',
}
package { 'php5-gd':
  ensure => 'latest',
}
package { 'php5-imagick':
  ensure => 'latest',
}
package { 'php5-json':
  ensure => 'latest',
}
package { 'php5-mcrypt':
  ensure => 'latest',
}
package { 'php5-memcache':
  ensure => 'latest',
}
package { 'php5-memcached':
  ensure => 'latest',
}
package { 'php5-mongo':
  ensure => 'latest',
}
package { 'php5-mysql':
  ensure => 'latest',
}
package { 'php-oauth':
  ensure => 'latest',
}
package { 'php5-readline':
  ensure => 'latest',
}
package { 'php5-redis':
  ensure => 'latest',
}
package { 'php5-sqlite':
  ensure => 'latest',
}
package { 'php5-xdebug':
  ensure => 'latest',
}
package { 'php5-xhprof':
  ensure => 'latest',
}
package { 'php5-xmlrpc':
  ensure => 'latest',
}
package { 'pigz':
  ensure => 'latest',
}
package { 'puppet':
  ensure => 'latest',
}
package { 'puppet-common':
  ensure => 'latest',
}
package { 'redis-server':
  ensure => 'latest',
}
package { 'redis-tools':
  ensure => 'latest',
}
package { 'rsync':
  ensure => 'latest',
}
package { 'ruby':
  ensure => 'latest',
}
package { 'screen':
  ensure => 'latest',
}
package { 'strace':
  ensure => 'latest',
}
package { 'tcpdump':
  ensure => 'latest',
}
package { 'tmux':
  ensure => 'latest',
}
package { 'unison':
  ensure => 'latest',
}
package { 'vim':
  ensure => 'latest',
}
package { 'vim-common':
  ensure => 'latest',
}
package { 'vim-runtime':
  ensure => 'latest',
}
package { 'vim-tiny':
  ensure => 'latest',
}
package { 'w3m':
  ensure => 'latest',
}
package { 'wget':
  ensure => 'latest',
}
package { 'zerofree':
  ensure => 'latest',
}
package { 'zsh':
  ensure => 'latest',
}

# This package doesn't work with HGFS anymore. We purge it and install VMWare
# tools using the tar distribution.
package { 'open-vm-tools':
  ensure => 'purged',
}

# We don't need juju for vagrant boxes
package { 'juju-core':
  ensure => 'purged',
}

package {'libicu52':
  ensure => 'purged',
}
