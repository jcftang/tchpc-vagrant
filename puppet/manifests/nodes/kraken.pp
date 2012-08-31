# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# template for tchpc site, there are dependancy issues with proxies
#
node 'kraken.localhost' inherits default {
	# install needed packages
	if ! defined(Package['httpd']) { package { 'httpd': ensure => installed } }

	# turn on services
	service { "httpd":
		enable => true,
		ensure => "running",
		require => Package["httpd"],
	}

	# turn on avahi so we can do things like  "http://kraken.local" from the host machine
        include avahi

	# Install libyaml to silence the warning from ruby and psych
	if ! defined(Package['yum-conf-epel']) { package { 'yum-conf-epel': ensure => installed } }
	if ! defined(Package['libyaml-devel']) { package { 'libyaml-devel': ensure => installed,
                                                        require => Package['yum-conf-epel'] } }
	# install rvm and ruby but do not default to rvm's version of ruby as GEM_PATH gets clobbered and breaks puppet
	include rvm
	rvm::system_user { vagrant: ; }
	rvm_system_ruby {
		'ruby-1.9.3-p194':
		ensure => 'present',
		default_use => false,
		require => Package['libyaml-devel'],
	}

	rvm_gemset {
		"ruby-1.9.3-p194@vagrant":
		ensure => 'present',
		require => Rvm_system_ruby['ruby-1.9.3-p194'];
	}

	rvm_gem {
		'ruby-1.9.3-p194@vagrant/bundler':
		ensure => 'present',
		require => Rvm_gemset['ruby-1.9.3-p194@vagrant'];
	}

	rvm_gem {
		'ruby-1.9.3-p194/bundler':
		ensure => 'present',
		require => Rvm_system_ruby['ruby-1.9.3-p194'];

		'ruby-1.9.3-p194/cucumber':
		ensure => 'present',
		require => Rvm_system_ruby['ruby-1.9.3-p194'];

		'ruby-1.9.3-p194/rspec':
		ensure => 'present',
		require => Rvm_system_ruby['ruby-1.9.3-p194'];

		'ruby-1.9.3-p194/autotest':
		ensure => 'present',
		require => Rvm_system_ruby['ruby-1.9.3-p194'];

		'ruby-1.9.3-p194/puppet':
		ensure => 'present',
		require => Rvm_system_ruby['ruby-1.9.3-p194'];
	}

	# openjdk from repos
	class { "java":	}
	class { "tomcat": }
}
