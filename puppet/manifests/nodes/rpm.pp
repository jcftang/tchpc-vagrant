node 'rpm.localhost' inherits default {
	Package { ensure => "installed" }
	$enhancers = [ "gcc-gfortran"
			, "rpm-build"
			, "rpmdevtools"
			, "rpmlint"
			, "texinfo"
			, "patch"
			, "libtool"
			, "automake"
			, "autoconf"
			, "bison"
			, "flex"
			, ]
	package { $enhancers: }
}
