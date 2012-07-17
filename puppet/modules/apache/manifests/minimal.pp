class apache::minimal inherits apache {

  # Deliver bare-bones configuration file, which sets a few generic options
  # and includes $confd fragments. Additional configuration is kept in
  # fragments to allow selective overrides.
  File[$conffile] {
    source => 'puppet:///modules/apache/minimal.conf',
    notify => Service['httpd'],
  }

  # Allow customization of access log format with $log_format variable
  $real_log_format = default_value($log_format, 'common')

  fragment {
    # Remove this RPM-installed fragment to disable the Red Hat welcome page
    'welcome': ensure => absent;

    # Standard MPM configuration
    'mpm': source => 'puppet:///modules/apache/fragments/mpm.conf';

    # Access log configuration
    'log': content => template('apache/log.conf.erb');
  }

  # Also remove this extra default fragment on RHEL5
  if $lsbmajdistrelease == 5 { fragment { 'proxy_ajp': ensure => absent } }

}
