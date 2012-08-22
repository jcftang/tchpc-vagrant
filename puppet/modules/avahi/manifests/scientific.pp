class avahi::scientific inherits avahi::base {
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
  } else {
	if ! defined(Package['yum-conf-epel']) { package { 'yum-conf-epel': ensure => installed } }
        if ! defined(Package['nss-mdns']) { package { 'nss-mdns': ensure => installed,
                                                        require => Package['yum-conf-epel'] } }
        if ! defined(Package['avahi-tools']) { package { 'avahi-tools': ensure => installed } }
        if ! defined(Package['avahi-dnsconfd']) { package { 'avahi-dnsconfd': ensure => installed } }
        #if ! defined(Package['avahi']) { package { 'avahi': ensure => installed } }

        # turn on services
#        service { "avahi-daemon":
#                enable => true,
#                ensure => "running",
#                require => Package["avahi"],
#        }
        service { "avahi-dnsconfd":
                enable => true,
                ensure => "running",
		require => [ Package["avahi-dnsconfd"], Service["avahi-daemon"] ]
        }
  }
}
