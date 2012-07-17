class s_yum::client::rpmforge inherits s_yum::client {

  # Partial RPMforge mirror (Key: http://dag.wieers.com/packages/RPM-GPG-KEY.dag.txt)
  yum::repo_with_key { 'rpmforge':
    baseurl      => "$yum_mirror_url/rpmforge-el$lsbmajdistrelease-$architecture",
    descr        => "RPMforge Packages for Enterprise Linux $lsbmajdistrelease",
    gpgkeysource => 'puppet:///modules/s_yum/keys/RPM-GPG-KEY-dag',
    priority     => '80',
  }

}
