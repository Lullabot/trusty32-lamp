trusty-lamp-vm
==============

There are a ton of Vagrant base boxes available for web developers. Or,
Chef / Puppet configurations to take a basic OS install and configure it "just
right". There's two key problems I've run into with other projects:

* Reverse-engineering the configuration to make minor changes took more time to
  make than it would have been to build a box from scratch.
* Many boxes look useful, but aren't signed by a trusted source. How would I
  know that the box wasn't sending off my API keys or code to some other
  source?

With the release of Ubuntu 14.04, I needed to get up to speed on Apache and PHP
configuration anyways. As well, I wanted something that would easily let me do
PHP profiling. So, here's the results of that effort (even though 99% of it is
likely completed elsewhere).

Goals
-----

* < 5 minute setup time for new users.
* Everything you need for most PHP applications.
* Drush included for Drupal dev (and out of the way for everything else).
* xhgui built in and configured for easy opt-in profiling.
* No provisioning whatsoever; treat boxes as "fork and forget" for new projects.

Setup instructions
------------------

Each modification in the Vagrantfile is marked with an all-caps header such as
PRIVATE NETWORK. Use this to easily jump around in the file.

# Add this base box to Vagrant with ```vagrant box add <url>```.
# Clone ```this repo``` to get the base Vagrantfile.
# Decide on a hostname and IP address for your VM.
** Create a private network by uncommenting and editing the line in the
   Vagrantfile under PRIVATE NETWORK.
** Add a line to ```/etc/hosts``` with your desired hostname and IP address.
# Set up code syncing by uncommenting the appropriate line in the Vagrantfile.
** By default a 'www' folder is mounted to ```/var/www```. It's mounted with
   the built-in Virtualbox shared folders, which work everywhere but are very
   slow. Most users will want to switch it to NFS or rsync. See FILE SYNCING in
   the Vagrantfile.
** ```/var/www/docroot``` is served as the default site.
** For larger codebases, a significant performance improvement can be seen by
   switching to rsync as supported with Vagrant 1.5.
# Boot the VM with ```vagrant up```.
# Browse to the hostname you choose to see phpinfo or the code you have synced.

### Optional setup

The VM is configured with a single CPU core and 512MB of memory, so it will at
least boot on low end hardware. Most developers will want to allocate more
resources. See RESOURCE SETTINGS in the Vagrantfile.

Basebox Details
---------------

### /etc management

/etc is managed with etckeeper which is configured to commit to a git
repository. Run ```sudo git log -p``` in /etc to see all of the configuration
changes made since the initial installation.

### Permissions

The default group for the vagrant user has been changed to www-data. As well,
/var/www is owned by vagrant:www-data.

### Grub

Grub has been configured with a three second delay so it's actually possible to
get to the menu when booting a VM.

### Unable to mount shared folders fixed

The VirtualBox additions install to /top, but /sbin/mount.vboxfs expects them
in /usr/lib. <a href="https://forums.virtualbox.org/viewtopic.php?f=3&p=283645">
A symlink has been added</a> from /usr/lib/VBoxGuestAdditions to fix this.

### Apache configuration

Apache is configured to serve ```/var/www/docroot``` as the primary site. That
directory is set to ```AllowOverride All```.

Package highlights
------------------

* LAMP stack composed of
** Apache 2.4
** MariaDB 5.5
** PHP 5.5 (using mod_php)
* vim-full instead of vim-tiny
* unison for file syncing
* Drush, installed from git into /opt
* xhgui and xdebug

PHP Profiling with XHGui
------------------------

XHGui is installed to /opt and preconfigured to profile PHP requests. Profiles
are kept for 5 days, and indexes have been added as recommended by the xhgui
setup instructions.

*To start profiling* simply append ?xhprof=on to a request. This will set a
cookie that will keep profiling enabled for the next hour, regardless of the
query parameters. Browse to /xhgui to view your profiles.
