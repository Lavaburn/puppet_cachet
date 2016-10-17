# Class: cachet::setup
#
# This private class sets up Cachet. Do not call this class direct!
#
class cachet::setup inherits cachet {
  file { "${cachet::install_path}/first_time_setup.sql":
    ensure  => 'file',
    content => template('cachet/first_time_setup.sql.erb'),
  }
  ->
  exec { 'Cachet First Time Setup':
    command     => "/usr/bin/mysql -h ${cachet::db_hostname} -u ${cachet::db_username} --password=${cachet::db_password} ${cachet::db_name} < ${cachet::install_path}/first_time_setup.sql",
    cwd         => $cachet::install_path,
    refreshonly => true,
    subscribe   => Exec['Store Cachet APP_KEY'],
    unless      => "/usr/bin/mysql -h ${cachet::db_hostname} -u ${cachet::db_username} --password=${cachet::db_password} ${cachet::db_name} -e 'SELECT * from settings WHERE name = \"app_name\";' | grep 1",
  }
  ~>
  exec { 'Cachet Clear Cached Config':
    command     => "/bin/rm -rf ${cachet::install_path}/bootstrap/cachet/*",
    cwd         => $cachet::install_path,
    refreshonly => true,
  }
}
