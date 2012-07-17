class apache::ssl inherits apache {

  package { 'mod_ssl': }

  # Sadly, resource defaults can't use the plusignment operator
  File { require => Package['httpd','mod_ssl'] }

  @@nagios_service {"check-certificate_${hostname}":
    use           => 'check-certificate',
    host_name     => "$hostname",
    servicegroups => 'all-service-checks,http-cert-checks'
  }
}
