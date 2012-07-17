class apache::archivelogs inherits apache {

  # Install custom logrotate configuration to save 2 years of compressed httpd
  # logs in per-year subdirectories of /var/log/httpd/archive.
  file {
    '/etc/logrotate.d/httpd':
      source => "puppet:///modules/apache/logrotate.archive.el$lsbmajdistrelease";
    '/var/log/httpd/archive':
      ensure => directory;
  }

}
