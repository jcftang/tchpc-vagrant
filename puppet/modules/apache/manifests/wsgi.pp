class apache::wsgi inherits apache {

  package { 'mod_wsgi': }

  # Unfortunately, the mod_wsgi package from EPEL 5 delivers a wsgi fragment
  # that does not load the module; it just shows one how to do so in a
  # commented block. On our RHEL5 systems, we must replace that fragment with
  # this one, which removes the comment and enables the module.
  if $lsbmajdistrelease == 5 {
    fragment { 'wsgi':
      source  => 'puppet:///modules/apache/fragments/wsgi.conf',
      require => Package['mod_wsgi'],
    }
  }

}
