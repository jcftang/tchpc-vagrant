#!/bin/sh

usage() {
	echo "usage: $0 <package-name>"
}

if [ $# -ne 1 ]; then
	usage
	exit 1
fi

echo "if ! defined(Package['$1']) { package { '$1': ensure => installed } }"

