## Installation (of VirtualBox VM)

Prerequisites:

  - Oracle VirtualBox
  - Ruby (run time and development headers)
    - rubygems
    - bundler gem

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
