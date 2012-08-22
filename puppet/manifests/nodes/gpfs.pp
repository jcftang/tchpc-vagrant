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
	if ! defined(Package['yum-conf-epel']) { package { 'yum-conf-epel': ensure => installed } }
	if ! defined(Package['nss-mdns']) { package { 'nss-mdns': ensure => installed,
							require => Package['yum-conf-epel'] } }
	if ! defined(Package['avahi-tools']) { package { 'avahi-tools': ensure => installed } }
	if ! defined(Package['avahi-dnsconfd']) { package { 'avahi-dnsconfd': ensure => installed } }
	if ! defined(Package['avahi']) { package { 'avahi': ensure => installed } }

	# turn on services
	service { "avahi-daemon":
		enable => true,
		ensure => "running",
		require => Package["avahi"],
	}
	service { "avahi-dnsconfd":
		enable => true,
		ensure => "running",
		require => Package["avahi-dnsconfd"],
	}

#	service { "httpd":
#		enable => true,
#		ensure => "running",
#		require => Package["httpd"],
#	}
}
