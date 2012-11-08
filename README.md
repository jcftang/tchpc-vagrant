## README

This is the top-level TCHPC-VAGRANT repo which contains a development, testing and
integration environment.

There are components in this system and it's submodules which are
considered to be private and non-redistributable. If you are are not sure
of the which modules are redistributable please contact the DRI-STRAND-3
team.

### IMPORTANT/WARNING

The documentation is not accurate, please look at the vagrantfile for
more up to date information!!!!

This development scaffold has not been tested on windows!!!, The ansible 
configuration are currently targeted at the TCHPC network. If you are outside
of the TCHPC network please look at _Vagrantfile_ and
comment out the appropriate line otherwise the proxies will be set and
it *will not* work for you.

## Notes

This is a set of base configurations for the TCHPC site for vagrant. A
number of defintions have been created

### Standard SL boxes with a 10gb disk

* scientificlinux-6.3-i386-netboot.box
* scientificlinux-6.3-x86_64-netboot.box

### Devops SL boxes with 15gb root disk and 5gb free space

* scientificlinux-6.3-i386-netboot-devops.box
* scientificlinux-6.3-x86_64-netboot-devops.box

## Requirements

Prerequisites:

  - [Oracle VirtualBox](https://www.virtualbox.org/)
    - requires kernel headers (yum install kernel-devel)
    - requires a c compiler (yum install gcc)
  - [Ruby](http://www.ruby-lang.org/) (run time and development headers)
    - rubygems (yum install ruby ruby-devel rubygems)
    - bundler gem (gem install bundler)
    - vagrant gem (gem install vagrant)
  - [Ansible](http://ansible.cc/) (This is the provisioning layer)

## Installing Ansible

As ansible may not be available on your packaging system, please refer to
http://ansible.cc/docs/gettingstarted.html.

If you are on OSX (with macports installed)

	$ sudo port install py-yaml py-paramiko
	$ git clone https://github.com/ansible/ansible.git
	$ cd ansible
	$ make

Once the scripts and docs are all generated, place something like this into your
*.bash_profile* or *.bashrc* file

	source $HOME/develop/ansible/hacking/env-setup
	export ANSIBLE_HOSTS=$HOME/.ansible_hosts

## Installation/Configuration of tchpc-vagrant repo

Clone the git repository

Use bundler to install the deployment Gemfile

	$ bundle install

Create a basebox and add it to vagrant (if you have a basebox already then
you do not need to run the build and export steps)

	$ vagrant basebox build 'scientificlinux-6.3-x86_64-netboot'
	$ vagrant basebox export 'scientificlinux-6.3-x86_64-netboot'
	$ vagrant box add 'sl63-x86_64' scientificlinux-6.3-x86_64-netboot.box

If you already have a basebox created you can skip the build and export
steps.

Startup the virtual machine

	$ vagrant up

Login to the virtual machine

	$ vagrant ssh
