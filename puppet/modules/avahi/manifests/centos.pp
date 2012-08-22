class avahi::centos inherits avahi::base {
  if $lsbmajdistrelease == '5' {
    file{'/etc/init.d/avahi-daemon':
      source => "puppet://${server}/modules/avahi/init.d/${operatingsystem}/avahi-daemon",
      require => Package['avahi'],
      before => Service['avahi-daemon'],
      owner => root, group => 0, mode => 0755;
    }

    if $selinux == 'true' {
      File['/etc/init.d/avahi-daemon']{
        seltype => 'avahi_initrc_exec_t',
      }
    }
  }
}