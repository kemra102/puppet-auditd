define auditd::audisp::plugin (
  Boolean $active                  = true,
  Enum['in', 'out'] $direction     = 'out',
  String $path                     = undef,
  Enum['builtin', 'always'] $type  = 'always',
  Optional[String] $args           = undef,
  Enum['binary', 'string'] $format = 'string',
) {

  if $active {
    $real_active = 'yes'
  } else {
    $real_active = 'no'
  }

  file { "/etc/audisp/plugins.d/${name}.conf":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("${module_name}/audisp.plugin.erb"),
    notify  => Service['auditd'],
  }

}
