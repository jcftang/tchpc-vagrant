# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# template for tchpc site, there are dependancy issues with proxies
#
node /ceph.*\.localhost/ inherits default {
	# install needed packages
        # generic devel tools and libraries
        if ! defined(Package['nfs-utils']) { package { 'nfs-utils': ensure => installed } }
	if ! defined(Package['boost-devel']) { package { 'boost-devel': ensure => installed } }
	if ! defined(Package['epel-release']) { package { 'epel-release': ensure => installed } }
	if ! defined(Package['expat-devel']) { package { 'expat-devel': ensure => installed } }
	if ! defined(Package['fuse']) { package { 'fuse': ensure => installed } }
	if ! defined(Package['fuse-devel']) { package { 'fuse-devel': ensure => installed } }
	if ! defined(Package['gcc']) { package { 'gcc': ensure => installed } }
	if ! defined(Package['gcc-c++']) { package { 'gcc-c++': ensure => installed } }
	if ! defined(Package['keyutils-libs-devel']) { package { 'keyutils-libs-devel': ensure => installed } }
	if ! defined(Package['libaio-devel']) { package { 'libaio-devel': ensure => installed } }
	if ! defined(Package['libatomic_ops-devel']) { package { 'libatomic_ops-devel': ensure => installed } }
	if ! defined(Package['libcurl-devel']) { package { 'libcurl-devel': ensure => installed } }
	if ! defined(Package['libedit-devel']) { package { 'libedit-devel': ensure => installed } }
	if ! defined(Package['libtool']) { package { 'libtool': ensure => installed } }
	if ! defined(Package['libuuid-devel']) { package { 'libuuid-devel': ensure => installed } }
	if ! defined(Package['libxml2-devel']) { package { 'libxml2-devel': ensure => installed } }
	if ! defined(Package['nss']) { package { 'nss': ensure => installed } }
	if ! defined(Package['nss-devel']) { package { 'nss-devel': ensure => installed } }
	if ! defined(Package['rpmdevtools']) { package { 'rpmdevtools': ensure => installed } }
        if ! defined(Package['git']) { package { 'git': ensure => installed } }

	# these two are form EPEL
	if ! defined(Package['gperftools-devel']) { package { 'gperftools-devel': ensure => installed } }
	if ! defined(Package['fcgi-devel']) { package { 'fcgi-devel': ensure => installed } }

	# turn on avahi so we can do things like  "ssh ceph00.local" between the vm's
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

	# the follow is done so the vagrant user can be used for testing and development without needing to su to the cephuser account
	file { "/home/vagrant/.ssh/id_rsa":
		mode => "0600",
		owner => "vagrant",
		group => "vagrant",
		source => "puppet:///modules/insecure-keys/insecure_private_key" ,
	}

	file { "/home/vagrant/.ssh/config":
		mode => "0600",
		owner => "vagrant",
		group => "vagrant",
		source => "puppet:///modules/insecure-keys/insecure_config",
	}

	# define the hosts in /etc/hosts
	host { 'ceph00': ip => '10.0.1.130', host_aliases => 'ceph00', }
	host { 'ceph01': ip => '10.0.1.131', host_aliases => 'ceph01', }
	host { 'ceph02': ip => '10.0.1.132', host_aliases => 'ceph02', }

	# disable selinux
	class { 'selinux':
		mode => 'disabled',
	}
}
