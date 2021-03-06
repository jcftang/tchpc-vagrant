# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |global_config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  global_config.vm.define(:test) do |config|
  # Every Vagrant virtual environment requires a box to build off of.

    config.vm.box = "sl63-x86_64"
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

    config.vm.box = "sl63-x86_64"
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

    config.vm.box = "sl63-x86_64"
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

  global_config.vm.define(:rpm) do |config|
  # Every Vagrant virtual environment requires a box to build off of.

    config.vm.box = "sl63-x86_64"
    config.vm.box_url = "http://thammuz.tchpc.tcd.ie/mirrors/boxes/scientificlinux-6.3-x86_64-netboot-devops.box"

    config.vm.network :hostonly, "10.0.1.103"
    config.vm.host_name = "rpm.localhost"

    config.vm.provision :puppet do |puppet|
      puppet.manifest_file = "site.pp"
      puppet.manifests_path = 'puppet/manifests'
      puppet.module_path = ['puppet/modules', 'puppet/services']
    end

    config.vm.customize [
      "modifyvm", :id,
      "--name", "RPM Build VM",
      "--memory", "2048"
    ]
  end

  global_config.vm.define(:precise64) do |config|
  # Every Vagrant virtual environment requires a box to build off of.

    config.vm.box = "precise64"
    config.vm.box_url = "http://thammuz.tchpc.tcd.ie/mirrors/boxes/precise64.box"

    config.vm.network :hostonly, "10.0.1.104"
    config.vm.host_name = "precise64.localhost"

    config.vm.provision :puppet do |puppet|
      puppet.manifest_file = "site.pp"
      puppet.manifests_path = 'puppet/manifests'
      puppet.module_path = ['puppet/modules', 'puppet/services']
      #puppet.options = "--verbose --debug"
    end

    config.vm.customize [
      "modifyvm", :id,
      "--name", "Precise64 VM",
      "--memory", "2048"
    ]
  end

  global_config.vm.define(:rails) do |config|
    # Every Vagrant virtual environment requires a box to build off of.

    config.vm.box = "sl63-x86_64"
    config.vm.network :hostonly, "10.0.1.100"
    config.vm.host_name = "rails.localhost"
    config.vm.forward_port 80, 4568

    config.vm.provision :puppet do |puppet|
      puppet.manifest_file = "site.pp"
      puppet.manifests_path = 'puppet/manifests'
      puppet.module_path = ['puppet/modules', 'puppet/services']
    end

    config.vm.customize [
                         "modifyvm", :id,
                         "--name", "rails",
                         "--memory", "2048"
                        ]
  end

end
