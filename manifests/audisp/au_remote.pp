class auditd::audisp::au_remote {

  if ! defined(Package['audispd-plugins']) {
    package { 'audispd-plugins':
      ensure => 'present',
    }
  }

  auditd::audisp::plugin { 'au-remote':
    path    => '/sbin/audisp-remote',
    require => Package['audispd-plugins'],
  }

}
