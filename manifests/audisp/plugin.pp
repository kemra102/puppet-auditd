define auditd::audisp::plugin (

  Stdlib::Absolutepath $path,
  Optional[String] $args,
  Boolean $active                  = true,
  Enum['out', 'in'] $direction     = 'out',
  Enum['builtin', 'always'] $type  = 'always',
  Enum['binary', 'string'] $format = 'string'

) {

  if $active == true {
    $real_active = 'yes'
  }
  elsif $active == false {
    $real_active = 'no'
  }

  file { "/etc/audisp/plugins.d/${name}.conf":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => epp("${module_name}/audisp.plugin.erb"),
    require => Package['auditd'],
    notify  => Service['auditd'],
  }

}
