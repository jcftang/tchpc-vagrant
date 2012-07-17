class s_apache::ssl::global {

   include apache::ssl::basic

   @iptables::open_port { 'https':
     networks => ['0/0'],
     number   => '443',
     comment  => 'Allow HTTPS',
   }

}
