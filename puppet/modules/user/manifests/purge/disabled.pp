class user::purge::disabled inherits user::purge {

  # Override resources declaration to disable user purging
  Resources[user] { purge => false }

}
