class s_yum::client inherits s_yum {

 include yum::client,
         yum::client::priorities

}
