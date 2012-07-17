class yum inherits defaults {

  # Filesystem locations
  $conffile = '/etc/yum.conf'

  # Use this definition to add repositories with GPG keys delivered by Puppet,
  # which is safer than pulling keys over the internet.
  define repo_with_key (
    $baseurl,
    $descr,
    $gpgkeysource,
    $enabled  = '1',
    $priority = 'absent',
    $exclude  = []
  ) {

    $gpgkeybasename = regsubst($gpgkeysource, '.*/', '')
    $gpgkeyfile = "/etc/pki/rpm-gpg/$gpgkeybasename"

    yumrepo { $name:
      baseurl  => $baseurl,
      descr    => $descr,
      priority => $priority,
      exclude  => $exclude,
      enabled  => $enabled,
      protect  => '0',
      gpgcheck => '1',
      gpgkey   => "file://$gpgkeyfile",
      require  => File[$gpgkeyfile],
    }

    # Check whether our key file resource is already defined before declaring
    # it, to allow multiple repositories to use the same Puppet-delivered key.
    if !defined(File[$gpgkeyfile]) {
      file { $gpgkeyfile: source => $gpgkeysource }
    }

  }

}
