class apache::userdir inherits apache {

  fragment { 'userdir': source => 'puppet:///modules/apache/fragments/userdir.conf' }

}
