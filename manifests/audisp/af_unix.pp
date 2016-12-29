class auditd::audisp::af_unix (

  String $args = '0640 /var/run/audispd_events'

) {

  auditd::audisp::plugin { 'af_unix':
    path => 'builtin_af_unix',
    type => 'builtin',
    args => $args
  }

}
