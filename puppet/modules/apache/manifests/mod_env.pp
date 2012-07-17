class apache::mod_env inherits apache {

  fragment { 'mod_env':
    source => 'puppet:///modules/apache/fragments/mod_env.conf',
  }

}
