## Notes

This is a set of base configurations for the TCHPC site for vagrant. A
number of defintions have been created

### Standard SL boxes with a 10gb disk

* scientificlinux-6.2-i386-netboot.box
* scientificlinux-6.2-x86_64-netboot.box

### Devops SL boxes with 15gb root disk and 5gb free space

* scientificlinux-6.2-i386-netboot-devops.box
* scientificlinux-6.2-x86_64-netboot-devops.box

## Installation (of VirtualBox VM)

Prerequisites:

  - Oracle VirtualBox
    - requires kernel headers (yum install kernel-devel)
    - requires a c compiler (yum install gcc)
  - Ruby (run time and development headers)
    - rubygems (yum install ruby ruby-devel rubygems)
    - bundler gem (gem install bundler)
    - vagrant gem (gem install vagrant)

1. Clone the git repository

1. Use bundler to install the deployment Gemfile

```bash
$ bundle install
```

2. Create a basebox and add it to vagrant

```bash
$ vagrant basebox build 'scientificlinux-6.2-x86_64-netboot'
$ vagrant basebox export 'scientificlinux-6.2-x86_64-netboot'
$ vagrant box add 'sl62-x86_64' scientificlinux-6.2-x86_64-netboot.box
```

If you already have a basebox created you can skip the build and export
steps.

3. Startup the virtual machine

```bash
$ vagrant up
```

4. Login to the virtual machine

```bash
$ vagrant ssh
```
