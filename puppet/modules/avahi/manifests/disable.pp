# manifests/disable.pp

class avahi::disable inherits avahi {
    include avahi::base::disable
}

class avahi::base::disable inherits avahi::base {
    Service['avahi-daemon']{
        ensure => stopped,
        enable => false,
    }
}
