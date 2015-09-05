# == Class: auditd::audisp
#
# This class manages the configuration of the main audisp configuration file.
#
# === Parameters
#
# [*q_depth*]
#   This is a numeric value that tells how big to make the internal queue of
#   the audit event dispatcher. A bigger queue lets it handle a flood of
#   events better, but could hold events that are not processed when the daemon
#   is terminated. If you get messages in syslog about events getting dropped,
#   increase this value.
#
# [*overflow_action*]
#   This option determines how the daemon should react to overflowing its
#   internal queue. When this happens, it means that more events are being
#   received than it can get rid of. This error means that it is going to lose
#   the current event its trying to dispatch. It has the following choices:
#   ignore, syslog, suspend, single, and halt. If set to ignore, the audisp
#   daemon does nothing. syslog means that it will issue a warning to syslog.
#   suspend will cause the audisp daemon to stop processing events. The daemon
#   will still be alive. The single option will cause the audisp daemon to put
#   the computer system in single user mode. halt option will cause the audisp
#   daemon to shutdown the computer system.
#
# [*priority_boost*]
#   This is a non-negative number that tells the audit event dispatcher how
#   much of a priority boost it should take. This boost is in addition to the
#   boost provided from the audit daemon. The default is 4. No change is 0.
#
# [*max_restarts*]
#   This is a non-negative number that tells the audit event dispatcher how
#   many times it can try to restart a crashed plugin.
#
# [*max_restarts*]
#   This option controls how computer node names are inserted into the audit
#   event stream. It has the following choices: none, hostname, fqd, numeric,
#   and user. None means that no computer name is inserted into the audit
#   event. hostname is the name returned by the gethostname syscall. The fqd
#   means that it takes the hostname and resolves it with dns for a fully
#   qualified domain name of that machine. Numeric is similar to fqd except it
#   resolves the IP address of the machine. User is an admin defined string
#   from the name option.
#
# [*audisp_name*]
#   This is the admin defined string that identifies the machine if user is
#   given as the name_format option.
#
class auditd::audisp (
  $q_depth         = 80,
  $overflow_action = 'syslog',
  $priority_boost  = 4,
  $max_restarts    = 10,
  $name_format     = 'none',
  $audisp_name     = undef,

) {

  validate_integer($q_depth)
  validate_re($overflow_action, '^(ignore|syslog|suspend|single|halt)$',
    "${overflow_action} is not supported for 'overflow_action'. Allowed values are 'ignore', 'syslog', 'suspend', 'single' & 'halt'.")
  validate_integer($priority_boost)
  validate_integer($max_restarts)
  if $audisp_name {
    validate_string($audisp_name)
  }

  file { '/etc/audisp/audispd.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('auditd/audispd.conf.erb'),
    require => Package['auditd'],
    notify  => Service['auditd'],
  }
}
