# Class: cachet::config
#
# This private class configures Cachet. Do not call this class direct!
#
class cachet::config inherits cachet {
  concat { 'cachet_environment_config':
    path  => "${cachet::install_path}/.env",
    owner => 'www-data',
  } ~> Exec['Clear Cached Config']

  concat::fragment { 'cachet_environment_config_main':
    target  => 'cachet_environment_config',
    content => template('cachet/env.erb'),
    order   => 10,
  }

  concat::fragment { 'cachet_environment_config_app_key':
    target => 'cachet_environment_config',
    source => "${cachet::install_path}/.app_key",
    order  => 20,
  }

  exec { 'Clear Cached Config':
    command     => '/usr/bin/php artisan config:cache',
    cwd         => $cachet::install_path,
    refreshonly => true,
    require     => Exec['Composer Install Dependencies for Cachet'],
  }

#  Vcsrepo[$cachet::install_path] ->
#  augeas { 'composer_predis':
#	  changes => [
#	    #'set /files/opt/cachet/composer.json/require "predis/predis": "^1.1",'
#	  ],
#	  incl    => '/opt/cachet/composer.json',
#	  lens    => 'Json.lns',
#	 }
#  -> Exec['Composer Install Dependencies for Cachet']

  exec { 'Composer Install Dependencies for Cachet':
    command     => '/usr/local/bin/composer install',
    cwd         => $cachet::install_path,
    environment => ['HOME=/root', 'COMPOSER_HOME=/usr/local/bin'],
    refreshonly => true,
    subscribe   => Vcsrepo[$cachet::install_path],
    require     => Class['php::extension::gd'],
  }

  exec { 'Composer add REDIS dependency':
    command     => '/usr/local/bin/composer require predis/predis',
    cwd         => $cachet::install_path,
    environment => ['HOME=/root', 'COMPOSER_HOME=/usr/local/bin'],
    refreshonly => true,
    subscribe   => Exec['Composer Install Dependencies for Cachet'],
  }
  -> Exec['Artisan Install Cachet Application']

  exec { 'Artisan Install Cachet Application':
    command     => '/usr/bin/php artisan app:install',
    cwd         => $cachet::install_path,
    refreshonly => true,
    subscribe   => Vcsrepo[$cachet::install_path],
    require     => [
      Concat['cachet_environment_config'],
      Exec['Composer Install Dependencies for Cachet'],
    ],
    unless      => "/usr/bin/mysql -h ${cachet::db_hostname} -u ${cachet::db_username} --password=${cachet::db_password} ${cachet::db_name} -e 'SELECT * from cache LIMIT 1;'",
  }
  ~>
  exec { 'Store Cachet APP_KEY':
    command     => "/bin/grep APP_KEY ${cachet::install_path}/.env > ${cachet::install_path}/.app_key",
    refreshonly => true,
  }

  exec { 'Fix permissions for Cachet Bootstrap':
    command     => "/bin/chmod -R 777 ${cachet::install_path}/bootstrap",
    refreshonly => true,
    subscribe   => Exec['Artisan Install Cachet Application'],
  }

  exec { 'Fix owner for Cachet Bootstrap':
    command     => "/bin/chown -R www-data ${cachet::install_path}/bootstrap",
    refreshonly => true,
    subscribe   => Exec['Artisan Install Cachet Application'],
  }

  exec { 'Fix permissions for Cachet Storage':
    command     => "/bin/chmod -R 777 ${cachet::install_path}/storage",
    refreshonly => true,
    subscribe   => Exec['Artisan Install Cachet Application'],
  }

  exec { 'Fix owner for Cachet Storage':
    command     => "/bin/chown -R www-data ${cachet::install_path}/storage",
    refreshonly => true,
    subscribe   => Exec['Artisan Install Cachet Application'],
  }

#  exec { 'Clear Cachet Bootstrap Cache':
#    command     => "/bin/rm -rf ${cachet::install_path}/bootstrap/cache/*",
#    refreshonly => true,
#    subscribe   => Exec['Artisan Install Cachet Application'],
#  }

  if ($cachet::setup_vhost) {
    apache::vhost { 'cachet':
      port        => $cachet::vhost_port,
      servername  => $cachet::vhost_servername,
      docroot     => "${cachet::install_path}/public",
      directories => [
        {
          path           => "${cachet::install_path}/public",
          options        => [ 'Indexes FollowSymLinks' ],
          allow_override => [ 'All' ],
          #Apache 2.4 ONLY !! - auth_require   => 'all granted',
        },
      ],
    }
  }

  if ($cachet::setup_db) {
    case ($cachet::db_driver) {
      'mysql': {
        include cachet::db::mysql
      }
      default:  {
        fail("DB Driver ${cachet::db_driver} is not valid. Expected one of -mysql-")
      }
    }
  }

  include cachet::queue
}
