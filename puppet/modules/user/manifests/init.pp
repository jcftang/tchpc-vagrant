class user inherits defaults {

  # Set a default home_prefix for *non* user::human users.  
  if ! $home_prefix { $home_prefix = '/home' }
  
  $human_primary_gid = 'users'

  # Add a default $home_prefix to Human, 
  # and make sure $home gets that value, not the value defined above.
  define human ($fullname, $uid, $groups='', $home_prefix = '/home') {

    $home = "$home_prefix/$name"

    user { $name:
      ensure     => present,
      comment    => $fullname,
      uid        => $uid,
      gid        => $user::human_primary_gid,
      home       => $home,
      managehome => true,
      require    => Exec['etc-skel-configured'],
    }

    if $groups { User[$name] { groups => $groups } }

    # Allow sysadmins to deliver their preferred dotfiles via Puppet by
    # defining classes of the form s_user::home::$name in the s_users module.
    if defined("s_user::home::$name") {
      include "s_user::home::$name"
      User[$name] { before => Class["s_user::home::$name"] }
    }

    # Inform the postfix module that this is a human user via a defined
    # resource. This allows system mail to be handled differently from
    # user-generated mail. The handling of human users may vary according to
    # the type of mail server; these details are internal to the postfix
    # module.
    postfix::human { $name: }

  }

}
