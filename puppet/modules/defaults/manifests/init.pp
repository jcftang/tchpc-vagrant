# Setting sensible defaults for some native resource types can save us a lot
# of typing elsewhere. Modules that wish to use these default parameters (and
# all modules probably should, since any undesired values can be selectively
# overridden) should inherit this class.

class defaults {

  # Unless specified otherwise, assume all files should be present, owned
  # by root, and world-readable but only root-writable.
  File {
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '644',
  }

  # Unless specified otherwise, assume all users and groups that we configure
  # should be present.
  User { ensure => present }
  Group { ensure => present }

  # Unless specified otherwise, assume all .k5login files should be present
  # and have mode 600.
  K5login {
    ensure => present,
    mode   => '600',
  }

  # Unless specified otherwise, assume all services that we bother to
  # configure should be enabled and running.
  Service {
    enable => true,
    ensure => running,
  }

  # Unless specified otherwise, assume all cron jobs that we configure should
  # be present.
  Cron { ensure => present }

  # Unless specified otherwise, assume all SSH keys should be present.
  Sshkey { ensure => present }

  # Set a safe default PATH for exec resources, and make them log on failure.
  Exec {
    path      => '/bin:/usr/bin:/sbin:/usr/sbin',
    logoutput => on_failure,
  }

  # This noop exec is used to ensure that our repositories are configured
  # before we install any packages. All package resources that use the default
  # attributes below 'require' this exec, and all yumrepo resources using
  # these defaults are 'before' it. This makes sure that all our yumrepos are
  # installed before any packages are installed. Using this dummy resource as
  # an intermediate dependency keeps any particular repository or package
  # optional.
  exec { 'repositories-configured':
    user        => 'root',
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    cwd         => '/',
    command     => 'true',
    refreshonly => true,
  }

  # Unless specified otherwise, assume all yumrepos should be enabled, and
  # should be configured before we attempt to install any packages.
  Yumrepo {
    enabled => '1',
    before  => Exec['repositories-configured'],
  }

  # Unless specified otherwise, assume all packages that we mention should be
  # installed, but only after our repositories are configured.
  Package {
    ensure  => installed,
    require => Exec['repositories-configured'],
  }

  # This noop exec can be used to ensure that /etc/skel is configured before
  # we create any user accounts for human beings. These user resources should
  # 'require' this exec, while any explicit skel file or package that drops
  # files into /etc/skel should be 'before' this exec.
  exec { 'etc-skel-configured':
    user        => 'root',
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    cwd         => '/',
    command     => 'true',
    refreshonly => true,
  }

}
