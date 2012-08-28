node 'precise64.localhost' inherits default {
	exec { 'apt-get update':
    		command => '/usr/bin/apt-get update',
	}
	
	Exec["apt-get update"] -> Package <| |>

	# install needed packages
	if ! defined(Package['git']) { package { 'git': ensure => installed } }
	if ! defined(Package['git-annex']) { package { 'git-annex': ensure => installed } }
	if ! defined(Package['ikiwiki']) { package { 'ikiwiki': ensure => installed } }
	if ! defined(Package['perlmagick']) { package { 'perlmagick': ensure => installed } }
	if ! defined(Package['make']) { package { 'make': ensure => installed } }

	# the current avahi module isn't generic enough to deal with rhel and debian
	#include avahi
	if ! defined(Package['avahi-daemon']) { package { 'avahi-daemon': ensure => installed } }
}
