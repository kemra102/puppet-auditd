class auditd::params {

  # Give the option of managing the service.
  $manage_service = true

  # OS specific variables.
  case $::osfamily {
    'Debian': {
      $package_name = 'auditd'
      $rules_path   = '/etc/audit/audit.rules'
    }
    'RedHat': {
      $package_name = 'audit'

      if versioncmp($::operatingsystemrelease, '7') >= 0 {
        $rules_path = '/etc/audit/rules.d/audit.rules'
      } else {
        $rules_path = '/etc/audit/audit.rules'
      }
    }
    default: {
      fail("${::osfamily} is not supported by auditd")
    }
  }

  # Main config file variables
  $log_file                = '/var/log/audit/audit.log'
  $log_format              = 'RAW'
  $log_group               = 'root'
  $priority_boost          = '4'
  $flush                   = 'incremental'
  $freq                    = '20'
  $num_logs                = '5'
  $disp_qos                = 'lossy'
  $dispatcher              = '/sbin/audispd'
  $name_format             = 'none'
  $admin                   = "${::domain}"
  $max_log_file            = '6'
  $max_log_file_action     = 'rotate'
  $space_left              = '75'
  $space_left_action       = 'syslog'
  $action_mail_acct        = 'root'
  $admin_space_left        = '50'
  $admin_space_left_action = 'SUSPEND'
  $disk_full_action        = 'SUSPEND'
  $disk_error_action       = 'SUSPEND'
  $tcp_listen_port         = undef
  $tcp_listen_queue        = '5'
  $tcp_max_per_addr        = '1'
  $tcp_client_ports        = undef
  $tcp_client_max_idle     = '0'
  $enable_krb5             = 'no'
  $krb5_principal          = 'auditd'
  $krb5_key_file           = undef

  # Audit rules
  $control_rules           = []
  $fs_rules                = []
  $systemcall_rules        = []

}
