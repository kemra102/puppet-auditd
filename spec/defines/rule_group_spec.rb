require 'spec_helper'

describe 'auditd::rule_group' do
  let (:facts) {{
    :osfamily               => 'RedHat',
    :operatingsystem        => 'RedHat',
    :operatingsystemrelease => '7',
    :concat_basedir         => '/var/lib/puppet/concat',
  }}
  let :pre_condition do
    'class{"auditd": } '
  end
  describe 'Reference example 1' do
    let(:title) { 'Tools to change group identifiers' }
    let(:params) {{
      rules: [
        {
          'files'       => ['/usr/sbin/groupadd','/usr/sbin/groupmod','/usr/sbin/addgroup'],
          'permissions' => ['x'],
          'keys'        => ['group_modification'],
        },
        {
          'files'       => ['/usr/sbin/useradd','/usr/sbin/usermod','/usr/sbin/adduser'],
          'permissions' => ['x'],
          'keys'        => ['user_modification'],
        }
      ],
    }}
    expected_content=<<-HEREDOC
# Tools to change group identifiers
-w /usr/sbin/groupadd -p x -k group_modification
-w /usr/sbin/groupmod -p x -k group_modification
-w /usr/sbin/addgroup -p x -k group_modification
-w /usr/sbin/useradd -p x -k user_modification
-w /usr/sbin/usermod -p x -k user_modification
-w /usr/sbin/adduser -p x -k user_modification

HEREDOC
    it { is_expected.to contain_concat_fragment('auditd_rule_group_fragment_Tools to change group identifiers').
         with_target('/etc/audit/rules.d/puppet.rules').
         with_content(expected_content).
         with_order(10)
    }
  end
  describe 'Reference example 2' do
    let(:title) { 'Kernel module loading and unloading' }
    let(:params) {{
      rules: [
        '-a always,exit -F perm=x -F auid!=-1 -F path=/sbin/insmod',
        '-a always,exit -F perm=x -F auid!=-1 -F path=/sbin/modprobe',
        '-a always,exit -F perm=x -F auid!=-1 -F path=/sbin/rmmod',
      ],
      default_keys: ['modules'],
    }}
    expected_content=<<-HEREDOC
# Kernel module loading and unloading
-a always,exit -F perm=x -F auid!=-1 -F path=/sbin/insmod -k modules
-a always,exit -F perm=x -F auid!=-1 -F path=/sbin/modprobe -k modules
-a always,exit -F perm=x -F auid!=-1 -F path=/sbin/rmmod -k modules

HEREDOC
    it { is_expected.to contain_concat_fragment('auditd_rule_group_fragment_Kernel module loading and unloading').
         with_target('/etc/audit/rules.d/puppet.rules').
         with_content(expected_content).
         with_order(10)
    }
  end
end
