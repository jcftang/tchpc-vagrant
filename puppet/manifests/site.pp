# Import site-wide variables
import 'variables.pp'
import 'functions.pp'

# Import node definitions from any additional manifests
import 'nodes/*.pp'

# Default thing to do for all nodes
node "default" {
	class { "tchpc": }

	service { "iptables":
		enable => false,
		ensure => "stopped",
	}

	line { ntp_conf:
		file => "/etc/ntp.conf",
		line => "server ntp.tchpc.tcd.ie",
	}

	service { "ntpd":
		enable => true,
		ensure => "running",
		require => Line["ntp_conf"],
	}
}
