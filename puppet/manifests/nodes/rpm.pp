# -*- mode: ruby -*-
# vi: set ft=ruby :

node 'rpm.localhost' inherits default {
	if ! defined(Package['gcc-gfortran']) { package { 'gcc-gfortran': ensure => installed } }
	if ! defined(Package['rpm-build']) { package { 'rpm-build': ensure => installed } }
	if ! defined(Package['rpmdevtools']) { package { 'rpmdevtools': ensure => installed } }
	if ! defined(Package['rpmlint']) { package { 'rpmlint': ensure => installed } }
	if ! defined(Package['texinfo']) { package { 'texinfo': ensure => installed } }
	if ! defined(Package['patch']) { package { 'patch': ensure => installed } }
	if ! defined(Package['libtool']) { package { 'libtool': ensure => installed } }
	if ! defined(Package['automake']) { package { 'automake': ensure => installed } }
	if ! defined(Package['autoconf']) { package { 'autoconf': ensure => installed } }
	if ! defined(Package['bison']) { package { 'bison': ensure => installed } }
	if ! defined(Package['flex']) { package { 'flex': ensure => installed } }

        include avahi
}
