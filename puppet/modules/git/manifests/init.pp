class git inherits defaults {

  package { ['git','git-email']: }

  if ( $::ipaddress_eth0 =~ /^172.2/ ) {
    file { '/etc/gitconfig':
      source  => 'puppet:///modules/git/gitconfig.nonrouted',
      require => Package['git'],
    }
  }
  else {
    file { '/etc/gitconfig':
      source  => 'puppet:///modules/git/gitconfig',
      require => Package['git'],
    }
  }

}
