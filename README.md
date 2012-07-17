1. Use bundler to install the deployment Gemfile

```bash
$ bundle install
```

```bash
$ vagrant basebox build 'scientificlinux-6.2-x86_64-netboot'
$ vagrant basebox export 'scientificlinux-6.2-x86_64-netboot'
$ vagrant box add 'sl62-x86_64' scientificlinux-6.2-x86_64-netboot.box
```
