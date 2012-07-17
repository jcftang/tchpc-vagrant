class apache::mod_proxy_http inherits apache {

  fragment { 'mod_proxy_http':
    source => 'puppet:///modules/apache/fragments/mod_proxy_http.conf',
  }

}
