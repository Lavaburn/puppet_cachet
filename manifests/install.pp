# Class: cachet::install
#
# This private class install Cachet. Do not call this class direct!
#
class cachet::install inherits cachet {
  if ($cachet::setup_apache) {
    class { '::apache':
      mpm_module => 'prefork',
    }

    class { '::apache::mod::php': }
    class { '::apache::mod::rewrite': }
  }

  #check/enforce PHP >= 5.5.9 ??
  if ($cachet::setup_php) {
    include '::php'
    include '::php::apache'

    class { 'php::extension::gd':
      ensure => 'installed',
    }
  }

  if ($cachet::setup_composer) {
    include '::php::cli'
    include '::php::composer'
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
