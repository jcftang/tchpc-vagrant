# this is intended to fulfill the needs of a basic hydra stack
#   REQUIRED variables:
#   you must set these in the calling .pp file
#      $rvm_system_ruby = 'ruby-1.9.3-p194'
#      $rvm_default_ruby = 'ruby-1.9.3-p194'
#
#   must be set by calling manifest for solr
#      $solr_home = "/home/lyberadmin/hydrus-solr"
#      $solr_data = "${solr_home}/data"
#      $solr_dirs = [$solr_home]
class s_hydra inherits defaults {

  # tomcat is used for Hydra's Solr (and Fedora on -dev box)

  include s_nokogiri::dependencies,
          s_rails,
          s_user,
          apache::mod_proxy_ajp,
          java6::devel,
          tomcat

  # Set some JAVA options (for tomcat)
  $solr_options = "-Dsolr.solr.home=${solr_home} -Dsolr.data.dir=${solr_data}"
  $jvm_options = '-Xms512m -Xmx512m -XX:PermSize=128m -XX:MaxPermSize=256m'
  $my_java_options  = "${solr_options} ${jvm_options} \$JAVA_OPTS -Djava.awt.headless=true"

  # Sets JAVA_OPTS for tomcat.
  # Uses $my_java_options
  # Possible resource defined in tomcat
  file { '/etc/tomcat/tomcat6.conf':
      content => template('s_hydra/tomcat6.conf.erb'),
      require => Package['tomcat6'],
      notify  => Service['tomcat6'],
  }

  # Enable localized apache config settings
  apache::fragment { "zzz-${hostname}":
    content => template('s_hydra/hydra-httpd.conf.erb'),
  }

  # Solr ---------------------

  # Create the base directory for the solr home directory structure
  file { $solr_dirs:
    ensure  => 'directory',
    owner   => 'lyberadmin',
    group   => 'tomcat',
    mode    => '0775',
    require => User['lyberadmin'],
  }

  # Install solr (vanilla)
  # to customize, a second class is needed, like s_dms::solr  or  s_hydrus::solr
  class { 's_solr':
    solr_home => $solr_home,
    owner     => 'lyberadmin',
    group     => 'tomcat',
  }

  # need to deploy Solr on tomcat (port 8080)
  iptables::open_port {'hydra-tomcat':
    networks => ['0/0'],
    number   => '8080',
    comment  => 'Allow access to tomcat solr from SU admin networks',
  }

}
