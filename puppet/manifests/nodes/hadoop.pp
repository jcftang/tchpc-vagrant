# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# template for tchpc site, there are dependancy issues with proxies
#
node /hadoop.*\.localhost/ inherits default {
	# install needed packages
        # generic devel tools and libraries
        if ! defined(Package['nfs-utils']) { package { 'nfs-utils': ensure => installed } }

	# turn on avahi so we can do things like  "ssh hadoop00.local" between the vm's
	include avahi

	# Create hadoop user and group
        group { "hadoopgroup":
                ensure => "present",
        }

	# the password is 'hadoopuser' to be consistant with the vagrant user account
        user { "hadoopuser":
                ensure     => "present",
		password   => '$1$4DVnT5wf$Se8F3oYdeMu4ktOzqSQmn/',
                managehome => true,
                gid        => "hadoopgroup",
                require    => Group["hadoopgroup"],
        }

	# take the vagrant key for now and use it for passwordless ssh configs
	ssh_authorized_key { "hadoopuser":
		ensure => "present",
		type => "ssh-rsa",
		key => "AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ==",
		name => "vagrant insecure public key",
		user => "hadoopuser",
		require => User["hadoopuser"],
	}

	file { "/home/hadoopuser/.ssh":
		ensure => "directory",
		mode => "0600",
		owner => "hadoopuser",
		group => "hadoopgroup",
		require => User["hadoopuser"],
	}

	file { "/home/hadoopuser/.ssh/id_rsa":
		mode => "0600",
		owner => "hadoopuser",
		group => "hadoopgroup",
		source => "puppet:///modules/insecure-keys/insecure_private_key" ,
		require => [ User["hadoopuser"], File["/home/hadoopuser/.ssh"], Ssh_authorized_key["hadoopuser"] ],
	}

	file { "/home/hadoopuser/.ssh/config":
		mode => "0600",
		owner => "hadoopuser",
		group => "hadoopgroup",
		source => "puppet:///modules/insecure-keys/insecure_config",
		require => [ User["hadoopuser"], File["/home/hadoopuser/.ssh"], Ssh_authorized_key["hadoopuser"] ],
	}

	# define the hosts in /etc/hosts
	host { 'hadoop00': ip => '10.0.1.120', host_aliases => 'hadoop00', }
	host { 'hadoop01': ip => '10.0.1.121', host_aliases => 'hadoop01', }
	host { 'hadoop02': ip => '10.0.1.122', host_aliases => 'hadoop02', }

	# disable selinux
	class { 'selinux':
		mode => 'disabled',
	}

	class { 'java': }
}
