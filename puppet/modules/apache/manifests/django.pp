# Note the default version for Django.

class apache::django ($django_version = "1.2.7-1") inherits apache {

  include apache::wsgi::daemon

  # Filesystem locations
  $app_dir = "$vardir/django"
  $python_sitedir = $lsbmajdistrelease ? {
    5 => '/usr/lib/python2.4/site-packages',
    6 => '/usr/lib/python2.6/site-packages',
  }

  package { 'MySQL-python' : ensure => present }
  package { 'Django' :
    ensure => "${django_version}.el${lsbmajdistrelease}"
  }
    
  # Django requires MySQLdb >= 1.2.1p2, so we have custom-built a 1.2.2 RPM
  # for RHEL5 systems
  if $lsbmajdistrelease == 5 {
    Package['MySQL-python'] { name => 'MySQL-python-122' }
  }

  # Annoyingly, Django admin media must be served from different locations
  # depending on the OS distribution, since it lives in Python's versioned
  # site-packages directory. This template uses $python_sitedir, set above.
  fragment { 'django':
    content => template('apache/django.conf.erb'),
    require => [ Package['mod_wsgi'], File["$vardir/django"] ],
  }

  file { $app_dir: ensure => directory }

  define app ($url_root) {
    $app_root = "${apache::django::app_dir}/$name"
    apache::fragment { "django-$name":
      content => template('apache/django-app.conf.erb'),
    }
  }

}
