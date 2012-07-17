class apache::mod_perl inherits apache {

  package { 'mod_perl':
    ensure => present,
  }
  
}
