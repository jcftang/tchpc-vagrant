class s_yum::client::redhat inherits s_yum::client {

  # Check for required variables
  if ! $rhn_mirror_url { fail('Missing required variable $rhn_mirror_url') }

  # The URL of the base mrepo mirror for this OS and architecture
  $mirror_url_prefix = "$rhn_mirror_url/rhel$lsbmajdistrelease-$architecture"

  yumrepo {
    # These channels are available for all versions we support
    'rhel':
      baseurl  => "$mirror_url_prefix/RPMS.updates",
      descr    => "Red Hat Enterprise Linux $lsbmajdistrelease",
      gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release',
      priority => '50';
    'rhel-supplementary':
      baseurl  => "$mirror_url_prefix/RPMS.supplementary",
      descr    => "Red Hat Enterprise Linux $lsbmajdistrelease Supplementary",
      gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release',
      priority => '50';
  }

  case $lsbmajdistrelease {

    5: {
      # Add the virtualization channel
      yumrepo { 'rhel-vt':
        baseurl  => "$mirror_url_prefix/RPMS.vt",
        descr    => "Red Hat Enterprise Linux $lsbmajdistrelease Virtualization",
        gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release',
        priority => '50';
      }

      # Exclude old, buggy httpd packages which break mod_jk (see RHEL5 BZ#493592)
      Yumrepo['rhel'] {
        exclude => 'httpd-2.2.3-?.el5 httpd-2.2.3-11.el5* httpd-2.2.3-22.el5*',
      }

      # Exclude this package to allow continued use of Java 1.5 (see RHEL5 BZ#605657)
      Yumrepo['rhel-supplementary'] {
        exclude => 'java-1.5.0-sun-uninstall',
      }
    }

    6: {
      yumrepo {
        # Add the optional channel
        'rhel-optional':
          baseurl  => "$mirror_url_prefix/RPMS.optional",
          descr    => "Red Hat Enterprise Linux $lsbmajdistrelease Optional",
          gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release',
          # Since the yum-plugin-priorities package comes from the optional
          # channel, this repository must be configured before we attempt to
          # install it
          before   => Package['yum-plugin-priorities'],
          priority => '50';

        # Add the HA channel (from which Cobbler requires fence-agents)
        'rhel-ha':
          baseurl  => "$mirror_url_prefix/RPMS.ha",
          descr    => "Red Hat Enterprise Linux $lsbmajdistrelease High Availability",
          gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release',
          priority => '50';
      }
    }

  }

}
