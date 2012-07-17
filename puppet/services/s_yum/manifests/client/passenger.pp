class s_yum::client::passenger inherits s_yum::client {

  # Stealthy Monkeys has a special signing key with a smaller key size to
  # accommodate RHEL5; all other distros use the standard signing key
  $gpgkeyname = $lsbmajdistrelease ? {
    5       => 'RPM-GPG-KEY-stealthymonkeys.rhel5',
    default => 'RPM-GPG-KEY-stealthymonkeys',
  }

  # Passenger repository mirror (Key: http://passenger.stealthymonkeys.com/RPM-GPG-KEY-stealthymonkeys.asc)
  yum::repo_with_key { 'passenger':
    baseurl      => "$yum_mirror_url/passenger-el$lsbmajdistrelease-$architecture",
    descr        => "Passenger Binaries for Enterprise Linux $lsbmajdistrelease",
    gpgkeysource => "puppet:///modules/s_yum/keys/$gpgkeyname",
    priority     => '80',
  }

}
