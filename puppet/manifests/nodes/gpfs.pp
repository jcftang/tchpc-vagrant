# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# template for tchpc site, there are dependancy issues with proxies
#
node /gpfs.*\.localhost/ inherits default {
	# install needed packages
	# generic devel tools and libraries
	if ! defined(Package['rpm-build']) { package { 'rpm-build': ensure => installed } }
	if ! defined(Package['kernel-devel']) { package { 'kernel-devel': ensure => installed } }
	if ! defined(Package['gcc']) { package { 'gcc': ensure => installed } }
	if ! defined(Package['gcc-c++']) { package { 'gcc-c++': ensure => installed } }
	if ! defined(Package['nfs-utils']) { package { 'nfs-utils': ensure => installed } }

	# bonjour/zeroconf/avahi adhoc dns entries
	include avahi

#	service { "httpd":
#		enable => true,
#		ensure => "running",
#		require => Package["httpd"],
#	}
}
