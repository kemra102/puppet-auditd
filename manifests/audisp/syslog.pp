class auditd::audisp::syslog (
  $args = 'LOG_INFO',
  $path = $::auditd::params::syslog_path,
  $type = $::auditd::params::syslog_type,

) {

  auditd::audisp::plugin { 'syslog':
    path    => $path,
    type    => $type,
    args    => $args,
    require => Package['auditd'],
  }

}
