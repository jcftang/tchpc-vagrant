class s_hydrajetty {
  define download_file(
        $from="",
        $cwd="") {                                                                                         

    exec { $name:                                                                                                                     
        command  => "curl -o ${cwd}/${name} ${from}",                                                         
        cwd      => $cwd,
        path     => "/sbin:/bin:/usr/sbin:/usr/bin",
        creates  => "${cwd}/${name}",                                                              
    }

    file { "${cwd}/${name}":
      mode    => 644,
      require => Exec["${name}"]
    }

    if $require {
      Exec[$name] {
        require +> $require
      }
    }
  }

  define extract_file(
    $destdir="",
    $creates="",
    $user="",
    $to
  ) {
    exec { $name:
      command => "tar -xvz -C ${destdir} -f ${name}",
      path    => "/usr/bin:/bin",
      user    => "${user}",
      creates => "${destdir}/${creates}",                                                              
    }

    file { "${destdir}/${creates}":
      mode    => 775,
      require => Exec["${name}"]
    }

    exec { "/bin/mv ${destdir}/${creates} ${to}":
      require => File["${destdir}/${creates}"],
      creates => "${to}"
    }

    file { "${to}":
      require => Exec["/bin/mv ${destdir}/${creates} ${to}"]
    }

  }
  

  file {
    "/etc/init.d/jetty":
      mode    => "0755",
      content => template("s_hydrajetty/jetty.erb"),
      require => Exec['checkout hydra-jetty']
  }

  
  file { "/var/www/hydradam/hydra-jetty/etc/jetty-logging.xml":
    mode    => "0644",
    content => template("s_hydrajetty/jetty-logging.xml"),
    require => Exec['checkout hydra-jetty']
  }

  
  exec { "checkout hydra-jetty":
    creates => "/var/www/hydradam/hydra-jetty",
    command => "git clone git://github.com/projecthydra/hydra-jetty.git",
    cwd     => "/var/www/hydradam",
    path    => "/usr/bin:/bin",
    user    => 'vagrant',
    timeout => 0,
    require => [Package['git'], File['/var/www/hydradam']]
  }


   download_file { "mysql-connector-java.tar.gz":
    from => "http://mirror.services.wisc.edu/mysql/Downloads/Connector-J/mysql-connector-java-5.1.18.tar.gz",
    cwd  => "/tmp"
  }

  extract_file { "/tmp/mysql-connector-java.tar.gz":
    destdir => "/tmp/",
    creates => "mysql-connector-java-5.1.18",
    user    => 'vagrant',
    to      => '/tmp/mysql-connector-java',
    require => [File["/tmp/mysql-connector-java.tar.gz"]]
  }

  exec { "cp /tmp/mysql-connector-java/mysql-connector-java-5.1.18-bin.jar /var/www/hydradam/hydra-jetty/webapps/fedora/WEB-INF/lib":
     creates => '/var/www/hydradam/hydra-jetty/webapps/fedora/WEB-INF/lib/mysql-connector-java-5.1.18-bin.jar',
     cwd     => "/var/www/hydradam",
     path    => '/usr/bin:/bin',
     require => [File['/tmp/mysql-connector-java'], Exec['checkout hydra-jetty']]
  }
  

  exec { 'start jetty service':
    command => "/usr/bin/sudo /sbin/chkconfig jetty on; /usr/bin/sudo /sbin/service jetty start", 
    require => [File['/etc/init.d/jetty'], File["/etc/default/jetty"]]
  }

    file { "/etc/default":
      ensure => directory;

    "/etc/default/jetty":
      require  => [File['/etc/default']],
      content => "JETTY_HOME=/var/www/hydradam/hydra-jetty\nJETTY_USER=vagrant"
  }

    iptables::open_port { 'jetty':
    networks => ['0/0'],
    number   => '8983',
    comment  => 'Allow access to jetty ports from everywhere',
  }
}
