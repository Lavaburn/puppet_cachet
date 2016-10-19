# Class: cachet
#
# This module manages Cachet
#
# It can install the webapp, configure and set it up for API config.
#
# Parameters:
#   * application_key (string): Random Application Key (used for DB encryption) [REQUIRED]
#   * db_password (string): Database password [REQUIRED]
#   * admin_username (string): Username for the initial Administrator [REQUIRED]
#   * admin_password (string): Password for the initial Administrator (BLOWFISH hash - $2y$) [REQUIRED]
#   * admin_email (string): E-mail address for the initial Administrator[REQUIRED]
#   * admin_api_key (string): API key for the initial Administrator (used by Puppet Custom Types) [REQUIRED]
#   * setup_apache (boolean): Whether to install Apache. Default = false
#   * setup_git (boolean): Whether to install Git. Default = false
#   * setup_mysql (boolean): Whether to install MySQL. Default = false
#   * setup_php (boolean): Whether to install PHP. Default = false
#   * setup_composer (boolean): Whether to install Composer. Default = false
#   * setup_redis (boolean): Whether to install Redis. Default = false
#   * setup_supervisord (boolean): Whether to install Supervisor. Default = false
#   * install_path (absolute path): See Params
#   * git_repo (string): See Params
#   * version (string): See Params
#   * queue_driver (string): See Params
#   * cache_driver (string): See Params
#   * session_driver (string): See Params
#   * queue_worker (string): See Params
#   * app_name (string): See Params
#   * app_timezone (string): See Params
#   * app_locale (string): See Params
#   * app_show_support (numeric): See Params
#   * app_incident_days (numeric): See Params
#   * setup_db: Whether to setup MySQL DB. Default = true
#   * db_driver (string): See Params
#   * db_hostname (string): See Params
#   * db_username (string): See Params
#   * db_name (string): See Params
#   * redis_hostname (string): See Params
#   * redis_db (numeric): See Params
#   * redis_port (numeric): See Params
#   * setup_vhost: Whether to setup Apache vhost. Default = true
#   * vhost_servername: Server hostname (Vhost name). Default = $::fqdn
#   * vhost_port (numeric): See Params
#   * smtp_hostname (string): See Params
#   * smtp_port (numeric): See Params
#   * smtp_username (string): See Params
#   * smtp_password (string): See Params
#   * smtp_address (string): See Params
#   * smtp_name (string): See Params
#   * smtp_encryption (string): See Params
#
class cachet (
  # Required Parameters
  $application_key,
  $db_password,

  # Admin User
  $admin_username,
  $admin_password,
  $admin_email,
  $admin_api_key,

  $setup_apache      = false,
  $setup_git         = false,
  $setup_mysql       = false,
  $setup_php         = false,
  $setup_composer    = false,
  $setup_redis       = false,
  $setup_supervisord = false,

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
  contain 'cachet::api'

  # Ordering
  Class['cachet::install'] -> Class['cachet::config'] -> Class['cachet::setup'] -> Class['cachet::api']
}
