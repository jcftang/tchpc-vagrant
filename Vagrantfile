# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |global_config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  global_config.vm.define(:sl_tchpc_test) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "sl62-x86_64"

    config.vm.network :hostonly, "33.33.33.10"
    config.vm.host_name = "sl-tchpc.localhost"

#    config.vm.provision :puppet do |puppet|
#      puppet.manifest_file = "nodes/sl-tchpc.pp"
#      puppet.manifests_path = 'puppet/manifests'
#      puppet.module_path = ['puppet/modules', 'puppet/services']
#    end

    config.vm.customize [
      "modifyvm", :id,
      "--name", "TCHPC VM",
      "--memory", "2048"
    ]
  end
end