node 'cports.localhost' inherits default {
	Package { ensure => "installed" }
	$enhancers = [ "gcc-gfortran", "environment-modules", "texinfo", "patch" ]
	package { $enhancers: }
}
