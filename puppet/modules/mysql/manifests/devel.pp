class mysql::devel inherits mysql {

  if ! defined (Package['mysql-devel']) {
    package { 'mysql-devel': }
  }

}
