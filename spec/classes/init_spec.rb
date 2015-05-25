require 'spec_helper'
describe 'auditd', :type => :class do
  context 'default parameters on RedHat 7' do
    let (:facts) {{
      :osfamily               => 'RedHat',
      :operatingsystemrelease => '7',
    }}
    it { 
      should contain_class('auditd')
      should contain_package('audit').with({
        'name'   => 'audit',
        'ensure' => 'present',
      })
      should contain_file('/etc/audit/auditd.conf').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0640',
      })
      should contain_concat('audit-file').with({
        'ensure'         => 'present',
        'path'           => '/etc/audit/rules.d/puppet.rules',
        'owner'          => 'root',
        'group'          => 'root',
        'mode'           => '0640',
        'ensure_newline' => 'true',
        'warn'           => 'true',
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
  context 'default parameters on RedHat 6' do
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
  context 'default parameters on Amazon Linux' do
    let (:facts) {{
      :osfamily        => 'RedHat',
      :operatingsystem => 'Amazon'
    }}
    it {
      should contain_service('auditd').with({
        'restart' => '/etc/init.d/auditd restart',
        'stop'    => '/etc/init.d/auditd stop',
      })
    }
  end
  context 'default parameters on Debian 8' do
    let (:facts) {{
      :osfamily          => 'Debian',
      :lsbmajdistrelease => '8',
    }}
    it {
      should contain_package('audit').with({
        'name' => 'auditd',
      })
      should contain_service('auditd').with({
        'restart' => '/bin/systemctl restart auditd',
        'stop'    => '/bin/systemctl stop auditd',
      })
    }
  end
  context 'default parameteres on Ubuntu 14.04' do
    let (:facts) {{
      :osfamily          => 'Debian',
      :operatingsystem   => 'Ubuntu',
      :lsbmajdistrelease => '14.04',
    }}
    it {
      should contain_package('audit').with({
        'name' => 'auditd',
      })
      should contain_service('auditd').with({
        'restart' => '/etc/init.d/auditd restart',
        'stop'    => '/etc/init.d/auditd stop',
      })
    }
  end
  context 'default parameters on Archlinux' do
    let (:facts) {{
      :osfamily => 'Archlinux',
    }}
    it {
      should contain_package('audit').with({
        'name' => 'audit',
      })
      should contain_service('auditd').with({
        'restart' => '/usr/bin/kill -s SIGHUP $(cat /var/run/auditd.pid)',
        'stop'    => '/usr/bin/kill -s SIGTERM $(cat /var/run/auditd.pid)',
      })
    }
  end
  context 'default parameters on Gentoo' do
    let (:facts) {{
      :osfamily => 'Gentoo',
    }}
    it {
      should contain_package('audit').with({
        'name' => 'audit',
      })
      should contain_service('auditd').with({
        'restart' => '/etc/init.d/auditd restart',
        'stop'    => '/etc/init.d/auditd stop',
      })
    }
  end
end
