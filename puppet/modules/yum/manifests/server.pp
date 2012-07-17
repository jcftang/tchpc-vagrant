class yum::server inherits yum {

  # Filesystem locations
  $repodir = "${apache::vardir}/repo"

  package { 'createrepo': }

  # Create directory to hold repositories
  file { "${apache::vardir}/repo": ensure => directory }

  # Configure Apache to serve it
  apache::fragment { 'yumrepo': content => template('yum/yumrepo.conf') }

}
