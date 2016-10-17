# Class: cachet
#
# This module manages Cachet
#
class cachet (
  # Required Parameters
  $application_key,
  $db_password,

  # Admin User
  $admin_username,
  $admin_password,  # $2y$10$46SXyriJEefnrrcoUx0iuuF2Msxf1aT6ThAZAxUVvHAoms9w9akDW
  $admin_email,
  $admin_api_key,

  # TODO - default to false
  $setup_apache      = true,
  $setup_git         = true,
  $setup_mysql       = true,
  $setup_php         = true,
  $setup_composer    = true,
  $setup_redis       = true,
  $setup_supervisord = true,
  # END TODO

  $install_path = $::cachet::params::install_path,
  $git_repo     = $::cachet::params::git_repo,
  $version      = $::cachet::params::version,

  $queue_driver      = $::cachet::params::queue_driver,
  $cache_driver      = $::cachet::params::cache_driver,
  $session_driver    = $::cachet::params::session_driver,
  $queue_worker      = $::cachet::params::queue_worker,

  # Application
  $app_name          = $::cachet::params::app_name,
  $app_timezone      = $::cachet::params::app_timezone,
  $app_locale        = $::cachet::params::app_locale,
  $app_show_support  = $::cachet::params::app_show_support,
  $app_incident_days = $::cachet::params::app_incident_days,

  # DB Data
  $setup_db    = true,
  $db_driver   = $::cachet::params::db_driver,
  $db_hostname = $::cachet::params::db_hostname,
  $db_username = $::cachet::params::db_username,
  $db_name     = $::cachet::params::db_name,

  # Redis Data
  $redis_hostname = $::cachet::params::redis_hostname,
  $redis_db       = $::cachet::params::redis_db,
  $redis_port     = $::cachet::params::redis_port,

  # Vhost Data
  $setup_vhost      = true,
  $vhost_servername = $::fqdn,
  $vhost_port       = $::cachet::params::vhost_port,

  # Mail/SMTP Config
  $smtp_hostname   = $::cachet::params::smtp_hostname,
  $smtp_port       = $::cachet::params::smtp_port,
  $smtp_username   = $::cachet::params::smtp_username,
  $smtp_password   = $::cachet::params::smtp_password,
  $smtp_address    = $::cachet::params::smtp_address,
  $smtp_name       = $::cachet::params::smtp_name,
  $smtp_encryption = $::cachet::params::smtp_encryption,
) inherits cachet::params {
  # Validation
  validate_re($session_driver, ['file', 'redis'])
  validate_re($db_driver, ['sqlite', 'mysql', 'pgsql'])
  validate_re($cache_driver, ['apc', 'array', 'database', 'file', 'memcached', 'redis'])

  # Includes
  contain 'cachet::install'
  contain 'cachet::config'
  contain 'cachet::setup'

  # api: XXX/api/v1/
  # Integration: /api/v1/ping => pong

  # Ordering
  Class['cachet::install'] -> Class['cachet::config'] -> Class['cachet::setup']
}
