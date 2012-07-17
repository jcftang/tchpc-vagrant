class apache::basic inherits apache::minimal {

  # Listen on $http_listen_address, or all interfaces if unspecified
  $real_http_listen_address = default_value($http_listen_address, '*')

  fragment {
    # Listen on port 80; serve content from the standard document root;
    # configure standard index files and type-handling
    'basic': content => template('apache/basic.conf.erb');

    # Configure standard autoindexes and allow them in the document root
    'indexes': source => 'puppet:///modules/apache/fragments/indexes.conf';
  }

}
