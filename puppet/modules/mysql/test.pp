include mysql::server
mysql::server::database { 'testdb':
  charset => 'utf8',
  collate => 'utf8_general_ci',
}
