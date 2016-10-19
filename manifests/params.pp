# Class: cachet::params
#
# Contains system-specific parameters
#
# Parameters:
#   * install_path (absolute path): Path to root directory. Default: /opt/cachet
#   * git_repo (string): Git repository to clone. Default: https://github.com/CachetHQ/Cachet.git
#   * version (string): Git tag to pull. Default: v2.3.10
#   * vhost_port (numeric): Port for Apache Vhost to listen to. Default: 8001
#   * queue_driver (string): Driver for the queue. Default: sync
#   * cache_driver (string): Driver for the cache. Default: file
#   * session_driver (string): Driver for the sessions. Default: file
#   * queue_worker (string): Method to process the queue. Default: supervisor
#   * app_name (string): Application Name. Default: Cachet
#   * app_timezone (string): Application Timezone. Default: GMT
#   * app_locale (string): Application Locale. Default: en
#   * app_show_support (numeric): Whether to show link to Cachet on Dashboard. Default: 1
#   * app_incident_days (numeric): The number of days to show incident history for. Default: 7
#   * db_driver (string): Driver for the database. Default: mysql
#   * db_hostname (string): Hostname for the database. Default: localhost
#   * db_username (string): Username for the database. Default: cachet
#   * db_name (string): Database name. Default: cachet
#   * redis_hostname (string): Hostname for Redis driver. Default: localhost
#   * redis_db (numeric): Redis database. Default: 0
#   * redis_port (numeric): Port for Redis driver. Default: 6379
#   * smtp_hostname (string): Hostname of the SMTP server. Default: localhost
#   * smtp_port (numeric): Port of the SMTP server. Default: 25
#   * smtp_username (string): Username for the SMTP server. Default: null
#   * smtp_password (string): Password for the SMTP server. Default: null
#   * smtp_address (string): E-mail address to send mails from. Default: null
#   * smtp_name (string): Name to send mails from. Default: null
#   * smtp_encryption (string): Encryption method to use on SMTP server. Default: null
#
class cachet::params {
  $install_path = '/opt/cachet'

  $git_repo = 'https://github.com/CachetHQ/Cachet.git'
  $version = 'v2.3.10'

  $vhost_port = '8001'

  $queue_driver   = 'sync'
  $cache_driver   = 'file'
  $session_driver = 'file'
  $queue_worker   = 'supervisor'

  # Application
  $app_name          = 'Cachet'
  $app_timezone      = 'GMT'
  $app_locale        = 'en'
  $app_show_support  = '1'
  $app_incident_days = '7'

  # Database
  $db_driver   = 'mysql'
  $db_hostname = 'localhost'
  $db_username = 'cachet'
  $db_name     = 'cachet'

  # Redis
  $redis_hostname = 'localhost'
  $redis_db       = '0'
  $redis_port     = '6379'

  # SMTP
  $smtp_hostname   = 'localhost'
  $smtp_port       = '25'
  $smtp_username   = 'null'
  $smtp_password   = 'null'
  $smtp_address    = 'null'
  $smtp_name       = 'null'
  $smtp_encryption = 'null'
}
