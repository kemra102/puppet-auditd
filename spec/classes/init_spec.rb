require 'spec_helper'
describe 'auditd', :type => :class do
  context 'default parameters on RedHat 7' do
    let (:facts) {{
      :osfamily               => 'RedHat',
      :operatingsystem        => 'RedHat',
      :operatingsystemrelease => '7',
      :concat_basedir         => '/var/lib/puppet/concat',
    }}
    it {
      should contain_class('auditd')
      should contain_package('audit').with({
        'ensure' => 'present',
        'name'   => 'audit',
      })
      should contain_file('/etc/audit/auditd.conf').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0640',
      })
      should contain_concat('/etc/audit/rules.d/puppet.rules').with({
        'ensure'         => 'present',
        'owner'          => 'root',
        'group'          => 'root',
        'mode'           => '0640',
        'ensure_newline' => 'true',
        'warn'           => 'true',
      })
      should_not contain_concat('/etc/audit/rules.d/puppet.rules').with({
        'alias' => 'audit-file',
      })
      should contain_service('auditd').with({
        'ensure'    => 'running',
        'enable'    => 'true',
        'hasstatus' => 'true',
        'restart'   => '/usr/libexec/initscripts/legacy-actions/auditd/restart',
        'stop'      => '/usr/libexec/initscripts/legacy-actions/auditd/stop',
      })
      should contain_file('/etc/audit/auditd.conf').with_content(/^flush = incremental_async$/)
    }
  end
  context 'default parameters on RedHat 6' do
    let (:facts) {{
      :osfamily               => 'RedHat',
      :operatingsystem        => 'RedHat',
      :operatingsystemrelease => '6',
      :concat_basedir         => '/var/lib/puppet/concat',
    }}
    it {
      should contain_service('auditd').with({
        'restart' => '/etc/init.d/auditd restart',
        'stop'    => '/etc/init.d/auditd stop',
      })
      should contain_file('/etc/audit/auditd.conf').with_content(/^flush = incremental$/)
    }
  end
  context 'default parameters on Amazon Linux' do
    let (:facts) {{
      :osfamily               => 'RedHat',
      :operatingsystemrelease => '7',
      :operatingsystem        => 'Amazon',
      :concat_basedir         => '/var/lib/puppet/concat',
    }}
    it {
      should contain_service('auditd').with({
        'restart' => '/etc/init.d/auditd restart',
        'stop'    => '/etc/init.d/auditd stop',
      })
      should contain_file('/etc/audit/auditd.conf').with_content(/^flush = incremental$/)
    }
  end
  context 'default parameters on Debian 8' do
    let (:facts) {{
      :osfamily               => 'Debian',
      :operatingsystem        => 'Debian',
      :operatingsystemrelease => '8',
      :concat_basedir         => '/var/lib/puppet/concat',
    }}
    it {
      should contain_package('auditd').with_name('auditd')
      should contain_service('auditd').with({
        'restart' => '/bin/systemctl restart auditd',
        'stop'    => '/bin/systemctl stop auditd',
      })
      should contain_file('/etc/audit/auditd.conf').with_content(/^flush = incremental$/)
    }
  end
  context 'default parameters on Debian 10' do
    let (:facts) {{
      :osfamily               => 'Debian',
      :operatingsystem        => 'Debian',
      :operatingsystemrelease => '10',
      :concat_basedir         => '/var/lib/puppet/concat',
    }}
    it {
      should contain_package('auditd').with_name('auditd')
      should contain_service('auditd').with({
        'restart' => '/bin/systemctl restart auditd',
        'stop'    => '/bin/systemctl stop auditd',
      })
      should contain_file('/etc/audit/auditd.conf').with_content(/^flush = incremental_async$/)
    }
  end
  context 'default parameteres on Ubuntu 14.04' do
    let (:facts) {{
      :osfamily               => 'Debian',
      :operatingsystem        => 'Ubuntu',
      :operatingsystemrelease => '14.04',
      :concat_basedir         => '/var/lib/puppet/concat',
    }}
    it {
      should contain_package('auditd').with_name('auditd')
      should contain_service('auditd').with({
        'restart' => '/etc/init.d/auditd restart',
        'stop'    => '/etc/init.d/auditd stop',
      })
      should contain_file('/etc/audit/auditd.conf').with_content(/^flush = incremental$/)
    }
  end
  context 'default parameteres on Ubuntu 16.04' do
    let (:facts) {{
      :osfamily               => 'Debian',
      :operatingsystem        => 'Ubuntu',
      :operatingsystemrelease => '16.04',
      :concat_basedir         => '/var/lib/puppet/concat',
    }}
    it {
      should contain_package('auditd').with_name('auditd')
      should contain_service('auditd').with({
        'restart' => '/bin/systemctl restart auditd',
        'stop'    => '/bin/systemctl stop auditd',
      })
      should contain_file('/etc/audit/auditd.conf').with_content(/^flush = incremental$/)
    }
  end
  context 'default parameteres on Ubuntu 18.04' do
    let (:facts) {{
      :osfamily               => 'Debian',
      :operatingsystem        => 'Ubuntu',
      :operatingsystemrelease => '18.04',
      :concat_basedir         => '/var/lib/puppet/concat',
    }}
    it {
      should contain_package('auditd').with_name('auditd')
      should contain_service('auditd').with({
        'restart' => '/bin/systemctl restart auditd',
        'stop'    => '/bin/systemctl stop auditd',
      })
      should contain_file('/etc/audit/auditd.conf').with_content(/^flush = incremental_async$/)
    }
  end
  context 'default parameters on Archlinux' do
    let (:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
      :concat_basedir  => '/var/lib/puppet/concat',
    }}
    it {
      should contain_package('audit')
      should contain_service('auditd').with({
        'restart' => '/usr/bin/kill -s SIGHUP $(cat /var/run/auditd.pid)',
        'stop'    => '/usr/bin/kill -s SIGTERM $(cat /var/run/auditd.pid)',
      })
      should contain_file('/etc/audit/auditd.conf').with_content(/^flush = incremental$/)
    }
  end
  context 'default parameters on Gentoo' do
    let (:facts) {{
      :osfamily        => 'Gentoo',
      :operatingsystem => 'Gentoo',
      :concat_basedir  => '/var/lib/puppet/concat',
    }}
    it {
      should contain_package('audit')
      should contain_service('auditd').with({
        'restart' => '/etc/init.d/auditd restart',
        'stop'    => '/etc/init.d/auditd stop',
      })
      should contain_file('/etc/audit/auditd.conf').with_content(/^flush = incremental$/)
    }
  end
  context 'auditd.conf is well-formed' do
    let (:facts) {{
      :osfamily               => 'RedHat',
      :operatingsystem        => 'RedHat',
      :operatingsystemrelease => '7',
    }}
    it {
      should_not contain_file('/etc/audit/auditd.conf').with_content(/=\s*$/)
    }
  end
end
