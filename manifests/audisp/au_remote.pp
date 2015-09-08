class auditd::audisp::au_remote {

  if ! defined(Package[$::auditd::params::audisp_package]) {
    package { $::auditd::params::audisp_package:
      ensure => 'present',
    }
  }

  auditd::audisp::plugin { 'au-remote':
    path    => '/sbin/audisp-remote',
    require => Package[$::auditd::params::audisp_package],
  }

}
