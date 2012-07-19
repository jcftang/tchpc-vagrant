# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |global_config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  global_config.vm.define(:test) do |config|
  # Every Vagrant virtual environment requires a box to build off of.

    config.vm.box = "sl62-x86_64"
    config.vm.network :hostonly, "10.0.1.100"
    config.vm.host_name = "test.localhost"

    config.vm.provision :puppet do |puppet|
      puppet.manifest_file = "site.pp"
      puppet.manifests_path = 'puppet/manifests'
      puppet.module_path = ['puppet/modules', 'puppet/services']
    end

    config.vm.customize [
      "modifyvm", :id,
      "--name", "TEST VM",
      "--memory", "2048"
    ]
  end

  global_config.vm.define(:web) do |config|
  # Every Vagrant virtual environment requires a box to build off of.

    config.vm.box = "sl62-x86_64"
    config.vm.network :hostonly, "10.0.1.101"
    config.vm.host_name = "web.localhost"

    config.vm.provision :puppet do |puppet|
      puppet.manifest_file = "site.pp"
      puppet.manifests_path = 'puppet/manifests'
      puppet.module_path = ['puppet/modules', 'puppet/services']
    end

    config.vm.customize [
      "modifyvm", :id,
      "--name", "WEB VM",
      "--memory", "2048"
    ]
  end

  global_config.vm.define(:cports) do |config|
  # Every Vagrant virtual environment requires a box to build off of.

    config.vm.box = "sl62-x86_64"
    config.vm.network :hostonly, "10.0.1.102"
    config.vm.host_name = "cports.localhost"

    config.vm.provision :puppet do |puppet|
      puppet.manifest_file = "site.pp"
      puppet.manifests_path = 'puppet/manifests'
      puppet.module_path = ['puppet/modules', 'puppet/services']
    end

    config.vm.customize [
      "modifyvm", :id,
      "--name", "CPORTS VM",
      "--memory", "2048"
    ]
  end

end
