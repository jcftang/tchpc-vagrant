class s_yum::client::puppetlabs_27 inherits s_yum::client {

  # Puppet Labs mirror (Key: http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs)
  yum::repo_with_key {
    "puppetlabs-2.7-el$lsbmajdistrelease":
      baseurl      => "$yum_mirror_url/puppetlabs-2.7-el$lsbmajdistrelease",
      descr        => "Puppet Labs Packages (2.7)",
      gpgkeysource => 'puppet:///modules/s_yum/keys/RPM-GPG-KEY-puppetlabs',
      priority     => '79';
    "puppetlabs-deps-el$lsbmajdistrelease":
      baseurl      => "$yum_mirror_url/puppetlabs-deps-el$lsbmajdistrelease",
      descr        => "Puppet Labs Package Dependencies",
      gpgkeysource => 'puppet:///modules/s_yum/keys/RPM-GPG-KEY-puppetlabs',
      priority     => '79';
  }

}
