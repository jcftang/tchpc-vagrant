class mysql::server inherits mysql {

  # Filesystem locations
  $conffile   = '/etc/my.cnf'
  $datadir    = '/var/lib/mysql'
  $privatedir = '/var/lib/mysql-private'
  $socket     = '/var/lib/mysql/mysql.sock'

  # Scripts that we will deliver and use locally, mostly in exec resources
  $secure_script    = '/usr/local/libexec/mysql_secure_automatic'
  $create_db_script = '/usr/local/libexec/mysql_create_db'
  $snapshot_script  = '/usr/local/libexec/mysql_snapshot'

  # Bind mysql daemon to $mysql_bindaddress, or local interface if unspecified
  $real_bindaddress = default_value($mysql_bindaddress, '127.0.0.1')

  package { 'mysql-server': }

  service { 'mysqld':
    hasstatus  => true,
    hasrestart => true,
    require    => Package['mysql-server'],
  }

  File {
    require => Package['mysql-server'],
    before  => Service['mysqld'],
  }

  file {
    $conffile:
      content => template('mysql/server/my.cnf.erb');

    # Install one-time configuration script to secure MySQL accounts
    $secure_script:
      mode   => '755',
      source => 'puppet:///modules/mysql/server/mysql_secure_automatic';

    # Install short script to create databases and eponymous users with
    # random passwords
    $create_db_script:
      mode    => '755',
      content => template('mysql/server/mysql_create_db.erb');

    # The db-creation script drops passwords into this root-only private
    # directory, whence they're extracted into application configuration
    $privatedir:
      ensure => directory,
      mode   => '700';
  }

  # Run one-time configuration script to secure MySQL accounts
  exec { 'mysql-server-secure-installation':
    user    => 'root',
    command => $secure_script,
    creates => '/root/.my.cnf',
    require => Service['mysqld'],
  }

  define database ($charset='', $collate='') {
    exec { "mysql-server-database-$name":
      user    => 'root',
      path    => '/bin:/usr/bin:/sbin:/usr/sbin',
      command => "${mysql::server::create_db_script} $name $charset $collate",
      creates => "${mysql::server::datadir}/$name",
      require => Exec['mysql-server-secure-installation'],
    }
    file { "${mysql::server::privatedir}/$name":
      owner   => 'root',
      group   => 'root',
      mode    => '600',
      require => Exec["mysql-server-database-$name"],
    }
  }

  # If mysql data is on its own logical volume, as indicated by our custom
  # fact mysql_logvol, add a TSM preschedule command to snapshot the volume
  # just before scheduled backup runs. The snapshot volume is mounted at
  # $datadir.snapshot, so we exclude live data in $datadir from backups. The
  # preschedulecmd and exclusion are conditional on the presence of the
  # tsm::client class, which realizes the virtual resources we declare here.

  if $mysql_logvol == 'true' {

    file {
      $snapshot_script:
        mode   => '755',
        source => 'puppet:///modules/mysql/server/mysql_snapshot';
      "$datadir.snapshot":
        ensure => directory,
        owner  => undef,
        group  => undef,
        mode   => undef;
    }

    @tsm::preschedulecmd { 'mysql_snapshot':
      command => "$snapshot_script $datadir $datadir.snapshot",
      require => File[$snapshot_script,"$datadir.snapshot"],
    }

    @tsm::exclude { $datadir:
      type    => 'fs',
      require => Tsm::Preschedulecmd['mysql_snapshot'],
    }
  }

}
