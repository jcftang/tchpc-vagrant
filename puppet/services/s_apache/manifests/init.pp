class s_apache inherits defaults {

  file { '/var/log/httpd':
    ensure  => directory,
    group   => 'apache',
    mode    => 750,
    require => Package['httpd'];
  }

}
