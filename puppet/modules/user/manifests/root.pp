class user::root inherits user {

  # Filesystem locations
  $home = '/root'

  # Set a more restrictive default mode to protect files in home directory
  File { mode  => '600' }

  # Setting the root user's comment makes root mail easier to categorize at a
  # glance. Also set the uid so that, if something goes horribly wrong, Puppet
  # doesn't create an unprivileged "root" user.
  user { 'root':
    uid     => '0',
    comment => "$hostname root",
  }

  # Realize ksuers' regular accounts, as well
  if $ksuers { realize(User::Human[$ksuers]) }

  # Clear out these unwanted files, but leave the "mandatory" rootfiles
  # package installed since it may provide something useful in the future
  file { ["$home/.cshrc","$home/.tcshrc","$home/.bash_logout"]:
    ensure => absent,
  }

  file {
    $home:
      ensure => directory;

    # Install root dotfiles
    "$home/.bashrc":
      source => 'puppet:///modules/user/root/.bashrc';
    "$home/.bash_profile":
      source => 'puppet:///modules/user/root/.bash_profile';
    "$home/.emacs":
      source => 'puppet:///modules/user/root/.emacs';

    # Our emacs configuration stores backups here, for safety
    "$home/.emacs.d":
      ensure => directory;
    "$home/.emacs.d/backups":
      ensure => directory;
  }

}
