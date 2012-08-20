# -*- mode: ruby -*-
# vi: set ft=ruby :

node 'web.localhost' inherits default {

	## install and startup apache
	if ! defined(Package['httpd']) { package { 'httpd': ensure => installed } }

	# turn on services
	service { "httpd":
		enable => true,
		ensure => "running",
		require => Package["httpd"],
	}

	## install and startup postgresql using the puppet module https://github.com/inkling/puppet-postgresql
	include postgresql
	include postgresql::server
	postgresql::db{ 'vagrant':
	  user          => 'vagrant',
	  password      => 'vagrant',
	  grant         => 'all',
	}

#	include rvm
#	rvm::system_user { vagrant: ; }
#	rvm_system_ruby {
#		'ruby-1.9.3-p194':
#		ensure => 'present',
#		default_use => false;
#	}
#
#	rvm_gemset {
#		"ruby-1.9.3-p194@vagrant":
#		ensure => 'present',
#		require => Rvm_system_ruby['ruby-1.9.3-p194'];
#	}
#
#	rvm_gem {
#		'ruby-1.9.3-p194@vagrant/bundler':
#		ensure => 'present',
#		require => Rvm_gemset['ruby-1.9.3-p194@vagrant'];
#	}
}
