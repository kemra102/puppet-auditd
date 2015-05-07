class auditd::service (

  $manage_service = $::auditd::params::manage_service,
  $rules_path     = $::auditd::params::rules_path,

) inherits auditd::params {

  validate_bool($manage_service)
  validate_absolute_path($rules_path)

  if $manage_service == true {
    service { 'auditd':
      ensure     => 'running',
      enable     => true,
      hasrestart => true,
      hasstatus  => true,
      subscribe  => [
        File['/etc/audit/auditd.conf'],
        File["${rules_path}"],
      ],
    }
  }

}
