class s_yum::client::jpackage inherits s_yum::client {

  # Partial JPackage mirror (Key: http://www.jpackage.org/jpackage.asc)
  yum::repo_with_key { 'jpackage':
    baseurl      => "$yum_mirror_url/jpackage-5.0",
    descr        => 'JPackage Project 5.0',
    gpgkeysource => 'puppet:///modules/s_yum/keys/RPM-GPG-KEY-jpackage',
    priority     => '40',
    exclude      => 'tomcat5*',
  }

}
