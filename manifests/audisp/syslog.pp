class auditd::audisp::syslog (
  $args = 'LOG_INFO',

) {

  auditd::audisp::plugin { 'syslog':
    path    => 'builtin_syslog',
    type    => 'builtin',
    args    => $args,
    require => Package['auditd'],
  }

}
