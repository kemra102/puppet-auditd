class { '::auditd':
  space_left_action       => 'email',
  action_mail_acct        => 'secadmin@example.com',
  admin_space_left_action => 'halt',
  max_log_file_action     => 'keep_logs',
  rules                   => {
    'watch for changes to passwd file' => {
      content => '-w /etc/passwd -p wa -k identity',
      order   => 1,
    },
    'watch for changes to hosts file'  => {
      content => '-w /etc/hosts -p wa -k system-locale',
      order   => 2,
    },
  },
}
