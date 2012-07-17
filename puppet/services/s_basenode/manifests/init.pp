class s_basenode ($root_mail='root@localhost') {

  include git,
          iptables,
          s_user,
          s_yum::client,
          s_yum::client::puppetlabs

        package { ['file', 'expect']: ensure => present }
}
