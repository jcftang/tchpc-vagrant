class apache::mod_deflate inherits apache {

  fragment { 'mod_deflate':
    source => 'puppet:///modules/apache/fragments/mod_deflate.conf',
  }

}
