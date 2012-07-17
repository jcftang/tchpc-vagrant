class s_user inherits user {

  # IDs of people to have Unix accounts
  $people = []

  # Instantiate user accounts for people
  realize(User::Human[$people])

  # Add hydradam group
  group { 'hydradam': gid => '504' }

  # Add hydradam devs to hydradam group
  User::Human[$people] { groups +> ['hydradam'] }

  # Add hydra user
  user { 'hydra':
    comment    => "$hostname hydra",
    uid        => '503',
    gid        => '503',
    groups     => ['users','hydradam'],
    shell      => '/bin/bash',
    home       => '/home/hydra',
    managehome => true,
  }

  # Ensure that ~hydra is a+rx
  file { "$user::home_prefix/hydra":
    ensure  => directory,
    mode    => '0755',
    owner   => 'hydra',
    group   => 'hydradam',
    require => User['hydra'],
  }

  # Add hydra to the rvm group, if RVM is installed
  if $rvm_installed == "true" { rvm::system_user { 'hydra': } }

  exec { 'add-hydra-to-tomcat-group':
    user    => 'root',
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    command => '/usr/sbin/usermod -a -G tomcat hydra',
    onlyif  => [ '/usr/bin/groups hydra | ( ! /bin/grep -q tomcat )',
                  "/bin/rpm -q tomcat6 > /dev/null 2>&1" ],
    require => User['hydra'],
  }


}
