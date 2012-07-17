class yum::client::rhn inherits yum::client {

  package { ['yum-rhn-plugin','rhn-setup']: }

  # rhn-setup will pull in rhnsd, which we don't want running
  service { 'rhnsd':
    enable  => false,
    ensure  => stopped,
    require => Package['rhn-setup'],
  }

  # Once the above packages have been installed, an administrator can
  # register the system with RHN using the following command:
  #
  #   rhnreg_ks --username <u> --password <p> --norhnsd
  #
  # Since the RHN password is required, this step is not automated with
  # Puppet.

}
