class apache::mod_file_cache inherits apache {

  fragment { 'mod_file_cache':
    source => 'puppet:///modules/apache/fragments/mod_file_cache.conf',
  }

}
