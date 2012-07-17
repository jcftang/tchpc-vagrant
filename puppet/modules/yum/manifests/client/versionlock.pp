class yum::client::versionlock inherits yum::client {

  # Install the versionlock plugin using the appropriate package name
  # for EL5 (from CentOS Extras) or EL 6 and up (from the RHEL
  # Optional channel)
  case $lsbmajdistrelease {
    5:       { package { 'yum-versionlock': } }
    default: { package { 'yum-plugin-versionlock': } }
  }
  
}
