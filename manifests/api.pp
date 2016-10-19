# Class: cachet::api
#
# This private class enables API calls on Cachet (through Puppet Custom Types). Do not call this class direct!
#
class cachet::api inherits cachet {
  # Template parameters
  $base_url = "http://${vhost_servername}:${vhost_port}/api/v1/"# Needs to end with slash !!!
  $api_key = $admin_api_key

  file { '/etc/cachet':
    ensure  => 'directory',
  }

  file { '/etc/cachet/api.yaml':
    ensure  => 'file',
    content => template('cachet/api.yaml.erb')
  }

  # Dependency Gems Installation
  if versioncmp($::puppetversion, '4.0.0') < 0 {
    ensure_packages(['cachet_api'], {'ensure' => 'present', 'provider' => 'gem'})
  } else {
    ensure_packages(['cachet_api'], {'ensure' => 'present', 'provider' => 'puppet_gem'})
  }
}
