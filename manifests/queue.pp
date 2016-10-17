# Class: cachet::queue
#
# This private class sets up (Async) Queue method for Cachet. Do not call this class direct!
#
class cachet::queue inherits cachet {
  validate_re($cachet::queue_driver, ['sync', 'database', 'redis'])

  if ($cachet::queue_driver != 'sync' ) {
    if ($cachet::queue_worker == 'supervisor') {
      if versioncmp($cachet::version, 'v2.4.0') < 0 {
        $command_args = '--daemon --delay=1 --sleep=1 --tries=3'
      } else {
        $command_args = '--delay=1 --sleep=1 --timeout=1800 --tries=3'
      }

      supervisord::program { 'cachet-queue':
        command         => "/usr/bin/php artisan queue:work ${command_args}",
        directory       => $cachet::install_path,
        user            => 'www-data',
        autostart       => true,
        autorestart     => true,
        redirect_stderr => true,
      }
    }

    if ($cachet::queue_worker == 'cron') {
      cron { 'cachet_queue':
        command => "/usr/bin/php ${cachet::install_path}/artisan schedule:run >> /dev/null 2>&1",
        minute  => '*',
        user    => 'www-data',
      }
    }
  }
}
