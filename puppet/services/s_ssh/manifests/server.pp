class s_ssh::server inherits s_ssh {

  include ssh::server

  @iptables::open_port { 'ssh':
    networks => ['0/0'],
    number   => '22',
    comment  => 'Allow SSH',
  }

}
