# -*- mode: ruby -*-
# vi: set ft=ruby :

## define some stages as proxies need to be configured before main
stage { [pre, post]: }
Stage[pre] -> Stage[main] -> Stage[post]

# Import site-wide variables
import 'variables.pp'
import 'functions.pp'

# Import node definitions from any additional manifests
import 'nodes/*.pp'

# Default thing to do for all nodes
node "default" {
	# comment out the following line if you are not on the TCHPC network
	class { "tchpc": stage => pre }

	case $operatingsystem {
		'scientific', 'redhat', 'centos': {
			$supported = RHEL
		}

		'debian', 'ubuntu': {
			$supported = DEBIAN
		}

		default: {
			$supported = false
			notify { "${module_name}_unsupported":
				message => "The ${module_name} module is not supported on ${operatingsystem}",
			}
		}
	}

	if ( $supported == RHEL ) {
		service { "iptables":
			enable => false,
			ensure => "stopped",
		}
	}

}
