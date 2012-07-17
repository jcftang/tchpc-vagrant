class apache::mod_dir inherits apache {

  fragment { 'mod_dir':
    source => 'puppet:///modules/apache/fragments/mod_dir.conf',
  }

}
