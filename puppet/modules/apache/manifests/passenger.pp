class apache::passenger inherits apache {

  # The native-libs package must be installed explicitly; it is not pulled in
  # by mod_passenger
  package { ['mod_passenger','rubygem-passenger-native-libs']: }

  File { require => Package['mod_passenger','rubygem-passenger-native-libs'] }

  fragment { 'passenger-config':
    source => 'puppet:///modules/apache/fragments/passenger-config.conf',
  }

  define rails_app ($app_root, $url_root, $env='production') {
    file {
      "${app_root}/public${url_root}":
        ensure => link,
        target => '.',
        before => Apache::Fragment["rails-${name}"];
      "/var/www/html${url_root}":
        ensure => link,
        target => "${app_root}/public",
        before => Apache::Fragment["rails-${name}"];
    }
    apache::fragment { "rails-${name}":
      content => template('apache/rails-app.conf.erb'),
    }
  }

}
