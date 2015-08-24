puppet-composer
===============

[![Build
Status](https://secure.travis-ci.org/willdurand/puppet-composer.png)](http://travis-ci.org/willdurand/puppet-composer)

This module installs [Composer](http://getcomposer.org/), a dependency manager
for PHP.

Installation
------------

Using the Puppet Module Tool, install the
[`willdurand/composer`](http://forge.puppetlabs.com/willdurand/composer) by
running the following command:

    puppet module install willdurand/composer

Otherwise, close this repository and make sure to install the proper
dependencies ([`puppet-wget`](https://github.com/maestrodev/puppet-wget)):

    git clone git://github.com/willdurand/puppet-composer.git modules/composer

**Important:** the right `puppet-wget` module is
[maestrodev/puppet-wget](https://github.com/maestrodev/puppet-wget). You should
**not** use any other `puppet-wget` module. Example42's module won't work for
instance. So, please, run the following command:

    git clone git://github.com/maestrodev/puppet-wget.git modules/wget


Usage
-----

Include the `composer` class:

    include composer

You can specify the command name you want to get, and the target directory (aka
where to install Composer):

    class { 'composer':
      command_name => 'composer',
      target_dir   => '/usr/local/bin'
    }

You can also auto update composer by using the `auto_update` parameter. This will
update Composer **only** when you will run Puppet.

    class { 'composer':
      auto_update => true
    }

You can specify a particular `user` that will be the owner of the Composer
executable:

    class { 'composer':
      user => 'foo',
    }


Running the tests
-----------------

Install the dependencies using [Bundler](http://gembundler.com):

    BUNDLE_GEMFILE=.gemfile bundle install

Run the following command:

    BUNDLE_GEMFILE=.gemfile bundle exec rake spec


License
-------

puppet-composer is released under the MIT License. See the bundled LICENSE file
for details.
