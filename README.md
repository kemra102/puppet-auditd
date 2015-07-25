# auditd [![Build Status](https://travis-ci.org/kemra102/puppet-auditd.svg?branch=master)](https://travis-ci.org/kemra102/puppet-auditd)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with auditd](#setup)
    * [What auditd affects](#what-auditd-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with auditd](#beginning-with-auditd)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
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
  order   => 'Order rule should appear in rules file',
}
```

For example:

```puppet
include '::auditd'

auditd::rule { 'delete other rules':
 content => '-D',
  order   => '00',
}
auditd::rule { 'set buffer size':
  content => '-b 1024',
  order   => '01',
}
auditd::rule { 'watch for updates to users':
  content => '-w /etc/passwd -p wa -k identity',
  order   => '02',
}
auditd::rule { 'audit for time changes':
  content => '-a always,exit -S clock_settime -k time-change',
  order   => '03',
}
auditd::rule { '-a always,exit -S sethostname -S setdomainname -k system-locale':
  order   => '04',
}
```

As you can see from the last rule if you omit the content the name of the resource is taken as the content instead.

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

Whether the **auditd** service should be managed by Puppet.

Default: `true`

#### `service_ensure`

Ensure state of the **auditd** service

Default: `running`

#### `service_enable`

Whether the **auditd** service should be enabled/disabled

Default: `true`

#### `manage_audit_files`

If **true** then **/etc/audit/rules.d/** will be managed by this module. This means any rules not created using this module's defined type will be removed.

Defaults:

* EL7: `true`
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

Value for Buffer size in `rules_file` header

Default: `8192`

## Limitations

Tested on:

* CentOS 5/6/7
* Fedora 20/21
* SUSE 10/11/12
* Amazon Linux
* Debian 6/7/8
* Ubuntu 12.04/14.04
* Arch Linux
* Gentoo

Should also work without modification on:

* RHEL, Scientific Linux & Oracle Linux 5/6/7
* None LTS Ubuntu releases

Other distros should be easily supported, they just need some addtitional code and testing.

## Development

Contributions are welcome in any form, pull requests, and issues should be filed via GitHub.

## Contributors

The list of contributors can be found at: [https://github.com/kemra102/puppet-auditd/graphs/contributors](https://github.com/kemra102/puppet-auditd/graphs/contributors)
