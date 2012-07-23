class rvm::dependencies {
  case $::operatingsystem {
    Ubuntu,Debian: { require rvm::dependencies::ubuntu }
    Scientific,CentOS,RedHat: { require rvm::dependencies::centos }
    OracleLinux,RedHat: { require rvm::dependencies::oraclelinux }
  }
}
