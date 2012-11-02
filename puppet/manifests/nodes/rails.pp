# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# template for tchpc site, there are dependancy issues with proxies
#
node 'rails.localhost' inherits default {

  ## could do with a custom my.cnf file
  class { "mysql":
    root_password => 'blahblah',
  }
  mysql::grant {'rails':
    mysql_db        => 'railsdb',
    mysql_user      => 'rails',
    mysql_password  =>  'blehbleh',
  }

  class { "apache": }
  #  apache::dotconf { "rails": source => 'puppet:///modules/apache/rails.conf' }
  apache::vhost { 'rails.localhost':
    port     => 80,
    priority => 10,
    docroot  => "/vagrant/rails",
    template => 'apache/virtualhost/vhost.conf.erb',
  }
  
  # # turn on avahi so we can do things like  "http://kraken.local" from the host machine
  include avahi

  # Install libyaml to silence the warning from ruby and psych
  if ! defined(Package['yum-conf-epel']) { package { 'yum-conf-epel': ensure => installed } }
  if ! defined(Package['libyaml-devel']) { package { 'libyaml-devel': ensure => installed,
    require => Package['yum-conf-epel'] } }

  include rvm
  rvm::system_user { vagrant: ; }
  rvm_system_ruby {
    'ruby-1.9.3-p286':
      ensure => 'present',
      default_use => false,
      require => Package['libyaml-devel'],
  }

  rvm_system_ruby {
    'ruby-1.9.2-p320':
      ensure => 'present',
      default_use => false,
      require => Package['libyaml-devel'],
  }

  rvm_gem {
    'ruby-1.9.3-p286/rails':
      ensure => 'latest',
      require => Rvm_system_ruby['ruby-1.9.3-p286'];
  }

  rvm_gem {
    'ruby-1.9.2-p320/rails':
      ensure => 'latest',
      require => Rvm_system_ruby['ruby-1.9.2-p320'];
  }

}
