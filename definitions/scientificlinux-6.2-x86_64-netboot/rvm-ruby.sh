curl https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer | bash -s stable

source /etc/profile.d/rvm.sh

rvm --force reinstall ruby-1.9.3

rvm --default use 1.9.3
