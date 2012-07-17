class apache::mod_cgi inherits apache {

  fragment { 'mod_cgi':
    source => 'puppet:///modules/apache/fragments/mod_cgi.conf',
  }

}
