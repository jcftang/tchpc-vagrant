class apache::mod_proxy_ajp inherits apache {

  fragment { 'mod_proxy_ajp':
    source => 'puppet:///modules/apache/fragments/mod_proxy_ajp.conf',
  }

}
