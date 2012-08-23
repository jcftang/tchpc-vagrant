# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# template for tchpc site, there are dependancy issues with proxies
#
node /irods.*\.localhost/ inherits default {
	# install needed packages
        # generic devel tools and libraries
        if ! defined(Package['rpm-build']) { package { 'rpm-build': ensure => installed } }
        if ! defined(Package['kernel-devel']) { package { 'kernel-devel': ensure => installed } }
        if ! defined(Package['gcc']) { package { 'gcc': ensure => installed } }
        if ! defined(Package['gcc-c++']) { package { 'gcc-c++': ensure => installed } }
        if ! defined(Package['nfs-utils']) { package { 'nfs-utils': ensure => installed } }

	# turn on avahi so we can do things like  "ssh irods00.local" between the vm's
	include avahi

	# Create irods user and group
        group { "irodsgroup":
                ensure => "present",
        }

	# the password is 'irodsuser' to be consistant with the vagrant user account
        user { "irodsuser":
                ensure     => "present",
		password   => '$1$C2belLAF$LE8witu7vfx0uijSw5SzZ0',
                managehome => true,
                gid        => "irodsgroup",
                require    => Group["irodsgroup"],
        }

	# define the hosts in /etc/hosts
	host { 'irods00': ip => '10.0.1.110', host_aliases => 'irods00', }
	host { 'irods01': ip => '10.0.1.111', host_aliases => 'irods01', }
	host { 'irods02': ip => '10.0.1.112', host_aliases => 'irods02', }

	# disable selinux
	class { 'selinux':
		mode => 'disabled',
	}

}
