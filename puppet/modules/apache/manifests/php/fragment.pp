define apache::php::fragment (
  $ensure  = 'present',
  $group   = 'root',
  $mode    = '644',
  $content = '',
  $source  = ''
) {
  $path = "/etc/php.d/$name.ini"
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
