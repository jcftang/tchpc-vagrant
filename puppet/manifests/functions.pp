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
