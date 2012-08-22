#
# avahi module
#
# Copyright 2008, Puzzle ITC
# Marcel Härry haerry+puppet(at)puzzle.ch
# Simon Josi josi+puppet(at)puzzle.ch
#
# Copyright 2012, Jimmy Tang
# Jimmy Tang jcftang@gmail.com
#
# This program is free software; you can redistribute 
# it and/or modify it under the terms of the GNU 
# General Public License version 3 as published by 
# the Free Software Foundation.
#
class avahi {
  case $operatingsystem {
    centos: { include avahi::centos }
    scientific: { include avahi::scientific }
    default: { include avahi::base }
  }
}
