include '::auditd'

auditd::rule { 'delete other rules':
  content => '-D',
  order   => '00',
}
auditd::rule { 'set larger buffer size':
  content => '-b 1024',
  order   => '01',
}
auditd::rule { 'check puppet config for changes':
  content => '-w /etc/puppet/ -p wa -k puppet_config_changes',
  order   => '02',
}
auditd::rule { 'check puppet data for changes':
  content => '-w /var/lib/puppet/ -p wa -k puppet_data_changes',
  order   => '03',
}
