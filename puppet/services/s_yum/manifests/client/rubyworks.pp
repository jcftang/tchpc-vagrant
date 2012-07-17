class s_yum::client::rubyworks inherits s_yum::client {

  # RubyWorks mirror (Key: http://rubyworks.rubyforge.org/RubyWorks.GPG.key)
  yum::repo_with_key { 'rubyworks':
    baseurl      => "$yum_mirror_url/rubyworks-el$lsbmajdistrelease-$architecture",
    descr        => "RubyWorks Production Stack for Enterprise Linux $lsbmajdistrelease",
    gpgkeysource => 'puppet:///modules/s_yum/keys/RPM-GPG-KEY-rubyworks',
    priority     => '40',
  }

}
