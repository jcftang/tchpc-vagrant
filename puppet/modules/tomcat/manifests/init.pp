class tomcat inherits defaults {

  # Require the java6 class to be sure Java is installed before we install
  # Tomcat; otherwise yum might pull in the wrong JVM.
  require java6

  # Determine proper Tomcat version and libdir for the client's platform
  $tomcat_name = $lsbmajdistrelease ? {
    5 => 'tomcat5',
    6 => 'tomcat6',
  }
  $libdir = $lsbmajdistrelease ? {
    5 => '/usr/share/tomcat5/shared/lib',
    6 => '/usr/share/tomcat6/lib',
  }

  # Filesystem locations
  $confdir        = "/etc/${tomcat_name}"
  $catalina_home  = "/usr/share/${tomcat_name}"
  $manager_script = '/usr/local/bin/tomcat-manager'

  package {
    $tomcat_name: alias => 'tomcat';
    "${tomcat_name}-admin-webapps": ;
  }

  # For transitive dependencies, as the package creates the group
  group { 'tomcat': require => Package[$tomcat_name] }

  service { $tomcat_name:
    hasrestart => true,
    hasstatus  => true,
    require    => Package[$tomcat_name,"${tomcat_name}-admin-webapps"],
  }

  File {
    require => Package[$tomcat_name,"${tomcat_name}-admin-webapps"],
    before  => Service[$tomcat_name],
  }

  file {
    # Harden $confdir a little by adding the sticky bit
    $confdir:
      group => 'tomcat',
      mode  => '1775';

    # Create symlink to $confdir for more portable references
    '/etc/tomcat':
      ensure => link,
      target => $tomcat_name;

    # Install our minimal server.xml file
    "$confdir/server.xml":
      source => 'puppet:///modules/tomcat/server.xml',
      notify => Service[$tomcat_name];

    # Install script for command-line control via the manager webapp
    $manager_script:
      mode   => '755',
      source => 'puppet:///modules/tomcat/tomcat-manager';

    # Manage permissions on the curlrc file used by our manager script
    "$confdir/curlrc":
      mode => '600';

    # Manage permissions on the user database
    "$confdir/tomcat-users.xml":
      group => 'tomcat',
      mode  => '640';
  }

  # Initialize the user database (just once) for the manager webapp
  exec { 'tomcat-configure-manager-webapp-user':
    user    => 'root',
    command => "$manager_script configure",
    creates => "$confdir/curlrc",
    before  => File["$confdir/tomcat-users.xml","$confdir/curlrc"],
  }

  # This definition symlinks a jarfile to Tomcat's shared lib directory, where
  # the webapps' classloader can find it.
  define sharedjar {
    file { "${tomcat::libdir}/$name.jar":
      ensure  => link,
      target  => "${java6::jardir}/$name.jar",
      require => Package["${tomcat::tomcat_name}"],
      before  => Service["${tomcat::tomcat_name}"],
    }
  }

  # If shared jars are supplied by native packages, this definition can be
  # used to declare the package and the jar link (or links) in one resource.
  define sharedpkg ($jars=$name, $extra_jars=[]) {
    $all_jars = concat($jars, $extra_jars)
    package { $name:
      ensure  => installed,
      require => [ Exec['repositories-configured'], Package['java6'] ],
    }
    sharedjar { $all_jars: require => Package[$name] }
  }

}

# This definition creates a webapp context XML file
define tomcat::webapp ($docbase, $path) {

  include tomcat

  file { "$tomcat::confdir/Catalina/localhost/$name.xml":
    content => template('tomcat/webapp.xml.erb'),
    owner   => 'tomcat',
    group   => 'tomcat',
    require => Package["${tomcat::tomcat_name}"],
    notify  => Service["${tomcat::tomcat_name}"];
  }

}
