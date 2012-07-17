class apache::wsgi::daemon inherits apache::wsgi {

  fragment { 'wsgi-daemon':
    source  => 'puppet:///modules/apache/fragments/wsgi-daemon.conf',
    require => Package['mod_wsgi'],
  }

}
