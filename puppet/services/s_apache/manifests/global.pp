class s_apache::global inherits s_apache {

  include apache::basic

  @iptables::open_port { 'http':
    networks => ['0/0'],
    number   => '80',
    comment  => 'Allow HTTP from anywhere',
  }

}
