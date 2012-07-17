include tomcat

tomcat::webapp { 'webapp_name':
  docbase => '/path/to/exploded/war',
  path    => '/webapp',
}
