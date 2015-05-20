require 'spec_helper'
  describe 'auditd', :type => :class do
    context 'with defaults for all parameters' do
      let (:facts) {{
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '7',
      }}
      it { should contain_class('auditd') }
    end
end
