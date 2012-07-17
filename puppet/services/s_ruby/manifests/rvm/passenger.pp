class s_ruby::rvm::passenger inherits defaults {

  # Ensure we've got httpd installed, but don't install it because
  # we want to encourage the use of one the s_apache puppet classes

  if ! Package['httpd'] { fail('s_ruby::rvm::passenger requires package httpd') }
  
  # Set default values for passenger specific attributes

  if ! $passenger_version            { $passenger_version = '3.0.7' }
  if ! $passenger_ruby_version       { $passenger_ruby_version = $rvm_system_ruby }
  if ! $passenger_mininstances       { $passenger_min_instances = '3'}
  if ! $passenger_maxinstancesperapp { $passenger_maxinstancesperapp = '0' }
  if ! $passenger_maxpoolsize        { $passenger_maxpoolsize = '30' }
  if ! $passenger_spawnmethod        { $passenger_spawnmethod = 'smart-lv2' }

  # Use the rvm::passenger::apache class to do the installation; wrap the
  # block in an "rvm_installed" test to get around the "no default
  # provider" run-time error

if $rvm_installed == "true" {

    class { 'rvm::passenger::apache':
      version            => $passenger_version,
      ruby_version       => $passenger_ruby_version,
      mininstances       => $passenger_min_instances,
      maxinstancesperapp => $passenger_maxinstancesperapp,
      maxpoolsize        => $passenger_maxpoolsize,
      spawnmethod        => $passenger_spawnmethod,
    }

  }
}

Class['s_ruby::rvm::passenger'] -> Class['s_ruby::rvm']
