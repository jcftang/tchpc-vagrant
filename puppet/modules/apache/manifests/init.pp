class apache inherits defaults {

  # Filesystem locations
  $conffile = '/etc/httpd/conf/httpd.conf'
  $confd    = '/etc/httpd/conf.d'
  $vardir   = '/var/www'

  package { 'httpd': }

  group {
    # Make resources that autorequire Group['apache'] transitively require
    # Package['httpd'] (which actually creates the group)
    'apache': require => Package['httpd'];

    # Add a www group to control access to web content
    'www': gid => '202';
  }

  # Add the apache user to the www group
  user { 'apache':
    groups  => 'www',
    require => Package['httpd'],
    before  => Service['httpd'],
  }

  service { 'httpd':
    hasstatus => true,
    restart   => 'service httpd restart',
    require   => Package['httpd'],
    subscribe => File[$confd],
  }

  File {
    require => Package['httpd'],
    before  => Service['httpd'],
  }

  # Make sure any module packages are not only installed before we start
  # up httpd, but trigger a refresh if httpd was already running
  Package { notify => Service['httpd'] }

  file {
    # Make file resources which autorequire $confd and $vardir transitively
    # require Package['httpd'] (which actually creates these directories)
    [$confd,$vardir]: ensure => directory;

    # Declare $conffile for dependency purposes, but don't manage content
    $conffile: ensure => present;
  }

  define fragment (
    $ensure  = 'present',
    $group   = 'root',
    $mode    = '644',
    $content = '',
    $source  = ''
  ) {
    $path = "${apache::confd}/$name.conf"
    file { $path:
      ensure  => $ensure,
      owner   => 'root',
      group   => $group,
      mode    => $mode,
      notify  => Service['httpd'],
    }
    if $source     { File[$path] { source  => $source  } }
    elsif $content { File[$path] { content => $content } }
  }

}
