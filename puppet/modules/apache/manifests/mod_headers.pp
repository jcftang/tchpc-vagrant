class apache::mod_headers inherits apache {

  fragment { 'mod_headers':
    source => 'puppet:///modules/apache/fragments/mod_headers.conf',
  }

}
