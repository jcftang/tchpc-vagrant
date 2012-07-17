class apache::ssl::minimal inherits apache::ssl {

  fragment {
    # Remove this RPM-installed fragment to disable the standard port 443
    # configuration by default
    'ssl': ensure => absent;

    # Deliver bare-bones configuration fragment, which includes generic
    # mod_ssl settings but does not configure any HTTPS listeners
    'mod_ssl': source => 'puppet:///modules/apache/fragments/mod_ssl.conf';
  }

}
