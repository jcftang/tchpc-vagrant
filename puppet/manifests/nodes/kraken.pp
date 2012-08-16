#
# template for tchpc site, there are dependancy issues with proxies
#
node 'kraken.localhost' inherits default {
	# install needed packages
	Package { ensure => "installed" }
	$enhancers = [ "httpd" ]
	package { $enhancers: }

	# turn on services
	service { "httpd":
		enable => true,
		ensure => "running",
		require => Package["httpd"],
	}


	# install rvm and ruby but do not default to rvm's version of ruby as GEM_PATH gets clobbered and breaks puppet
	include rvm
	rvm::system_user { vagrant: ; }
	rvm_system_ruby {
		'ruby-1.9.3-p194':
		ensure => 'present',
		default_use => false,
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
		'ruby-1.9.3-p194/puppet':
		ensure => 'present',
		require => Rvm_gemset['ruby-1.9.3-p194'];
	}

	# openjdk from repos
	class { "java":	}
}
