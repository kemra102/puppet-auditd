define auditd::audisp::plugin (
  $active    = true,
  $direction = 'out',
  $path      = undef,
  $type      = 'always',
  $args      = undef,
  $format    = 'string',

) {

  validate_bool($active)
  validate_re($direction, '^(out|in)$',
    "${direction} is not supported for 'direction'. Allowed values are 'out' and 'in'.")
  validate_string($path)
  validate_re($type, '^(builtin|always)$',
    "${type} is not supported for 'type'. Allowed values are 'builtin' and 'always'.")
  if $args {
    validate_string($args)
  }
  validate_re($format, '^(binary|string)$',
    "${format} is not supported for 'format'. Allowed values are 'binary' and 'string'.")

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
    content => template("${module_name}/audisp.plugin.erb"),
    notify  => Service['auditd'],
  }

}
