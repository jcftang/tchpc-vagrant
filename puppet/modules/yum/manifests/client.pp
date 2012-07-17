class yum::client inherits yum {

  # Unlike most packages, yum and yum plugins should be installed very early,
  # before repositories are configured, since the behavior of those repos may
  # depend on which plugins are installed. Override the usual ordering that we
  # inherit from the defaults class here.
  Package {
    require => [],
    before  => Exec['repositories-configured'],
  }

  package { 'yum': }

  # On RHEL5, install the python-hashlib package, so that yum can use
  # repositories created with SHA-256 checksums.
  if $lsbmajdistrelease == 5 { package { 'python-hashlib': } }

}
