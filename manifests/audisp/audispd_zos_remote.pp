class auditd::audisp::audispd_zos_remote {

  if ! defined(Package[$::auditd::params::audisp_package]) {
    package { $::auditd::params::audisp_package:
      ensure => 'present',
    }
  }

  auditd::audisp::plugin { 'audispd-zos-remote':
    path    => '/sbin/audispd-zos-remote',
    args    => '/etc/audisp/zos-remote.conf',
    require => Package[$::auditd::params::audisp_package],
  }

}
