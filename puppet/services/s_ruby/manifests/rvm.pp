class s_ruby::rvm inherits s_ruby {

  # Install RVM into the system-wide location
  include rvm::system

  if $rvm_installed == "true" {

    # Install the rvm_system_ruby
    rvm_system_ruby { "$rvm_system_ruby":
      ensure      => 'present',
      default_use => 'true',
    }

    # Install the bundler gem
    rvm_gem { 'bundler':
      ruby_version => "$rvm_system_ruby@global",
      require      => Rvm_system_ruby["$rvm_system_ruby"],
      ensure       => 'latest',
    }

    # Install additional rubies if specified
    if $rvm_additional_rubies {
      rvm_system_ruby { $rvm_additional_rubies:
        ensure      => 'present',
        default_use => 'false',
      }
    }

  }

}
