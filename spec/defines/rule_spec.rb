require 'spec_helper'

describe 'auditd::rule' do
  let :pre_condition do
    'class{"::auditd": } '
  end
  # Declare a default auditd::rule title, then use it in all context:
  let(:title) { 'Watch /etc/passwd for write and attrs' }
  context 'when only name is set' do
    let (:facts) {{
      :osfamily               => 'RedHat',
      :operatingsystem        => 'RedHat',
      :operatingsystemrelease => '7',
      :concat_basedir         => '/var/lib/puppet/concat',
    }}
    let(:params) {{
      order: '03',
    }}
    let(:title) { 'auditctl -w /etc/passwd -p wa -k passwd_changes' }
    it { is_expected.to contain_concat_fragment('auditd_fragment_auditctl -w /etc/passwd -p wa -k passwd_changes').
         with_target('/etc/audit/rules.d/puppet.rules').
         with_order('03')
    }
  end
  context 'when name AND content are set' do
    let (:facts) {{
      :osfamily               => 'RedHat',
      :operatingsystem        => 'RedHat',
      :operatingsystemrelease => '7',
      :concat_basedir         => '/var/lib/puppet/concat',
    }}
    let(:params) {{
      content: 'auditctl -w /etc/passwd -p wa -k passwd_changes',
      order: '02',
    }}
    it { is_expected.to contain_concat_fragment('auditd_fragment_Watch /etc/passwd for write and attrs').
         with_target('/etc/audit/rules.d/puppet.rules').
         with_order('02').
         with_content('auditctl -w /etc/passwd -p wa -k passwd_changes')
    }
  end
end
