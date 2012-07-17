node 'sl-tchpc.localhost' {

   $rvm_system_ruby = 'ruby-1.9.3-p194'
   $passenger_version = '3.0.12'
   $rvm_default_ruby = $rvm_system_ruby
   $railsenv = 'development'

  package { 'perl-XML-Twig': ensure => present }
  package { 'perl-Image-ExifTool': ensure => present }

   rvm::system_user { vagrant: ; jsmith: ; }
   include s_basenode,
#          s_apache,
          s_nokogiri::dependencies,
          rvm,
#          s_rails,
          mysql::server,
          s_ssh

  class { 'java':
    distribution => 'java-1.6.0-openjdk',
  }

#        class { 'rvm::passenger::gem': 
#                  version => $passenger_version,
#                  ruby_version => $rvm_system_ruby }
#
        # include s_ruby::rvm
}
