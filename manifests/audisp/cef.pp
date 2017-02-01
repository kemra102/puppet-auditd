class auditd::audisp::cef (
  #local5 is 21<<3
  $facility = 168,
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
