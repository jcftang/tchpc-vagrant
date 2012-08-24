node 'test.localhost' inherits default {
	# install needed packages
	if ! defined(Package['git']) { package { 'git': ensure => installed } }

	include avahi
	class { "java": }
	class { "jenkins": require => Class["java"], }
}
