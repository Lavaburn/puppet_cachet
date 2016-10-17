# Class: cachet::params
#
# Parameter class for Cachet Module
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
