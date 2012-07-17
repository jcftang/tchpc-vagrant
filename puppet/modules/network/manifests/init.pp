class network inherits defaults {

  define interface (
    $device,
    $bootproto = 'static',
    $hwaddr,
    $ipaddr,
    $ipv6init  = 'yes',
    $mtu       = '1500',
    $netmask,
    $onboot    = 'yes'
  ) {

    # Create the device definition file
    file { "/etc/sysconfig/network-scripts/ifcfg-$device":
      content => template('network/ifcfg.erb'),
      owner   => 'root',
      group   => 'root',
    }

    # Ifdown and ifup the new interface upon changes
    exec { "ifdown-ifup-$device":
      user        => 'root',
      path        => '/etc/sysconfig/network-scripts:/bin:/usr/bin:/sbin:/usr/sbin',
      command     => "/sbin/ifdown $device ; /sbin/ifup $device",
      refreshonly => true,
      subscribe   => File["/etc/sysconfig/network-scripts/ifcfg-$device"],
    }

  }

}
