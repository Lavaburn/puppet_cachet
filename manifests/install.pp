# Class: cachet::install
#
# This private class install Cachet. Do not call this class direct!
#
class cachet::install inherits cachet {
  if ($cachet::setup_apache) {
    class { '::apache':
      mpm_module => 'worker',
    }

    class { '::apache::mod::actions': }
    class { '::apache::mod::rewrite': }

    apache::fastcgi::server { 'php':
      host       => '127.0.0.1:9000',
      timeout    => 60,
      flush      => false,
      faux_path  => '/var/www/php.fcgi',
      fcgi_alias => '/php.fcgi',
      file_type  => 'application/x-httpd-php'
    }

    apache::custom_config { 'php_type':
      ensure  => 'present',
      content => 'AddType application/x-httpd-php .php',
    }
  }

  if ($cachet::setup_php) {
    class { '::php':
      ensure     => 'present',
      composer   => $cachet::setup_composer,
      fpm        => true,
      extensions => {
        'gd' => {}
      },
    }
  }

  if ($cachet::setup_redis) {
    include '::redis'
  }

  if ($cachet::setup_mysql) {
    include '::mysql::server'

    class {'mysql::bindings':
      php_enable => true,
    }
  }

  if ($cachet::setup_git) {
    include '::git'
  }

  if ($cachet::setup_supervisord) {
    class { 'supervisord':
      install_pip => true,
    }
  }

  Class['::git']
  ->
  vcsrepo { $cachet::install_path:
    ensure   => 'present',
    provider => 'git',
    source   => $cachet::git_repo,
    revision => $cachet::version,
  }
  ~>
  exec { 'Create Cachet app_key File':
    command     => "/bin/echo 'APP_KEY=${cachet::application_key}' > ${cachet::install_path}/.app_key",
    refreshonly => true,
  }
}
