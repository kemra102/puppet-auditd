class auditd::audisp::audispd_zos_remote (

  String $audisp_package

) {

  if ! defined(Package[$audisp_package]) {
    package { $audisp_package:
      ensure => 'present',
    }
  }

  auditd::audisp::plugin { 'audispd-zos-remote':
    path    => '/sbin/audispd-zos-remote',
    args    => '/etc/audisp/zos-remote.conf',
    require => Package[$audisp_package]
  }

}
