class s_rails::hydra inherits s_rails {

  include tomcat

  @iptables::open_port {
    'tomcat-coyote':
      networks => ['0/0'],
      number   => '8080:8089',
      comment  => 'Allow access to tomcat coyote ports';
    'solr-fedora':
      networks => ['0/0'],
      number   => '8980:8989',
      comment  => 'Allow access to solr/fedora ports';
  }

}
