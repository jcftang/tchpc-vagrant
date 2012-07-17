class iptables inherits defaults {

  # Filesystem locations
  $conffile = '/etc/sysconfig/iptables'
  $confd    = '/etc/iptables.d'

  package { 'iptables': }

  service { 'iptables':
    hasstatus  => true,
    hasrestart => true,
    require    => Package['iptables'],
    subscribe  => Exec["rebuild-file-$conffile"],
  }

  file {'/etc/sysconfig/iptables-config':
    content => template('iptables/iptables-config.erb'),
    mode    => '600',
  }

  concat::file { $conffile:
    dir     => $confd,
    mode    => '600',
    require => Package['iptables'],
  }

  define table {
    concat::fragment {
      "iptables-$name-preamble":
        dir      => $confd,
        prio     => "$name-000",
        filename => 'preamble',
        source   => "puppet:///modules/iptables/preamble-$name";
      "iptables-$name-commit":
        dir      => $confd,
        prio     => "$name-999",
        filename => 'commit',
        content  => "COMMIT\n";
    }
  }

  # Declare table sections virtually; realize them as necessary
  @table { ['filter','nat','mangle','raw']: }

  # Standard firewall rules
  fragment {
    'firewall-chain':
      source => 'puppet:///modules/iptables/firewall-chain',
      prio   => '010';
    'loopback-and-related':
      source => 'puppet:///modules/iptables/loopback-and-related',
      prio   => '020';
    'safe-icmp':
      source => 'puppet:///modules/iptables/safe-icmp',
      prio   => '030';
    'end-preamble':
      content => "\n",
      prio    => '040';
    'firewall-drop':
      source => 'puppet:///modules/iptables/firewall-drop',
      prio   => '990';
  }

  # Add a configuration fragment in iptables-save format. This is the
  # workhorse definition, for internal and external use.
  define fragment (
    $table   = 'filter',
    $prio    = '500',
    $content = '',
    $source  = ''
  ) {
    realize(Iptables::Table[$table])
    concat::fragment { "iptables-$table-$name":
      dir      => $iptables::confd,
      prio     => "$table-$prio",
      filename => $name,
      source   => $source,
      content  => $content,
    }
  }

  # A less-powerful but simpler-to-use definition for external use
  define open_port (
    $networks,
    $number,
    $proto   = 'tcp',
    $comment = '',
    $prio    = ''
  ) {
    $real_proto = $proto ? {
      'both'  => ['tcp','udp'],
      default => $proto,
    }
    iptables::fragment { $name: content => template('iptables/open_port.erb') }
    if $prio { Iptables::Fragment[$name] { prio => $prio } }
  }

  # Realize all fragments and open_ports declared virtually by other modules
  Iptables::Fragment<||>
  Iptables::Open_port<||>

}
