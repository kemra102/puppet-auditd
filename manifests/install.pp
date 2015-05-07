class auditd::install (

  $package_name            = $::auditd::params::package_name,

) inherits auditd::params {

  validate_string($package_name)

  package { $package_name:
    ensure => 'present',
    before => [
      File['/etc/audit/auditd.conf'],
      File["$rules_path"],
    ],
  }

}
