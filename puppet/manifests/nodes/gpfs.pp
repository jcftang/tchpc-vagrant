# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# template for tchpc site, there are dependancy issues with proxies
#
node /gpfs.*\.localhost/ inherits default {
	# install needed packages
	# generic devel tools and libraries
	if ! defined(Package['rpm-build']) { package { 'rpm-build': ensure => installed } }
	if ! defined(Package['kernel-devel']) { package { 'kernel-devel': ensure => installed } }
	if ! defined(Package['gcc']) { package { 'gcc': ensure => installed } }
	if ! defined(Package['gcc-c++']) { package { 'gcc-c++': ensure => installed } }
	if ! defined(Package['nfs-utils']) { package { 'nfs-utils': ensure => installed } }

	# bonjour/zeroconf/avahi adhoc dns entries
	include avahi

	# take the vagrant key for now and use it for passwordless ssh configs
        ssh_authorized_key { "root":
                ensure => "present",
                type => "ssh-rsa",
                key => "AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ==",
                name => "vagrant insecure public key",
                user => "root",
        }

        file { "/root/.ssh/id_rsa":
                mode => "0600",
                owner => "root",
                group => "root",
                source => "puppet:///modules/insecure-keys/insecure_private_key" ,
		require => Ssh_authorized_key["root"],
        }

        file { "/root/.ssh/config":
                mode => "0600",
                owner => "root",
                group => "root",
                source => "puppet:///modules/insecure-keys/insecure_config",
		require => Ssh_authorized_key["root"],
        }

	# define the hosts in /etc/hosts
        host { 'gpfs00': ip => '10.0.1.100', host_aliases => 'gpfs00', }
        host { 'gpfs01': ip => '10.0.1.101', host_aliases => 'gpfs01', }
        host { 'gpfs02': ip => '10.0.1.102', host_aliases => 'gpfs02', }

        # disable selinux
        class { 'selinux':
                mode => 'disabled',
        }
}
