# auditd
[![Puppet Forge](http://img.shields.io/puppetforge/v/kemra102/auditd.svg)](https://forge.puppetlabs.com/kemra102/auditd)
[![Build Status](https://travis-ci.org/kemra102/puppet-auditd.svg?branch=master)](https://travis-ci.org/kemra102/puppet-auditd)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with auditd](#setup)
    * [What auditd affects](#what-auditd-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with auditd](#beginning-with-auditd)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Audit Rules](#rules)
    * [Audisp Plugins](#audisp-plugins)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Development - Guide for contributing to the module](#development)
    * [Testing](#testing)
7. [Contributors](#contributors)

## Overview

The [auditd](http://people.redhat.com/sgrubb/audit/) subsystem is an access monitoring and accounting for Linux developed and maintained by RedHat. It was designed to integrate pretty tightly with the kernel and watch for interesting system calls.

## Module Description

This module handles installation of the auditd daemon, manages its main configuration file as well as the user specified rules that auditd uses.

## Setup

### What auditd affects

* **auditd** package.
* Main config file.
* Rules file.
* **auditd** service.

### Setup Requirements

Arch Linux does not compile in auditing support to their Kernel by default. To enable support you will have to enable this support as per [this Arch Wiki page](https://wiki.archlinux.org/index.php/Audit_framework#Installation).

Other supported Linux distros should not need any special setup.

### Beginning with auditd

The most basic set-up you could achieve with this module looks something like this:

```puppet
include '::auditd'
```

or

```puppet
class { 'auditd': }
```

This will ensure auditd is installed with a basic configuration and the service is running but it will not have any rules.

## Usage

Config file settings can be changed as required:

```puppet
class { 'auditd':
  log_file => '/var/log/audit.log',
}
```

This changes the path of the log file in the main config then sets several rules of varying types and quantities.

You can also do this in Hiera:

```yaml
---
classes:
  - auditd
auditd::log_file: '/var/log/audit.log'
```

### Rules

Audit rules (there is no distinction between Control, File System & System Call rules) are created using a defined type based on concat and as such can be ordered as required using this format:

```puppet
auditd::rule { 'Rule Name':
  content => 'Rule',
  order   => 'Order rule should appear in rules file starting with 01',
}
```

For example:

```puppet
include '::auditd'

auditd::rule { 'watch for updates to users':
  content => '-w /etc/passwd -p wa -k identity',
  order   => 1,
}
auditd::rule { 'audit for time changes':
  content => '-a always,exit -S clock_settime -k time-change',
  order   => 2,
}
auditd::rule { '-a always,exit -S sethostname -S setdomainname -k system-locale':
  order   => 3,
}
```

Rules can also be set from within the main class via the `rules` hash:

```puppet
class { '::auditd':
  rules => {
    'watch for changes to passwd file' => {
      content => '-w /etc/passwd -p wa -k identity',
      order   => 1,
    },
    'watch for changes to hosts file'  => {
      content => '-w /etc/hosts -p wa -k system-locale',
      order   => 2,
    },
  },
}
```

As you can see from the last rule if you omit the content the name of the resource is taken as the content instead.

You should also note that all rules files are populated with `-D` and a rule to set the buffer size so these should not be set via rules.

### Audisp Plugins

audispd is an audit event multiplexor. It has to be started by the audit daemon in order to get events. It takes audit events and distributes them to child programs that want to analyze events in realtime. When the audit daemon receives a SIGTERM or SIGHUP, it passes that signal to the dispatcher, too. The dispatcher in turn passes those signals to its child processes.

This module supports a number of Audisp plugins as described below. All of the plugins require the main `::auditd` class but none require it automatically so you should include it yourself.

#### af_unix

This plugin takes events and writes them to a unix domain socket. This plugin can take 2 arguments, the path for the socket and the socket permissions in octal.

To use this plugin:

```puppet
include '::auditd'
include '::auditd::audisp::af_unix'
```

You can change the `args` for this plugin:

```puppet
include '::auditd'
class { '::auditd::audisp::af_unix':
  args => '0660 /var/run/my_app',
}
```

#### au_remote

This plugin will send events to a remote machine (Central Logger).

To use this plugin:

```puppet
include '::auditd'
include '::auditd::audisp::au_remote'
```

#### audispd_zos_remote

Note that this specific plugin has a configuration file of its own (/etc/audisp/zos-remote.conf). See audispd-zos-remote(8)

To use this plugin:

```puppet
include '::auditd'
include '::auditd::audisp::audispd_zos_remote'
```

#### syslog

This pugin takes events and writes them to syslog. The arguments provided can be the default priority that you want the events written with. And optionally, you can give a second argument indicating the facility that you want events logged to. Valid options are LOG_LOCAL0 through 7.

To use this plugin:

```puppet
include '::auditd'
include '::auditd::audisp::syslog'
```

You can change the `args` for this plugin:

```puppet
include '::auditd'
class { '::auditd::audisp::syslog':
  # LOG_INFO is actually the default...
  args => 'LOG_INFO',
}
```

## Reference

### Classes

#### Public Classes

* `::auditd`: Installs auditd, manages main config, rules config and manages the service.

#### Private Classes

* `::auditd::params`: Parameter class that other classes inherit from.

### Global Parameters

#### `package_name`

The package name for auditd.

Defaults:

* Debian osfamily: `auditd`
* RedHat osfamily: `audit`
* Archlinux osfamily: `audit`
* Gentoo osfamily: `audit`

#### `manage_service`

Wether this module should manage the **auditd** service.
IMPORTANT: Only set to `false` if you use another module to manage **auditd** service.

Default: `true`

#### `service_ensure`

Ensure state of the **auditd** service.

Default: `running`

#### `service_enable`

Whether the **auditd** service should be enabled/disabled.

Default: `true`

#### `manage_audit_files`

If **true** then **/etc/audit/rules.d/** will be managed by this module. This means any rules not created using this module's defined type will be removed.

Defaults:

* EL7/SLES12: `true`
* Others: `false`

#### `rules_file`

The file that Audit rules should be added to.

Defaults:

* EL7: `/etc/audit/rules.d/puppet.rules`
* Others: `/etc/audit/audit.rules`

#### `log_file`

This keyword specifies the full path name to the log file where audit records will be stored. It must be a regular file.

Default: `/var/log/audit/audit.log`

#### `log_format`

The log format describes how the information should be stored on disk. There are 2 options: RAW and NOLOG. If set to RAW , the audit records will be stored in a format exactly as the kernel sends it. If this option is set to NOLOG then all audit information is discarded instead of writing to disk. This mode does not affect data sent to the audit event dispatcher.

Default: `RAW`

#### `log_group`

This  keyword  specifies  the  group  that is applied to the log file's permissions. The default is root. The group name can  be either numeric or spelled out.

Default: `root`

#### `write_logs`

This yes/no keyword determines whether or not to write logs to the disk. There are two options: yes and no. It is meant to replace the usage of `log_format = NOLOG`. This will default to undef since it is only available in version >= 2.5.2.

Default: `undef`

#### `priority_boost`

This is a non-negative number that tells the audit damon how much of a priority boost it should take. The default is 3. No change is 0.

Default: `4`

#### `flush`

Valid values are none, incremental, data, and sync. If set to none, no special effort is made to flush the audit records to disk. If set to incremental, Then the freq parameter is used to determine how often an explicit flush to disk is issued. The data parameter tells the audit daemon to keep the data portion of the disk file sync'd at all times. The sync option tells the audit daemon to keep both the data and meta-data fully sync'd with every write to disk.

Default: `incremental`

#### `freq`

This is a non-negative number that tells the audit damon how many records to write before issuing an explicit flush to disk command. this value is only valid when the flush keyword is set to incremental.

Default: `20`

#### `num_logs`

This keyword specifies the number of log files to keep if rotate is given as the max_log_file_action. If the number is < 2, logs are not rotated. This number must be 99 or less. The default is 0 - which means no rotation. As you increase the number of log files being rotated, you may need to adjust the kernel backlog setting upwards since it takes more time to rotate the files.

Default: `5`

#### `disp_qos`

This option controls whether you want blocking/lossless or non-blocking/lossy communication between the audit daemon and the dispatcher. There is a 128k buffer between the audit daemon and dispatcher. This is good enogh for most uses. If lossy is chosen, incoming events going to the dispatcher are discarded when this queue is full. (Events are still written to disk if log_format is not nolog.) Otherwise the auditd daemon will wait for the queue to have an empty spot before logging to disk. The risk is that while the daemon is waiting for network IO, an event is not being recorded to disk. Valid values are: lossy and lossless.

Default: `lossy`

#### `dispatcher`

The dispatcher is a program that is started by the audit daemon when it starts up. It will pass a copy of all audit events to that application's stdin. Make sure you trust the application that you add to this line since it runs with root privileges.

Default: `/sbin/audispd`

#### `name_format`

This option controls how computer node names are  inserted  into the  audit  event  stream.  It  has the following choices: none, hostname, fqd, numeric, and user.  None means that  no  computer name  is  inserted  into  the audit event.  hostname is the name returned by the gethostname syscall. The fqd means that it takes the  hostname  and  resolves  it  with dns for a fully qualified domain name of that machine.  Numeric is similar to  fqd  except it  resolves  the  IP  address of the machine.  User is an admin defined string from the name option.

Default: `none`

#### `admin`

This is the admin defined string that identifies the machine if user is given as the name_format option.

Default: `${::hostname}`

#### `max_log_file`

This keyword specifies the maximum file size in megabytes. When this limit is reached, it will trigger a configurable action. The value given must be numeric.

Default: `6`

### `max_log_file_action`

This parameter tells the system what action to take when the system has detected that the max file size limit has been reached. Valid values are ignore, syslog, suspend, rotate and keep_logs. If set to ignore, the audit daemon does nothing. syslog means that it will issue a warning to syslog. suspend will cause the audit daemon to stop writing records to the disk. The daemon will still be alive. The rotate option will cause the audit daemon to rotate the logs. It should be noted that logs with higher numbers are older than logs with lower numbers. This is the same convention used by the logrotate utility. The keep_logs option is similar to rotate except it does not use the num_logs setting. This prevents audit logs from being overwritten.

Default: `rotate`

#### `space_left`

This is a numeric value in megabytes that tells the audit daemon when to perform a configurable action because the system is starting to run low on disk space.

Default: `75`

#### `space_left_action`

This parameter tells the system what action to take when the system has detected that it is starting to get low on disk space. Valid values are ignore, syslog, email, suspend, single, and halt. If set to ignore, the audit daemon does nothing. syslog means that it will issue a warning to syslog. Email means that it will send a warning to the email account specified in action_mail_acct as well as sending the message to syslog. suspend will cause the audit daemon to stop writing records to the disk. The daemon will still be alive. The single option will cause the audit daemon to put the computer system in single user mode. halt option will cause the audit daemon to shutdown the computer system.

Default: `syslog`

#### `action_mail_acct`

This option should contain a valid email address or alias. The default address is root. If the email address is not local to the machine, you must make sure you have email properly configured on your machine and network. Also, this option requires that /usr/lib/sendmail exists on the machine.

Default: `root`

#### `admin_space_left`

This is a numeric value in megabytes that tells the audit daemon when to perform a configurable action because the system is running low on disk space. This should be considered the last chance to do something before running out of disk space. The numeric value for this parameter should be lower than the number for space_left.

Default: `50`

#### `admin_space_left_action`

This parameter tells the system what action to take when the system has detected that it is low on disk space. Valid values are ignore, syslog, email, suspend, single, and halt. If set to ignore, the audit daemon does nothing. Syslog means that it will issue a warning to syslog. Email means that it will send a warning to the email account specified in action_mail_acct as well as sending the message to syslog. Suspend will cause the audit daemon to stop writing records to the disk. The daemon will still be alive. The single option will cause the audit daemon to put the computer system in single user mode. halt option will cause the audit daemon to shutdown the computer system.

Default: `suspend`

#### `disk_full_action`

This parameter tells the system what action to take when the system has detected that the partition to which log files are written has become full. Valid values are ignore, syslog, suspend, single, and halt. If set to ignore, the audit daemon does nothing. Syslog means that it will issue a warning to syslog. Suspend will cause the audit daemon to stop writing records to the disk. The daemon will still be alive. The single option will cause the audit daemon to put the computer system in single user mode. halt option will cause the audit daemon to shutdown the computer system.

Default: `suspend`

### `disk_error_action`

This parameter tells the system what action to take whenever there is an error detected when writing audit events to disk or rotating logs. Valid values are ignore, syslog, suspend, single, and halt. If set to ignore, the audit daemon does nothing. Syslog means that it will issue a warning to syslog. Suspend will cause the audit daemon to stop writing records to the disk. The daemon will still be alive. The single option will cause the audit daemon to put the computer system in single user mode. halt option will cause the audit daemon to shutdown the computer system.

Default: `suspend`

#### `tcp_listen_port`

This  is  a  numeric  value  in  the  range  1..65535  which, if specified, causes auditd to listen on the corresponding TCP port for  audit  records from remote systems. The audit daemon may be linked with tcp_wrappers. You may want to controll  access  with an entry in the hosts.allow and deny files.

Default: `undef`

#### `tcp_listen_queue`

This  is  a  numeric  value  which  indicates  how  many pending (requested but unaccepted) connections are allowed.  The default is  5.   Setting  this  too  small  may  cause connections to be rejected if too many hosts start up at exactly  the  same  time, such as after a power failure.

Default: `5`

#### `tcp_max_per_addr`

This is a numeric value which indicates how many concurrent connections from one IP address is allowed. The default is 1 and the maximum is 16. Setting this too large may allow for a Denial of Service attack on the logging server. The default should be adequate in most cases unless a custom written recovery script runs to forward unsent events. In this case you would increase the number only large enough to let it in too.

Default: `1`

#### `tcp_client_ports`

This parameter may be a single numeric value or two values separated by a dash (no spaces allowed). It indicates which client ports are allowed for incoming connections. If not specified, any port is allowed. Allowed values are 1..65535. For example, to require the client use a privileged port, specify 1-1023 for this parameter. You will also need to set the local_port option in the audisp-remote.conf file. Making sure that clients send from a privileged port is a security feature to prevent log injection attacks by untrusted users.

Default: `undef`

#### `tcp_client_max_idle`

This parameter indicates the number of seconds that a client may be idle (i.e. no data from them at all) before auditd complains. This is used to close inactive connections if the client machine has a problem where it cannot shutdown the connection cleanly. Note that this is a global setting, and must be higher than any individual client heartbeat_timeout setting, preferably by a factor of two. The default is zero, which disables this check.

Default: `0`

#### `enable_krb5`

If set to "yes", Kerberos 5 will be used for authentication and encryption.

Default: `no`

#### `krb5_principal`

This is the principal for this server. The default is "auditd". Given this default, the server will look for a key named like auditd/hostname@EXAMPLE.COM stored in /etc/audit/audit.key to authenticate itself, where hostname is the canonical name for the server's host, as returned by a DNS lookup of its IP address.

Default: `auditd`

#### `krb5_key_file`

Location of the key for this client's principal. Note that the key file must be owned by root and mode 0400.

Default: `undef`

#### `buffer_size`

Value for Buffer size in `rules_file` header.

Default: `8192`

#### `audisp_q_depth`

This is a numeric value that tells how big to make the internal queue of the audit event dispatcher. A bigger queue lets it handle a flood of events better, but could hold events that are not processed when the daemon is terminated. If you get messages in syslog about events getting dropped, increase this value.

Default: `80`

#### `audisp_overflow_action`

This option determines how the daemon should react to overflowing its internal queue. When this happens, it means that more events are being received than it can get rid of. This error means that it is going to lose the current event its trying to dispatch. It has the following choices: ignore, syslog, suspend, single, and halt. If set to ignore, the audisp daemon does nothing. syslog means that it will issue a warning to syslog. suspend will cause the audisp daemon to stop processing events. The daemon will still be alive. The single option will cause the audisp daemon to put the computer system in single user mode. halt option will cause the audisp daemon to shutdown the computer system.

Default: `syslog`

#### `audisp_priority_boost`

This is a non-negative number that tells the audit event dispatcher how much of a priority boost it should take. This boost is in addition to the boost provided from the audit daemon. The default is 4. No change is 0.

Default: `4`

#### `audisp_max_restarts`

This is a non-negative number that tells the audit event dispatcher how many times it can try to restart a crashed plugin.

Default: `10`

#### `audisp_name_format`

This option controls how computer node names are inserted into the audit event stream. It has the following choices: none, hostname, fqd, numeric, and user. None means that no computer name is inserted into the audit event. hostname is the name returned by the gethostname syscall. The fqd means that it takes the hostname and resolves it with dns for a fully qualified domain name of that machine. Numeric is similar to fqd except it resolves the IP address of the machine. User is an admin defined string from the name option.

Default: `none`

#### `audisp_name`

This is the admin defined string that identifies the machine if user is given as the audisp_name_format option.

Default: `undef`


## Development

Contributions are welcome in any form, pull requests, and issues should be filed via GitHub.

### Testing

The following options are used for testing this module:

* Puppet Rspec:
  * Lint
  * Puppet Validator
  * Spec tests
* Travis CI (runs rspec tests):
  * Ruby 1.9.3 // Puppet 3.0
  * Ruby 2.0.0 // Puppet 3.0
  * Ruby 2.0.0 // Puppet 4.0
* Vagrant Smoke Tests:
  * CentOS 7.0 (PE & OS)
  * CentOS 6.6 (OS)
  * CentOS 5.11 (OS)
  * Ubuntu 14.04 (PE & OS)
  * Ubuntu 12.04 (OS)
  * Debian 7.8 (PE & OS)
  * Debian 6.0.10 (OS)

The Vagrant smoke tests use the Puppet Labs Vagrant boxes and so run Puppet Enterprise (PE) 3.8.1 & Puppet Open Source (OS) 4.2.1.

Some form of testing has occured on:

* CentOS 5/6/7
* Fedora 20/21
* SUSE 10/11/12
* Amazon Linux
* Debian 6/7/8
* Ubuntu 12.04/14.04
* Arch Linux
* Gentoo

Should also work without modification on:

* RHEL, Scientific Linux & Oracle Linux 5/6/7.
* None LTS Ubuntu releases.

Other distros should be easily supported, they just need some additional code and testing.

## Contributors

The list of contributors can be found at: [https://github.com/kemra102/puppet-auditd/graphs/contributors](https://github.com/kemra102/puppet-auditd/graphs/contributors)
