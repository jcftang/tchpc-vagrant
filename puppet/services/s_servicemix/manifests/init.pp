class s_servicemix {

  define download_file(
        $from="",
        $cwd="") {                                                                                         

    exec { $name:                                                                                                                     
        command  => "curl -o ${cwd}/${name} ${from}",                                                         
        cwd      => $cwd,
        path     => "/sbin:/bin:/usr/sbin:/usr/bin",
        creates  => "${cwd}/${name}",                                                              
    }

    file { "${cwd}/${name}":
      mode    => 644,
      require => Exec["${name}"]
    }

    if $require {
      Exec[$name] {
        require +> $require
      }
    }
  }

  define extract_file(
    $destdir="",
    $creates="",
    $user="",
    $to
  ) {
    exec { $name:
      command => "tar -xvz -C ${destdir} -f ${name}",
      path    => "/usr/bin:/bin",
      user    => "${user}",
      creates => "${destdir}/${creates}",                                                              
    }

    file { "${destdir}/${creates}":
      mode    => 775,
      require => Exec["${name}"]
    }

    exec { "/bin/mv ${destdir}/${creates} ${to}":
      require => File["${destdir}/${creates}"],
      creates => "${to}"
    }

    file { "${to}":
      require => Exec["/bin/mv ${destdir}/${creates} ${to}"]
    }

  }
  


  download_file { "apache-servicemix-fuse.tar.gz":
    from => "http://repo.fusesource.com/nexus/content/repositories/releases/org/apache/servicemix/apache-servicemix/4.4.1-fuse-02-05/apache-servicemix-4.4.1-fuse-02-05.tar.gz",
    cwd  => "/tmp"
  }

  extract_file { "/tmp/apache-servicemix-fuse.tar.gz":
    destdir => "/var/www/hydradam",
    creates => "apache-servicemix-4.4.1-fuse-02-05",
    to      => '/var/www/hydradam/servicemix',
    user    => 'vagrant',
    require => [File["/tmp/apache-servicemix-fuse.tar.gz"], File['/var/www/hydradam']]
  }

  file {
    "/etc/init.d/servicemix":
      mode    => "0755",
      content => '#!/bin/sh 
### BEGIN INIT INFO 
# Provides: servicemix 
# Required-Start:
# Required-Stop:
# Default-Start:  3 4 5 
# Default-Stop:   1 
# Short-Description: Apache ServiceMix ESB 
### END INIT INFO 

# Source function library.
. /etc/init.d/functions

# /etc/init.d/servicemix: start and stop the Apache ServiceMix ESB 
SMX_HOME=/var/www/hydradam/servicemix
SMX_USER=vagrant 

start() {
   echo -n "Starting Apache ServiceMix ESB" 
   /bin/su -p -s /bin/sh $SMX_USER -c $SMX_HOME/bin/start
}

case "$1" in 
    start) 
      start
    ;; 
    stop) 
       echo -n "Stopping Apache ServiceMix ESB"

       $SMX_HOME/bin/stop
        
    ;; 
    restart) 
        $0 stop 
        $0 start 
    ;; 
    *) 
       echo -n  "Usage: /etc/init.d/servicemix {start|stop|restart}" 
       exit 1 
esac 
exit 0

'
  }

  exec { "start servicemix service":
    command => "/usr/bin/sudo /sbin/chkconfig servicemix on; /usr/bin/sudo /sbin/service servicemix start", 
    require => [File['/etc/init.d/servicemix'], File["/var/www/hydradam/servicemix"]]
  }

  file {
    "/var/www/hydradam/servicemix/etc/org.apache.karaf.features.cfg":
    content => "################################################################################
#
#    Licensed to the Apache Software Foundation (ASF) under one or more
#    contributor license agreements.  See the NOTICE file distributed with
#    this work for additional information regarding copyright ownership.
#    The ASF licenses this file to You under the Apache License, Version 2.0
#    (the \"License\"); you may not use this file except in compliance with
#    the License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an \"AS IS\" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#
################################################################################

#
# Comma separated list of features repositories to register by default
#
featuresRepositories=mvn:org.apache.karaf.assemblies.features/standard/2.2.2-fuse-03-05/xml/features,mvn:org.apache.karaf.assemblies.features/enterprise/2.2.2-fuse-03-05/xml/features,mvn:org.apache.servicemix.nmr/apache-servicemix-nmr/1.5.1-fuse-02-05/xml/features,mvn:org.apache.servicemix/apache-servicemix/4.4.1-fuse-02-05/xml/features,mvn:org.apache.camel.karaf/apache-camel/2.8.0-fuse-02-05/xml/features,mvn:org.apache.activemq/activemq-karaf/5.5.1-fuse-02-05/xml/features

#
# Comma separated list of features to install at startup
#
featuresBoot=karaf-framework,config,xml-specs,activemq-broker,activemq-spring,camel,camel-activemq,camel-nmr,saaj,camel-cxf,camel-blueprint,jbi-cluster,war,servicemix-cxf-bc,servicemix-file,servicemix-ftp,servicemix-http,servicemix-jms,servicemix-mail,servicemix-smpp,servicemix-snmp,servicemix-vfs,servicemix-bean,servicemix-camel,servicemix-cxf-se,servicemix-drools,servicemix-eip,servicemix-osworkflow,servicemix-quartz,servicemix-scripting,servicemix-validation,servicemix-saxon,servicemix-wsn2005,camel-http,camel-script,camel-soap,camel-velocity,camel-mail,camel-exec",
    require => [File["/var/www/hydradam/servicemix"]]
  }

}

