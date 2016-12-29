class auditd::audisp::syslog (

  String $args = 'LOG_INFO',

) {

  auditd::audisp::plugin { 'syslog':
    path => 'builtin_syslog',
    type => 'builtin',
    args => $args
  }

}
