class auditd::config (

  $rules_path              = $::auditd::params::rules_path,

  # Config file variables
  $log_file                = $::auditd::params::log_file,
  $log_format              = $::auditd::params::log_format,
  $log_group               = $::auditd::params::log_group,
  $priority_boost          = $::auditd::params::priority_boost,
  $flush                   = $::auditd::params::flush,
  $freq                    = $::auditd::params::freq,
  $num_logs                = $::auditd::params::num_logs,
  $disp_qos                = $::auditd::params::disp_qos,
  $dispatcher              = $::auditd::params::dispatcher,
  $name_format             = $::auditd::params::name_format,
  $admin                   = $::auditd::params::admin,
  $max_log_file            = $::auditd::params::max_log_file,
  $max_log_file_action     = $::auditd::params::max_log_file_action,
  $space_left              = $::auditd::params::space_left,
  $space_left_action       = $::auditd::params::space_left_action,
  $action_mail_acct        = $::auditd::params::action_mail_acct,
  $admin_space_left        = $::auditd::params::admin_space_left,
  $admin_space_left_action = $::auditd::params::admin_space_left_action,
  $disk_full_action        = $::auditd::params::disk_full_action,
  $disk_error_action       = $::auditd::params::disk_error_action,
  $tcp_listen_port         = $::auditd::params::tcp_listen_port,
  $tcp_listen_queue        = $::auditd::params::tcp_listen_queue,
  $tcp_max_per_addr        = $::auditd::params::tcp_max_per_addr,
  $tcp_client_ports        = $::auditd::params::tcp_client_ports,
  $tcp_client_max_idle     = $::auditd::params::tcp_clients_max_idle,
  $enable_krb5             = $::auditd::params::enable_krb5,
  $krb5_principal          = $::auditd::params::krb5_principle,
  $krb5_key_file           = $::auditd::params::krb5_key_file,

  # Audit rules
  $control_rules           = $::auditd::params::control_rules,
  $fs_rules                = $::auditd::params::fs_rules,
  $systemcall_rules        = $::auditd::params::systemcall_rules,

) inherits auditd::params {

  validate_absolute_path($rules_path)

  validate_absolute_path($log_file)
  validate_re($log_format, '^(RAW|NOLOG)$',
    "${log_format} is not supported for log_format. Allowed values are 'RAW' and 'NOLOG'.")
  validate_string($log_group)
  validate_integer($priority_boost)
  validate_re($flush, '^(none|incremental|data|sync)$',
    "${flush} is not supported for flush. Allowed values are 'none', 'incremental', 'data' and 'sync'.")
  validate_integer($freq)
  validate_integer($num_logs)
  validate_re($disp_qos, '^(lossy|lossless)$',
    "${disp_qos} is not supported for disp_qos. Allowed values are 'lossy' and 'lossless'.")
  validate_absolute_path($dispatcher)
  validate_re($name_format, '^(none|hostname|fqd|numeric|user)$',
    "${name_format} is not supported for name_format. Allowed values are 'none', 'hostname', 'fqd', 'numeric' and 'user'.")
  validate_string($admin)
  validate_integer($max_log_file)
  validate_re($max_log_file_action, '^(ignore|syslog|suspend|rotate|keep_logs)$',
    "${max_log_file_action} is not supported for max_log_file_action. Allowed values are 'ignore', 'syslog', 'suspend', 'rotate' and 'keep_logs'.")
  validate_integer($space_left)
  validate_re($space_left_action, '^(ignore|syslog|email|exec|suspend|single|halt)$',
    "${space_left_action} is not supported for space_left_action. Allowed values are 'ignore', 'syslog', 'email', 'exec', 'suspend', 'single' and 'halt'.")
  validate_string($action_mail_acct)
  validate_integer($admin_space_left)
  validate_re($admin_space_left_action, '^(ignore|syslog|email|exec|suspend|single|halt)$',
    "${admin_space_left_action} is not supported for admin_space_left_action. Allowed values are 'ignore', 'syslog', 'email', 'exec', 'suspend', 'single' and 'halt'.")
  validate_re($disk_full_action, '^(ignore|syslog|exec|suspend|single|halt)$',
    "${disk_full_action} is not supported for disk_full_action. Allowed values are 'ignore', 'syslog', 'exec', 'suspend', 'single' and 'halt'.")
  validate_re($disk_error_action, '^(ignore|syslog|exec|suspend|single|halt)$',
    "${disk_error_action} is not supported for disk_error_action. Allowed values are 'ignore', 'syslog', 'exec', 'suspend', 'single' and 'halt'.")
  if $tcp_listen_port != undef {
    validate_integer($tcp_listen_port)
  }
  validate_integer($tcp_listen_queue)
  validate_integer($tcp_max_per_addr)
  if $tcp_client_ports != undef {
    validate_string($tcp_client_ports)
  }
  validate_integer($tcp_client_max_idle)
  validate_re($enable_krb5, '^(yes|no)$',
    "${enable_krb5} is not supported for enable_krb5. Allowed values are 'no' and 'yes'.")
  validate_string($krb5_principal)
  if $tcp_client_ports != undef {
    validate_abolute_path($krb5_key_file)
  }

  validate_array($control_rules)
  validate_array($fs_rules)
  validate_array($systemcall_rules)

  File {
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0640',
  }

  file { '/etc/audit/auditd.conf':
    content => template('auditd/auditd.conf.erb'),
  }
  file { $rules_path:
    content => template('auditd/audit.rules.erb'),
  }

}
