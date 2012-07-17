class ssh::server inherits ssh {

  package { 'openssh-server': }

  service { 'sshd':
    hasstatus => true,
    restart   => 'service sshd reload',
    require   => Package['openssh-server'],
    subscribe => File["$confdir/sshd_config"],
  }

  file {
    "$confdir/sshd_config":
      mode   => '600',
  }

}
