class apache::mod_rewrite inherits apache {

  fragment { 'mod_rewrite':
    source => 'puppet:///modules/apache/fragments/mod_rewrite.conf',
  }

}
