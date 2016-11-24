class { '::auditd':
  space_left_action       => 'email',
  action_mail_acct        => 'secadmin@example.com',
  admin_space_left_action => 'halt',
  max_log_file_action     => 'keep_logs',
}

auditd::rule { 'check for 64bit time adjustment syscalls':
  content => '-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change',
  order   => 1,
}
auditd::rule { 'check for 32bit time adjustment syscalls':
  content => '-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change',
  order   => 2,
}
auditd::rule { 'check for 64bit clock adjustment syscalls':
  content => '-a always,exit -F arch=b64 -S clock_settime -k time-change',
  order   => 3,
}
auditd::rule { 'check for 32bit clock adjustment syscalls':
  content => '-a always,exit -F arch=b32 -S clock_settime -k time-change',
  order   => 4,
}
auditd::rule { 'watch for changes to the local time file':
  content => '-w /etc/localtime -p wa -k time-change',
  order   => 5,
}
auditd::rule { 'watch for changes to group file':
  content => '-w /etc/group -p wa -k identity',
  order   => 6,
}
auditd::rule { 'watch for changes to passwd file':
  content => '-w /etc/passwd -p wa -k identity',
  order   => 7,
}
auditd::rule { 'watch for changes to gshadow file':
  content => '-w /etc/gshadow -p wa -k identity',
  order   => 8,
}
auditd::rule { 'watch for changes to shadow file':
  content => '-w /etc/shadow -p wa -k identity',
  order   => 9,
}
auditd::rule { 'watch for changes to opasswd file':
  content => '-w /etc/security/opasswd -p wa -k identity',
  order   => 10,
}
auditd::rule { 'check for 64bit hostname change syscalls':
  content => '-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale',
  order   => 11,
}
auditd::rule { 'check for 32bit hostname change syscalls':
  content => '-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale',
  order   => 12,
}
auditd::rule { 'watch for changes to issue notice file':
  content => '-w /etc/issue -p wa -k system-locale',
  order   => 13,
}
auditd::rule { 'watch for changes to issue.net notice file':
  content => '-w /etc/issue.net -p wa -k system-locale',
  order   => 14,
}
auditd::rule { 'watch for changes to hosts file':
  content => '-w /etc/hosts -p wa -k system-locale',
  order   => 15,
}
auditd::rule { 'watch for changes to network config file':
  content => '-w /etc/sysconfig/network -p wa -k system-locale',
  order   => 16,
}
