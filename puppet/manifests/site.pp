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

	service { "iptables":
		enable => false,
		ensure => "stopped",
	}
}
