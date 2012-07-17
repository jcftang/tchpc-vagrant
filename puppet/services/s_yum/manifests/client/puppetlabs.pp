class s_yum::client::puppetlabs inherits s_yum::client {

  # Partial Puppet Labs mirror (Key: http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs)
  yum::repo_with_key {
    "puppetlabs-el$lsbmajdistrelease":
      baseurl      => "$yum_mirror_url/puppetlabs-el$lsbmajdistrelease",
      descr        => "Puppet Labs Packages",
      gpgkeysource => 'puppet:///modules/s_yum/keys/RPM-GPG-KEY-puppetlabs',
      priority     => '80';
    "puppetlabs-deps-el$lsbmajdistrelease":
      baseurl      => "$yum_mirror_url/puppetlabs-deps-el$lsbmajdistrelease",
      descr        => "Puppet Labs Package Dependencies",
      gpgkeysource => 'puppet:///modules/s_yum/keys/RPM-GPG-KEY-puppetlabs',
      priority     => '80';
  }

}
