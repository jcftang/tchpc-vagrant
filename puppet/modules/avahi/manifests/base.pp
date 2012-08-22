class avahi::base {
  package {
    'avahi' :
      ensure => present,
  }
  service {
    'avahi-daemon' :
      ensure => running,
      enable => true,
      hasstatus => true,
      require => Package[avahi],
  }
}