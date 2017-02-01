class auditd::audisp::cef (
  #local5 is 21<<3
  $facility = 168,

  # These two are possibly unused
  $remote_server = '127.0.0.1',
  $port = 514
) {

  package { 'audisp-cef':
    ensure => 'present',
  } ->
  auditd::audisp::plugin { 'au-cef':
    path => '/sbin/audisp-cef',
  }

  file { "/etc/audisp/audisp-cef.conf":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("${module_name}/audisp-cef.conf.erb"),
    notify  => Service['auditd'],
  }

}
