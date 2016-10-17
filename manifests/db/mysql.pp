# Class: cachet::config
#
# This private class configures Cachet. Do not call this class direct!
#
class cachet::db::mysql inherits cachet {
  ::mysql::db { $cachet::db_name:
    host     => $cachet::db_hostname,
    user     => $cachet::db_username,
    password => $cachet::db_password,
  }
}
