group { "puppet":
  ensure => "present",
  before => Exec["apt-get update"],
}

exec { "apt-get update":
    command => "/usr/bin/apt-get update",
}

package { ['php5-cli', 'php5-mysql', 'php5-mcrypt', 'php5', 'libapache2-mod-php5']:
  ensure => present,
  require => Package["apache2"],
}

## MySQL

class { 'mysql::server':
  config_hash => { 'root_password' => 'OpingOrnAnk3' },
  require => Exec["apt-get update"]
}


## Apache

package { 'apache2':
  ensure => latest,
  require => Exec["apt-get update"],
} 

service { 'apache2':
  ensure      => running,
  enable      => true,
  hasrestart  => true,
  hasstatus   => true,
  require     => Package['apache2'],
}

file { '/etc/apache2/sites-enabled/000-default':
  ensure  => absent,
  require => Package['apache2'],
  notify  => Service['apache2'],
}

file { 'vhosts':
  ensure  => present,
  path    => '/etc/apache2/sites-enabled/vhosts',
  source  => '/vagrant/vhosts',
  require => Package['apache2'],
  notify  => Service['apache2'],
}
  

## Laravel Specific

exec {'composer': 
  command  => "curl -sS https://getcomposer.org/installer | /usr/bin/php && /bin/mv composer.phar /usr/local/bin/composer",
  path     => ["/usr/bin", "/usr/local/bin", "/bin"],
  require  => Package["php5-cli"],
}
