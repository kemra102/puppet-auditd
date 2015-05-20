require 'spec_helper'
describe 'auditd', :type => :class do
  context 'when called with no parameters on RedHat 7' do
    let (:facts) {{
      :osfamily               => 'RedHat',
      :operatingsystemrelease => '7',
    }}
    it { 
      should contain_class('auditd')
      should contain_package('audit').with({
        'ensure' => 'present',
      })
      should contain_file('/etc/audit/auditd.conf').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0640',
      })
      should contain_file('/etc/audit/audit.rules').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0640',
      })
      should contain_service('auditd').with({
        'ensure'    => 'running',
        'enable'    => 'true',
        'hasstatus' => 'true',
        'restart'   => '/usr/libexec/initscripts/legacy-actions/auditd/restart',
        'stop'      => '/usr/libexec/initscripts/legacy-actions/auditd/stop',
      })
    }
  end
  context 'when called with no parameters on RedHat 6' do
    let (:facts) {{
      :osfamily               => 'RedHat',
      :operatingsystemrelease => '6',
    }}
    it {
      should contain_service('auditd').with({
        'restart' => '/etc/init.d/auditd restart',
        'stop'    => '/etc/init.d/auditd stop',
      })
    }
  end
  context 'when called with no parameters on Debian 8' do
    let (:facts) {{
      :osfamily          => 'Debian',
      :lsbmajdistrelease => '8',
    }}
    it {
      should contain_package('auditd')
      should contain_service('auditd').with({
        'restart' => '/bin/systemctl restart auditd',
        'stop'    => '/bin/systemctl stop auditd',
      })
    }
  end
end
