class s_nokogiri::dependencies inherits s_nokogiri {

  # This class installs the dependencies of the nokogiri gem
  # but not the gem itself.

  if ! defined (Package['gcc'])            { package { 'gcc': } }
  if ! defined (Package['gcc-c++'])        { package { 'gcc-c++': } }
  if ! defined (Package['libxml2'])        { package { 'libxml2': } }
  if ! defined (Package['libxml2-devel'])  { package { 'libxml2-devel': } }
  if ! defined (Package['libxslt'])        { package { 'libxslt': } }
  if ! defined (Package['libxslt-devel'])  { package { 'libxslt-devel': } }

}
