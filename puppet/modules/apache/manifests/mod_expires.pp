class apache::mod_expires inherits apache {

  fragment { 'mod_expires':
    source => 'puppet:///modules/apache/fragments/mod_expires.conf',
  }

}
