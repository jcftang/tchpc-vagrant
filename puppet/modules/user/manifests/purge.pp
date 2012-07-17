class user::purge inherits user {

  # Purge unmanaged users with UIDs of 500 or above. This should ensure that
  # all human user accounts are purged when their owners are removed from our
  # Puppet manifests. All system users should be created with UIDs of 499 or
  # below.

  resources { user:
    purge              => true,
    unless_system_user => '499',
  }

  # Many OS distributions like to create unprivileged system users with high
  # UIDs. Exempt them from purging, but leave them unmanaged, as they would be
  # if they had low UIDs like other system users.

  user { 'nfsnobody': ensure => undef }

}
