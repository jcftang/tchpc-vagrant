# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# template for tchpc site, there are dependancy issues with proxies
#
node /irods.*\.localhost/ inherits default {
	# install needed packages
	Package { ensure => "installed" }
	$enhancers = [ "httpd", "rpm-build", "gcc", "gcc-c++", "kernel-devel", "nfs-utils" ]
	package { $enhancers: }

	# turn on services
	service { "httpd":
		enable => true,
		ensure => "running",
		require => Package["httpd"],
	}
}
