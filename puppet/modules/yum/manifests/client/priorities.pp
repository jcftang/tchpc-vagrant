class yum::client::priorities inherits yum::client {

  # Install the priorities plugin using the appropriate package name for EL5
  # (from CentOS Extras) or EL6 and up (from the RHEL Optional channel)
  case $lsbmajdistrelease {
    5:       { package { 'yum-priorities': } }
    default: { package { 'yum-plugin-priorities': } }
  }

}
