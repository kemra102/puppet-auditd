# @summary Create a group of related rules with a comment header
#
# @example Creating 'watch' rules
#   auditd::rule_group { 'Tools to change group identifiers':
#     rules => [
#       {
#         'files'       => ['/usr/sbin/groupadd','/usr/sbin/groupmod','/usr/sbin/addgroup'],
#         'permissions' => ['x'],
#         'keys'        => ['group_modification'],
#       }
#       {
#         'files'       => ['/usr/sbin/useradd','/usr/sbin/usermod','/usr/sbin/adduser'],
#         'permissions' => ['x'],
#         'keys'        => ['user_modification'],
#       }
#     ],
#   }
#
# @example Freeform syscall rules with default_keys set
#  auditd::rule_group { 'Kernel module loading and unloading':
#    rules => [
#      '-a always,exit -F perm=x -F auid!=-1 -F path=/sbin/insmod',
#      '-a always,exit -F perm=x -F auid!=-1 -F path=/sbin/modprobe',
#      '-a always,exit -F perm=x -F auid!=-1 -F path=/sbin/rmmod',
#    ],
#    default_keys => ['modules'],
#  }
#
# @param rules An array of rules to include.
# @param default_keys An array of keys you want added to every rule in this group
# @param comment The comment to use as a header for this group of rules.  Defaults to the `rule_group` title.
# @param order Where in the audit rules file to place this group.
define auditd::rule_group(
  Array[Variant[String[1],Auditd::WatchRule],1] $rules,
  Array[String[1]] $default_keys = [],
  String[1] $comment = $name,
  $order = 10,
)
{
  concat::fragment{ "auditd_rule_group_fragment_${name}":
    target  => $auditd::rules_file,
    order   => $order,
    content => epp('auditd/rule_group.epp',{'comment' => $comment, 'rules' => $rules, 'default_keys' => $default_keys, }),
  }
}
