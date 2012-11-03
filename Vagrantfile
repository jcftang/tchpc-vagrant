# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'vagrant-ansible'

Vagrant::Config.run do |global_config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  global_config.vm.define(:precise64) do |config|
  # Every Vagrant virtual environment requires a box to build off of.

    config.vm.box = "precise64"
    config.vm.box_url = "http://thammuz.tchpc.tcd.ie/mirrors/boxes/precise64.box"

    config.vm.network :hostonly, "10.0.1.104"
    config.vm.host_name = "precise64.localhost"

    config.vm.provision :ansible do |ansible|
      # point Vagrant at the location of your playbook you want to run
      ansible.playbook = "tchpc-playbooks/proxy.yml"

      # the Vagrant VM will be put in this host group change this should
      # match the host group in your playbook you want to test
      ansible.hosts = "web-servers"
    end

    config.vm.customize [
      "modifyvm", :id,
      "--name", "Precise64 VM",
      "--memory", "2048"
    ]
  end

end
