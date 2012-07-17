class apache::mod_filter inherits apache {

  fragment { 'mod_filter':
    source => 'puppet:///modules/apache/fragments/mod_filter.conf',
  }

}
