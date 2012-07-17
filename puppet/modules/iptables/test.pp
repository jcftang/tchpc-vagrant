$private_nets = ['10/8','172.16/12','192.168/16']

include iptables

iptables::open_port { 'ssh':
  networks => '0/0',
  number   => '22',
  comment  => 'Allow SSH from everywhere',
}

iptables::open_port { 'dns':
  networks => $private_nets,
  number   => '53',
  proto    => 'both',
  comment  => 'Allow DNS queries from RFC-1918 private networks',
}

iptables::fragment { 'nat-output-accept':
  table   => 'nat',
  content => "-P OUTPUT ACCEPT\n",
}
