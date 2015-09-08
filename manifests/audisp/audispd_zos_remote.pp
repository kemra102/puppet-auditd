class auditd::audisp::audispd_zos_remote {

  if ! defined(Package['audispd-plugins']) {
    package { 'audispd-plugins':
      ensure => 'present',
    }
  }

  auditd::audisp::plugin { 'audispd-zos-remote':
    path    => '/sbin/audispd-zos-remote',
    args    => '/etc/audisp/zos-remote.conf',
    require => Package['audispd-plugins'],
  }

}
