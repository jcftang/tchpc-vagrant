# -*- mode: ruby -*-
# vi: set ft=ruby :

node 'cports.localhost' inherits default {
	if ! defined(Package['gcc-gfortran']) { package { 'gcc-gfortran': ensure => installed } }
	if ! defined(Package['environment-modules']) { package { 'environment-modules': ensure => installed } }
	if ! defined(Package['texinfo']) { package { 'texinfo': ensure => installed } }
	if ! defined(Package['patch']) { package { 'patch': ensure => installed } }
}
