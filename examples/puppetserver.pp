include '::auditd'

auditd::rule { 'check puppet config for changes':
  content => '-w /etc/puppet/ -p wa -k puppet_config_changes',
  order   => 1,
}
auditd::rule { 'check puppet data for changes':
  content => '-w /var/lib/puppet/ -p wa -k puppet_data_changes',
  order   => 2,
}
