trusty32-lamp-vm
==============

[Setup instructions for the impatient](#setup-instructions).

There are a ton of Vagrant base boxes available for web developers. Or,
Chef / Puppet configurations to take a basic OS install and configure it "just
right". There's two key problems I've run into with other projects:

* Reverse-engineering the configuration to make minor changes took more time to
  make than it would have been to build a box from scratch.
* Many boxes look useful, but aren't signed by a trusted source. How would I
  know that the box wasn't sending off my API keys or code to some random
  server?

With the release of Ubuntu 14.04, I needed to get up to speed on Apache and PHP
configuration anyways. As well, I wanted something that would easily let me do
PHP profiling. So, here's the results of that effort (even though 99% of it is
likely completed elsewhere).

Goals
-----

* < 5 minute setup time for new users.
* Everything you need for most PHP applications.
* [xhgui](https://github.com/perftools/xhgui) built in and configured for easy
  opt-in profiling.
* [Linux MySQL Manager](https://github.com/Lullabot/lmm) for snapshotting databases.
* [Drush](https://github.com/drush-ops/drush) included for Drupal dev (and out
  of the way for everything else).
* No provisioning whatsoever; treat boxes as "fork and forget" for new projects.

Setup instructions
------------------

Each modification in the Vagrantfile is marked with an all-caps header such as
PRIVATE NETWORK. Use this to easily jump around in the file.

1. Add this base box to Vagrant with:
   * ```vagrant box add --name trusty32-lamp
   https://www.dropbox.com/sh/oy1av6uhod3yeto/PaA1XEbWux/trusty32-lamp.box```.
   * Or optionally [verify your download](#verifying-basebox-integrity).
1. Clone ```this repo``` to get the base Vagrantfile.
1. Decide on a hostname and IP address for your VM.
   * Configure your PRIVATE NETWORK settings to set an accessible IP for your VM.
   * Your hostname **must end in .local** for automatic DNS to work.
   * If your system does not support ZeroConf / Bonjour (most do)
     * Windows users can install
      [Bonjour for Windows](http://support.apple.com/kb/dl999)
     * Linux users can install ```avahi``` if it's not installed.
     * Or, manually add a line to ```/etc/hosts``` or
      ```C:\Windows\System32\drivers\etc\hosts``` with your desired hostname
      and IP address.
1. Set up FILE SYNCING by uncommenting the appropriate line in the Vagrantfile.
   * No file syncing is set up by default.
   * The only assumption is that whatever is mounted into ```/var/www``` has a
   docroot directory.
   * Most users will want to use NFS or rsync.
   * For larger codebases, a significant performance improvement can be seen by
   switching to rsync over NFS as supported with Vagrant 1.5.
1. Boot the VM with ```vagrant up```.
1. Browse to the hostname you choose to see phpinfo or the code you have synced.
1. Run ```sudo /vagrant/change-hostname <hostname>``` to tell the VM about
   it's new hostname.

### Optional setup

Configure RESOURCE SETTINGS to change the defaults of a single CPU core and
512MB of memory.

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

### "Unable to mount shared folders" fixed

The VirtualBox additions install to /top, but /sbin/mount.vboxfs expects them
in /usr/lib. <a href="https://forums.virtualbox.org/viewtopic.php?f=3&p=283645">
A symlink has been added</a> from /usr/lib/VBoxGuestAdditions to fix this.

### Apache configuration

Apache is configured to serve ```/var/www/docroot``` as the primary site. That
directory is set to ```AllowOverride All```.

Package highlights
------------------

* LAMP stack composed of
  * Apache 2.4
  * MariaDB 5.5
  * PHP 5.5 (using mod_php)
  * memcached 1.4
  * redis 2.8
* vim-full instead of vim-tiny
* Drush, installed from git into /opt
* xhgui and xdebug

See [PACKAGES.txt](PACKAGES.txt) for the full list.

PHP Profiling with XHGui
------------------------

XHGui is installed to /opt and preconfigured to profile PHP requests. Profiles
are kept for 5 days, and indexes have been added as recommended by the xhgui
setup instructions.

**To start profiling** simply append ```?xhprof=on``` to a request. This will
set a cookie that will keep profiling enabled for the next hour, regardless of
the query parameters. Browse to /xhgui to view your profiles.

Email Configuration
-------------------

Setting up an email system that works in all cases is difficult to do. Some may
need no email at all, while others want email to be forwarded to some other
system. If email is required, try either:

* ```apt-get install postfix mailutils```, followed by selecting local only
  delivery. Mail can then be viewed by running the 'mail' command.
* Redirecting all mail to another address by following "Method 1" over at
  [Oh no! My laptop just sent notifications to 10,000 users](https://www.lullabot.com/blog/article/oh-no-my-laptop-just-sent-notifications-10000-users).

Verifying basebox integrity
---------------------------

GPG and SHA1 signatures are available in the
[Dropbox folder](https://www.dropbox.com/sh/oy1av6uhod3yeto/Pxuqc9NSFS).

### Verifying the download when adding the box

```vagrant box add --name=trusty32-lamp --checksum [sha1-from-trusty32-lamp.box.sha1] --checksum-type=sha1 [url-to-box]```

### Verifying the box manually

1. Download the box directly.
1. Download the corresponding .sha1 file.
1. ```shasum -c trusty32-lamp.box.sha1```.

### Validating my identity

1. Download the box directly.
1. Download the corresponding .asc file.
1. ```gpg --recv-keys CDCAA3E1 # Or download CDCAA3E1.key from dropbox and import it.```
1. ```gpg --verify trusty32-lamp.box.asc```
   * GPG will throw a warning about the signature not being trusted unless you
     or someone else in your web of trust has signed my key.
