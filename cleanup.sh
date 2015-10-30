#!/bin/bash

# Fix /home/vagrant/.composer being owned by root
# See https://github.com/willdurand/puppet-composer/pull/10
rm -rf /home/vagrant/.composer
rm -f /var/cache/apt/*bin
find /var/log -type f -exec rm {} \;
find /var/lib/apt/lists -type f -not -name '*gpg' -exec rm {} \;
