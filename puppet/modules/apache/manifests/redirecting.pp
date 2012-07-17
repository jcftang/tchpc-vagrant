class apache::redirecting inherits apache {

  # Select canonical name to redirect HTTP clients to
  $real_canonical_www_name = default_value($canonical_www_name, $fqdn)

  fragment { 'redirect': content => template('apache/redirect.conf.erb') }

}
