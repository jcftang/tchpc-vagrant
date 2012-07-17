class java6 inherits defaults {

  # Filesystem locations
  $jardir = '/usr/share/java'

  # Install Sun's Java 6 JVM, with an alias of 'java6' for defining
  # dependencies, and the Unlimited Strength Jurisdiction Policy Files
  # for that JVM.
  package {
    'java-1.6.0-sun': alias => 'java6';
    'java-1.6.0-sun-jce-unlimited':
  }

}
