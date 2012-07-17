class apache::minimal::nolog inherits apache::minimal {

  Fragment['log'] { ensure => absent }

}
