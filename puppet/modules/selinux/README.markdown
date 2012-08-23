# SELinux Puppet Module

James Fryman <james@frymanet.com>

Modified further for the New Zealand National eScience Infrastructure by:

Aaron Hicks <aaron.hicks@nesi.org.nz>

# Description

This class manages SELinux on RHEL and CentOS based systems.

Parameters:

- $mode (enforced|permissive|disabled) - sets the operating state for SELinux.

# Actions:
  This module will configure SELinux and/or deploy SELinux based modules to running
  system.

# Requires:
  - Class[stdlib]. This is Puppet Labs standard library to include additional methods for use within Puppet. [https://github.com/puppetlabs/puppetlabs-stdlib]

# Sample Usage:
<pre>  
include selinux
</pre>
