class auditd::audisp::au_remote (

  String $audisp_package

) {

  if ! defined(Package[$audisp_package]) {
    package { $audisp_package:
      ensure => 'present',
    }
  }

  auditd::audisp::plugin { 'au-remote':
    path    => '/sbin/audisp-remote',
    require => Package[$audisp_package]
  }

}
