# Puppet Module - Cachet

#### Table of Contents

1. [Overview](#overview)
2. [Dependencies](#dependencies)
3. [Usage](#usage)
4. [Compatibility](#compatibility)
5. [Testing](#testing)
6. [Copyright] (#copyright)

## Overview

This module installs and configures Cachet for first use.
It also contains custom types to manage Cachet using the REST API.

## Dependencies

This module depends on some standard libraries to configure and set up Cachet:
- puppetlabs/concat
- puppetlabs/stdlib
- puppetlabs/vcsrepo

Optionally, you can use a number of modules to set up the complete stack:
- puppet/php
- thomasvandoren/redis
- puppetlabs/mysql
- puppetlabs/apache
- puppetlabs/git
- ajcrowe/supervisord

## Usage

### Default - External Dependencies
class { 'cachet':
  application_key => 'VeryR@nd0mK3Y',
  db_password     => 'mypassword',
  admin_username  => 'admin1',
  admin_password  => 'password1',
  admin_email     => 'admin1@example.com',
  admin_api_key   => 'APIKEY123',
}

### Full Stack Setup
class { 'cachet':
  application_key   => 'VeryR@nd0mK3Y',
  db_password       => 'mypassword',
  admin_username    => 'admin1',
  admin_password    => 'password1',
  admin_email       => 'admin1@example.com',
  admin_api_key     => 'APIKEY123',
  setup_apache      => true,
  setup_git         => true,
  setup_mysql       => true,
  setup_php         => true,
  setup_composer    => true,
  setup_redis       => true,
  setup_supervisord => true,
}

## Compatibility

This module is compatible with Cachet 2.3.x

This module is compatible with:
  * Ubuntu 12.04 LTS (untested) and 14.04 LTS (tested)
  * CentOS 6.x and 7.x (untested)
(RHEL 6 and 7 can be easily added)

This module has been tested on: 
- Puppet 4.3.2 (Ruby 2.1.8)

## Testing

Dependencies:
- Ruby
- Bundler (gem install bundler)

If you wish to test this module yourself:
1. bundle
2. rake test

For running acceptance testing (beaker/vagrant):
1. rake beaker

## Copyright

   Copyright 2016 Nicolas Truyens

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
