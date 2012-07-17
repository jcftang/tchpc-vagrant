class apache::mod_mime inherits apache {

  fragment { 'mod_mime':
    source => 'puppet:///modules/apache/fragments/mod_mime.conf',
  }

}
