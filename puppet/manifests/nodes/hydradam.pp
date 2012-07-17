node 'hydradam.localhost' {

   $rvm_system_ruby = 'ruby-1.9.3-p194'
   $passenger_version = '3.0.12'
   $rvm_default_ruby = $rvm_system_ruby
   $railsenv = 'development'

  package { 'perl-XML-Twig': ensure => present }
  package { 'perl-Image-ExifTool': ensure => present }

   include s_basenode,
          s_apache,
          s_nokogiri::dependencies,
          rvm,
          s_rails,
          mysql::server,
          s_ssh

  class { 'java':
    distribution => 'java-1.6.0-openjdk',
  }

     include s_servicemix, s_hydrajetty

        class { 'rvm::passenger::gem': 
                  version => $passenger_version,
                  ruby_version => $rvm_system_ruby }

        # include s_ruby::rvm


  file { 

  "/var/www/hydradam":
    ensure  => directory,
    group   => 'hydradam',
    owner    => 'vagrant',
    mode    => 775,
    require => [File['/var/www']];

    "/var/www/hydradam/shared":
      ensure  => directory,
      group   => 'hydradam',
      owner   => 'vagrant',
      mode    => 775,
      require => File["/var/www/hydradam"];

    "/var/www/hydradam/current":
      ensure => link,
      target => '/var/www/hydradam/initial_release',
      require => File["/var/www/hydradam/initial_release"];

    "/var/www/hydradam/initial_release":
      ensure  => directory,
      group   => 'hydradam',
      owner   => 'vagrant',
      mode    => 775,
      require => File["/var/www/hydradam/releases"];

    "/var/www/hydradam/initial_release/public":
      ensure  => directory,
      group   => 'hydradam',
      owner   => 'vagrant',
      mode    => 775,
      require => File["/var/www/hydradam/initial_release"];

    "/var/www/hydradam/releases":
      ensure  => directory,
      group   => 'hydradam',
      owner   => 'vagrant',
      mode    => 775,
      require => File["/var/www/hydradam"];
  }

  apache::fragment { "zzz-$hostname":
    source => "puppet:///modules/s_hydradam/hydradam.conf"
  }

  File["${apache::confd}/zzz-$hostname.conf"] <- File['/var/www/hydradam/current'] 

}
