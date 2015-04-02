class { 'apt':
  always_apt_update    => true,
  apt_update_frequency => 'always',
  fancy_progress       => true
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
package { 'php5-oauth':
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

# This package doesn't work with HGFS anymore. We purge it and install VMWare
# tools using the tar distribution.
package { 'open-vm-tools':
  ensure => 'purged',
}
