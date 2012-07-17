class apache::highload inherits apache::minimal {

  Fragment['mpm'] {
    source => 'puppet:///modules/apache/fragments/mpm-highload.conf',
  }

}
