class auditd::audisp::syslog (
  $active = flase,
  $args   = 'LOG_INFO',

) {

  auditd::audisp::plugin { 'syslog':
    path    => 'builtin_syslog',
    type    => 'builtin',
    active  => $active,
    args    => $args,
    require => Package['auditd'],
  }

}
