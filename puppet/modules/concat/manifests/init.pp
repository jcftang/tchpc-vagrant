# These two definitions can be used to cobble together a single, monolithic
# configuration file from config fragments dropped into a conf.d directory.
# They should only be necessary for services which can't read whole config
# directories themselves.
#
# Use the $glob parameter to control what filenames are considered config
# fragments, and the $prio parameter to control fragment ordering. (Using
# $prios from 000 to 999 works best, since the default is 500.)

define concat::file (
  $dir,
  $glob  = '*',
  $owner = '',
  $group = '',
  $mode  = ''
) {

  # Making this file resource notify its own rebuild exec allows the file to
  # be built properly in the case where the file is new, but none of its
  # fragments are new (and therefore nothing else triggers the rebuild). It's
  # also a little safer, since creating the file first blocks some symlink
  # attacks against the rebuild exec. (This relationship causes a rebuild
  # whenever the file's ownership or permissions change, but that seems like
  # a reasonable price to pay.)

  file { $name:
    ensure => present,
    notify => Exec["rebuild-file-$name"],
  }

  if $owner { File[$name] { owner => $owner } }
  if $group { File[$name] { group => $group } }
  if $mode  { File[$name] { mode  => $mode  } }

  # Check whether $dir's file resource is already defined before declaring it.
  # (This allows multiple concat::files to use the same directory with
  # different globs.) Also declare a noop exec resource which is used just to
  # propagate notifications from directory purges and concat::fragments.

  if !defined(File[$dir]) {
    file { $dir:
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '700',
      recurse => true,
      purge   => true,
      force   => true,
      source  => 'puppet:///modules/concat/empty',
      ignore  => ['.gitignore'],
    }
    exec { "rebuild-dir-$dir":
      user        => 'root',
      path        => '/bin:/usr/bin:/sbin:/usr/sbin',
      cwd         => $dir,
      command     => 'true',
      refreshonly => true,
      subscribe   => File[$dir],
    }
  }

  exec { "rebuild-file-$name":
    user        => 'root',
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    cwd         => $dir,
    command     => "bash -c 'umask 077 && shopt -s nullglob && cat $glob < /dev/null > $name'",
    refreshonly => true,
    subscribe   => Exec["rebuild-dir-$dir"],
  }

}

# Note that you'll want to set exactly one of 'source' and 'content' when
# using this definition.

define concat::fragment (
  $dir,
  $ensure   = 'present',
  $filename = $name,
  $prio     = '500',
  $content  = '',
  $source   = ''
) {

  # To control the fragment's filename separately from $name, set $filename
  $path = "$dir/$prio-$filename"

  # Set restrictive permissions on fragments to be safe -- they should never
  # be consulted directly anyway, except when root is debugging Puppet itself
  file { $path:
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '600',
    notify  => Exec["rebuild-dir-$dir"],
  }

  if $source     { File[$path] { source  => $source  } }
  elsif $content { File[$path] { content => $content } }

}
