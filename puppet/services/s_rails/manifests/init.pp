class s_rails inherits defaults {

  include mysql::server,
          mysql::devel,
          s_ruby::rvm,
          s_ruby::rvm::passenger

  # Environment-specific packages and port access restrictions:
  # Install sqlite only on dev, test, and demo systems ...


  package { ['sqlite','sqlite-devel']: }


  include s_apache::global

  # If the variable $railsenv is set, create an apache fragment
  # setting RailsEnv to its value.  Otherwise, set RailsEnv to
  # production ...

  if ! $railsenv { $railsenv = 'production' }

  apache::fragment {'z-RailsEnv':
      content => "RailsEnv $railsenv\n";
  }

  # on test systems, open ports 3000 - 3009 globally; on dev and
  # demo systems, restrict to SU admin nets; on prod, do not open
  # access to these ports ...

  iptables::open_port { 'rails-dev':
    networks => ['0/0'],
    number   => '3000:3009',
    comment  => 'Allow access to rails-dev ports from everywhere',
  }

}
